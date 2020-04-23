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

    private func updateState() {
        // Sensors state.
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

        // Battery optimization.
        self.batteryOptimizationViewModel.update()
        self.view?.updateBatteryOptimizationUI()

        // Contact.
        switch DriveKitPermissionsUtilsUI.shared.contactType {
            case .none:
                self.contactViewModel = nil
            case .email(_), .web(_):
                self.contactViewModel = ContactViewModel(contactType: DriveKitPermissionsUtilsUI.shared.contactType, diagnosisViewModel: self)

        }
        self.view?.updateContactUI()

        // Logging.
        if DriveKitPermissionsUtilsUI.shared.showDiagnosisLogs {
            self.loggingViewModel = LoggingViewModel()
        } else {
            self.loggingViewModel = nil
        }
        self.view?.updateLoggingUI()
    }

    private func updateState(_ statusType: StatusType) -> Bool {
        let diagnosisHelper = DKDiagnosisHelper.shared
        let isValid: Bool
        switch statusType {
            case .activity:
                isValid = diagnosisHelper.getPermissionStatus(.activity) == .valid
            case .bluetooth:
                isValid = diagnosisHelper.isSensorActivated(.bluetooth) && diagnosisHelper.getPermissionStatus(.bluetooth) == .valid
            case .location:
                isValid = diagnosisHelper.isSensorActivated(.gps) && diagnosisHelper.getPermissionStatus(.location) == .valid
            case .network:
                isValid = diagnosisHelper.isNetworkReachable()
            case .notification:
                isValid = self.stateByType[.notification] ?? false
                diagnosisHelper.getNotificationPermissionStatus { [weak self] (permissionStatus) in
                    if let self = self {
                        DispatchQueue.main.async {
                            let isValid = permissionStatus == .valid
                            let updated = self.updateInternalState(statusType, isValid: isValid)
                            if updated {
                                self.updateSensorsUI()
                            }
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
                if self.loggingViewModel?.isLoggingEnabled ?? false {
                    #warning("TODO: Get path of log file or let DriveKitLog insert it to mailComposerVC. Do not build it.")
                    let calendar = Calendar.current
                    let currentDate = Date()
                    let logFileName = "log-" + String(calendar.component(.year, from: currentDate)) + "-" + String(calendar.component(.month, from: currentDate)) + ".txt"
                    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(logFileName)
                    do {
                        let attachementData = try Data(contentsOf: filePath)
                        mailComposerVC.addAttachmentData(attachementData, mimeType: "text/plain", fileName: logFileName)
                    } catch let error {
                        print("Error while attaching LogFile to Mail : \(error.localizedDescription)")
                    }
                }
                mailComposerVC.mailComposeDelegate = self
                mailComposerVC.setToRecipients(contentMail.getRecipients())
                mailComposerVC.setBccRecipients(contentMail.getBccRecipients())
                mailComposerVC.setMessageBody(contentMail.getMailBody(), isHTML: false)
                mailComposerVC.setSubject(contentMail.getSubject())
                view.present(mailComposerVC, animated: true)
            } else {
                view.showAlertMessage(title: nil, message: "TODO", back: false, cancel: false)
            }
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
