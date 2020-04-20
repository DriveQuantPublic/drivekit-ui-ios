//
//  DiagnosisViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 20/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

protocol DiagnosisView : AnyObject {
    func update()
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
    private var stateByType = [StatusType:Bool]()
    private var viewModelByType = [StatusType:SensorStateViewModel]()


    override init() {
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        self.updateState()
    }


    @objc private func appDidBecomeActive() {
        self.updateState()
    }

    private func updateState() {
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
            self.updateView()
        }
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
                                self.updateView()
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
            self.viewModelByType[statusType] = SensorStateViewModel(statusType: statusType, valid: isValid)
            self.stateByType[statusType] = isValid
            updated = true
        } else {
            updated = false
        }
        return updated
    }

    private func updateGlobalStatus() {
        var numberOfInvalidStates = 0
        for state in self.stateByType.values {
            if state == false {
                numberOfInvalidStates += 1
            }
        }
        self.globalStatusViewModel = GlobalStateViewModel(errorNumber: numberOfInvalidStates)
    }

    private func updateView() {
        self.updateGlobalStatus()
        self.view?.update()
    }

}
