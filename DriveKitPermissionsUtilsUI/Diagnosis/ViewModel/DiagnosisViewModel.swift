//
//  DiagnosisViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 20/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import MessageUI

import DriveKitCommonUI

protocol DiagnosisView : UIViewController {
    func updateSensorsUI()
    func updateBatteryOptimizationUI()
    func updateContactUI()
    func updateLoggingUI()
}

class DiagnosisViewModel : NSObject {

    weak var view: DiagnosisView? = nil
    private(set) var globalStatusViewModel: GlobalStateViewModel? = nil
    var activityStatusViewModel: SensorStateViewModel? {
        get {
            self.viewModelByType[.activity]
        }
    }
    var bluetoothStatusViewModel: SensorStateViewModel? {
        get {
            self.viewModelByType[.bluetooth]
        }
    }
    var locationStatusViewModel: SensorStateViewModel? {
        get {
            self.viewModelByType[.location]
        }
    }
    var connectionStatusViewModel: SensorStateViewModel? {
        get {
            self.viewModelByType[.network]
        }
    }
    var notificationStatusViewModel: SensorStateViewModel? {
        get {
            self.viewModelByType[.notification]
        }
    }
    let batteryOptimizationViewModel = BatteryOptimizationViewModel()
    private(set) var contactViewModel: ContactViewModel? = nil
    private(set) var loggingViewModel: LoggingViewModel? = nil
    private lazy var requestPermissionHelper: RequestPermissionHelper = RequestPermissionHelper()
    private var stateByType = [StatusType:Bool]()
    private var viewModelByType = [StatusType:SensorStateViewModel]()
    private var isAppActive = true


    override init() {
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateSensorsState), name: .sensorStateChangedNotification, object: nil)

        self.updateState()
    }


    func performDialogAction(for statusType: StatusType, isValid: Bool) {
        if !isValid {
            var openSettingsImmediatly = false
            switch statusType {
                case .activity:
                    self.requestPermissionHelper.requestPermission(.activity)
                case .bluetooth:
                    self.requestPermissionHelper.requestPermission(.bluetooth)
                case .location:
                    self.requestPermissionHelper.requestPermission(.location)
                case .network:
                    openSettingsImmediatly = true
                case .notification:
                    self.requestPermissionHelper.requestNotificationPermission()
            }
            if openSettingsImmediatly {
                DKDiagnosisHelper.shared.openSettings()
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
                    if self.isAppActive {
                        // No system alert has been presented. Open settings.
                        DKDiagnosisHelper.shared.openSettings()
                    }
                })
            }
        }
    }

    func showDialog(for statusType: StatusType, isValid: Bool) {
        if let view = self.view {
            let sensorInfoViewModel = SensorInfoViewModel(statusType: statusType, isValid: isValid, diagnosisViewModel: self)
            let sensorInfoViewController = SensorInfoViewController(viewModel: sensorInfoViewModel)
            sensorInfoViewController.modalPresentationStyle = .overFullScreen
            sensorInfoViewController.modalTransitionStyle = .crossDissolve
            view.present(sensorInfoViewController, animated: true, completion: nil)
        }
    }

    func contactSupport(contactType: DKContactType) {
        switch contactType {
            case let .web(url):
                openUrl(url)
            case let .email(contentMail):
                sendMail(contentMail)
                break
            case .none:
                break
        }
    }

    func setLoggingEnabled(_ enabled: Bool) {
        if let loggingViewModel = self.loggingViewModel {
            loggingViewModel.setLoggingEnabled(enabled)
            self.view?.updateLoggingUI()
        }
    }

    @objc private func appDidBecomeActive() {
        self.isAppActive = true
        self.updateState()
    }

    @objc private func appWillResignActive() {
        self.isAppActive = false
    }

    @objc private func updateSensorsState() {
        let manageBluetooth = DriveKitPermissionsUtilsUI.shared.isBluetoothNeeded
        let isActivityUpdated = self.updateState(.activity)
        let isLocationUpdated = self.updateState(.location)
        let isNetworkUpdated = self.updateState(.network)
        let isNotificationUpdated = self.updateState(.notification)
        let isBluetoothUpdated: Bool
        if manageBluetooth {
            isBluetoothUpdated = self.updateState(.bluetooth)
        } else {
            if self.viewModelByType[.bluetooth] != nil {
                self.viewModelByType[.bluetooth] = nil
                self.stateByType[.bluetooth] = nil
                isBluetoothUpdated = true
            } else {
                isBluetoothUpdated = false
            }
        }
        let newState = self.globalStatusViewModel == nil || isActivityUpdated || isBluetoothUpdated || isLocationUpdated || isNetworkUpdated || isNotificationUpdated
        if newState {
            self.updateSensorsUI()
        }
    }

    private func updateState() {
        // Sensors state.
        updateSensorsState()

        // Battery optimization.
        self.batteryOptimizationViewModel.update()
        self.view?.updateBatteryOptimizationUI()

        // Contact & Logging.
        let contactType = DriveKitPermissionsUtilsUI.shared.contactType
        let contactByMail: Bool
        switch contactType {
            case .none:
                self.contactViewModel = nil
                contactByMail = false
            case .email(_):
                self.contactViewModel = ContactViewModel(contactType: contactType, diagnosisViewModel: self)
                contactByMail = true
            case .web(_):
                self.contactViewModel = ContactViewModel(contactType: contactType, diagnosisViewModel: self)
                contactByMail = false
        }

        if DriveKitPermissionsUtilsUI.shared.showDiagnosisLogs {
            let loggingViewModel = LoggingViewModel()
            loggingViewModel.setContactByMailEnabled(contactByMail)
            self.loggingViewModel = loggingViewModel
        } else {
            self.loggingViewModel = nil
        }
        self.view?.updateContactUI()
        self.view?.updateLoggingUI()
    }

    private func updateState(_ statusType: StatusType) -> Bool {
        let diagnosisHelper = DKDiagnosisHelper.shared
        let isValid: Bool
        switch statusType {
            case .activity:
                isValid = diagnosisHelper.isActivityValid()
            case .bluetooth:
                isValid = diagnosisHelper.isBluetoothValid()
            case .location:
                isValid = diagnosisHelper.isLocationValid()
            case .network:
                isValid = diagnosisHelper.isNetworkValid()
            case .notification:
                isValid = self.stateByType[.notification] ?? false
                diagnosisHelper.isNotificationValid { [weak self] isValid in
                    if let self = self {
                        let updated = self.updateInternalState(statusType, isValid: isValid)
                        if updated {
                            self.updateSensorsUI()
                        }
                    }
                }
        }
        let updated = self.updateInternalState(statusType, isValid: isValid)
        return updated
    }

    private func updateInternalState(_ statusType: StatusType, isValid: Bool) -> Bool {
        let updated: Bool
        if self.viewModelByType[statusType] == nil || self.stateByType[statusType] != isValid {
            self.viewModelByType[statusType] = SensorStateViewModel(statusType: statusType, valid: isValid, diagnosisViewModel: self)
            self.stateByType[statusType] = isValid
            updated = true
        } else {
            updated = false
        }
        return updated
    }

    private func updateSensorsUI() {
        var numberOfInvalidStates = 0
        for state in self.stateByType.values {
            if state == false {
                numberOfInvalidStates += 1
            }
        }
        self.globalStatusViewModel = GlobalStateViewModel(errorNumber: numberOfInvalidStates)
        self.view?.updateSensorsUI()
    }


    private func openUrl(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func sendMail(_ contentMail: DKContentMail) {
        if let view = self.view {
            if MFMailComposeViewController.canSendMail()  {
                let mailComposerVC = MFMailComposeViewController()
                if let logFileUrl = self.loggingViewModel?.getLogFileUrl() {
                    do {
                        let attachementData = try Data(contentsOf: logFileUrl)
                        let fileName = logFileUrl.lastPathComponent
                        mailComposerVC.addAttachmentData(attachementData, mimeType: "text/plain", fileName: fileName)
                    } catch let error {
                        print("Error while attaching LogFile to Mail : \(error.localizedDescription)")
                    }
                }
                mailComposerVC.mailComposeDelegate = self
                mailComposerVC.setToRecipients(contentMail.getRecipients())
                mailComposerVC.setBccRecipients(contentMail.getBccRecipients())
                mailComposerVC.setMessageBody(getMailBody(contentMail), isHTML: false)
                mailComposerVC.setSubject(contentMail.getSubject())
                view.present(mailComposerVC, animated: true)
            } else {
                view.showAlertMessage(title: nil, message: DKCommonLocalizable.sendMailError.text(), back: false, cancel: false)
            }
        }
    }

    private func getMailBody(_ contentMail: DKContentMail) -> String {
        if contentMail.overrideMailBodyContent() {
            return contentMail.getMailBody()
        } else {
            return contentMail.getMailBody() + "\n\n" + DriveKitPermissionsUtilsUI.shared.getSensorsDescription()
        }
    }

}

extension DiagnosisViewModel : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result != .failed {
            controller.dismiss(animated: true)
        }
    }
}
