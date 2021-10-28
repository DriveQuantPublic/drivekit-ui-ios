//
//  OdometerHistoryDetailViewModel.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 26/10/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBVehicleAccessModule
import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitVehicleModule

enum HistoryCellType {
    case distance(DKVehicleOdometerHistory?)
    case date(DKVehicleOdometerHistory?)
    case vehicle(DKVehicle)

    var isEditable: Bool {
        switch self {
            case .distance, .date:
                return true
            case .vehicle:
                return false
        }
    }

    var image: UIImage? {
        switch self {
            case .distance:
                return DKImages.ecoAccel.image
            case .date:
                return DKImages.calendar.image
            case .vehicle(let vehicle):
                return vehicle.getVehicleImage()
        }
    }

    var placeholder: String {
        switch self {
            case .distance:
                return "dk_vehicle_odometer_mileage_kilometer".dkVehicleLocalized()
            case .date:
                return ""
            case .vehicle:
                return ""
        }
    }

    var value: String {
        switch self {
            case let .distance(history):
                if let history = history {
                    return history.distance.formatKilometerDistance(minDistanceToRemoveFractions: 0)
                }
            case let .date(history):
                let date: Date
                if let history = history {
                    date = history.updateDate ?? Date()
                } else {
                    date = Date()
                }
                return date.format(pattern: .fullDate)
            case let .vehicle(vehicle):
                return vehicle.computeName()
        }
        return ""
    }
}

class OdometerHistoryDetailViewModel {
    let isEditable: Bool
    var updatedValue: Double? = nil {
        didSet {
            print("updatedValue = \(updatedValue)")
        }
    }
    private var vehicle: DKVehicle
    private var odometer: DKVehicleOdometer?
    private var history: DKVehicleOdometerHistory?
    private var previousHistory: DKVehicleOdometerHistory?
    private let historiesNumber: Int
    private var cellTypes: [HistoryCellType]

    static func addHistoryViewModel(vehicle: DKVehicle, odometer: DKVehicleOdometer?, odometerHistories: [DKVehicleOdometerHistory]?) -> OdometerHistoryDetailViewModel {
        let sortedHistories = odometerHistories?.sorted { $0.updateDate ?? Date() > $1.updateDate ?? Date() }
        return OdometerHistoryDetailViewModel(vehicle: vehicle, odometer: odometer, history: nil, previousHistory: sortedHistories?.first, historiesNumber: odometerHistories?.count ?? 0, isEditable: true)
    }

    static func updateHistoryViewModel(vehicle: DKVehicle, odometer: DKVehicleOdometer?, history: DKVehicleOdometerHistory?, previousHistory: DKVehicleOdometerHistory?, historiesNumber: Int, isEditable: Bool) -> OdometerHistoryDetailViewModel {
        return OdometerHistoryDetailViewModel(vehicle: vehicle, odometer: odometer, history: history, previousHistory: previousHistory, historiesNumber: historiesNumber, isEditable: isEditable)
    }

    init(vehicle: DKVehicle, odometer: DKVehicleOdometer?, history: DKVehicleOdometerHistory?, previousHistory: DKVehicleOdometerHistory?, historiesNumber: Int, isEditable: Bool) {
        self.vehicle = vehicle
        self.odometer = odometer
        self.history = history
        self.historiesNumber = historiesNumber
        self.isEditable = isEditable
        self.cellTypes = [.distance(history), .date(history), .vehicle(vehicle)]
    }

    func getOdometerHistoryDetailCellViewModel(at index: Int) -> OdometerHistoryDetailCellViewModel {
        return OdometerHistoryDetailCellViewModel(type: self.cellTypes[index], isEditable: self.isEditable)
    }

    func canDelete() -> Bool {
        return self.history != nil && self.historiesNumber > 1
    }

    func validateHistory(viewController: UIViewController) {
        if self.history != nil {
            #warning("TODO: tracking")
//            track(page: "maintenance-histories-edit")
            updateHistory(viewController: viewController)
        } else {
            #warning("TODO: tracking")
//            track(page: "maintenance-histories-add")
            addHistory(viewController: viewController)
        }
    }

    private func addHistory(viewController: UIViewController) {
        if let distance = self.updatedValue {
            if distance >= self.odometer?.distance ?? 0 {
                viewController.showLoader()
                DriveKitVehicle.shared.addOdometerHistory(vehicleId: self.vehicle.vehicleId, distance: distance) { [weak viewController] status, Odometer, histories in
                    DispatchQueue.dispatchOnMainThread {
                        if let viewController = viewController {
                            viewController.hideLoader()
                            if status == .success {
                                #warning("TODO: tracking")
//                            track(page: "maintenance_new_reference")
                                let alert = UIAlertController(title: Bundle.main.appName ?? "",
                                                              message: "dk_vehicle_odometer_reference_add_success".dkVehicleLocalized(),
                                                              preferredStyle: .alert)
                                let okAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: { action in
                                    viewController.navigationController?.popViewController(animated: true)
                                })
                                alert.addAction(okAction)
                                viewController.present(alert, animated: true)
                            } else if status == .error {
                                viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: DKCommonLocalizable.error.text(), back: false, cancel: false)
                            } else if status == .vehicleNotFound {
                                viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: "dk_vehicle_not_found".dkVehicleLocalized(), back: false, cancel: false)
                            } else if status == .badDistance {
                                viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: "dk_vehicle_odometer_bad_distance".dkVehicleLocalized(), back: false, cancel: false)
                            }
                        }
                    }
                }
            } else {
                viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: "dk_vehicle_odometer_reference_error_value".dkVehicleLocalized(), back: false, cancel: false)
            }
        }
    }

    private func updateHistory(viewController: UIViewController) {
        if let distance = self.updatedValue, let history = self.history {
            if distance >= self.previousHistory?.distance ?? 0 {
                viewController.showLoader()
                DriveKitVehicle.shared.updateOdometerHistory(vehicleId: self.vehicle.vehicleId, historyId: String(history.historyId), distance: distance) { [weak viewController] status, Odometer, histories in
                    DispatchQueue.dispatchOnMainThread {
                        if let viewController = viewController {
                            viewController.hideLoader()
                            if status == .success {
                                #warning("TODO: tracking")
//                            track(page: "maintenance_new_reference")
                                let alert = UIAlertController(title: Bundle.main.appName ?? "",
                                                              message: "dk_vehicle_odometer_reference_update_success".dkVehicleLocalized(),
                                                              preferredStyle: .alert)
                                let okAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: { action in
                                    viewController.navigationController?.popViewController(animated: true)
                                })
                                alert.addAction(okAction)
                                viewController.present(alert, animated: true)
                            } else {
                                let message: String?
                                switch status {
                                    case .error:
                                        message = DKCommonLocalizable.error.text()
                                    case .badDistance:
                                        message = "dk_vehicle_odometer_bad_distance".dkVehicleLocalized()
                                    case .historyNotFound:
                                        message = "dk_vehicle_odometer_history_not_found".dkVehicleLocalized()
                                    case .vehicleNotFound:
                                        message = "dk_vehicle_not_found".dkVehicleLocalized()
                                    case .success:
                                        message = nil
                                }
                                if let message = message {
                                    viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: message, back: false, cancel: false)
                                }
                            }
                        }
                    }
                }
            } else {
                viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: "dk_vehicle_odometer_reference_error_value".dkVehicleLocalized(), back: false, cancel: false)
            }
        }
    }

    func deleteHistory(viewController: UIViewController) {
        if let history = self.history {
            viewController.showLoader()
            DriveKitVehicle.shared.deleteOdometerHistory(vehicleId: self.vehicle.vehicleId, historyId: String(history.historyId)) { [weak viewController] status, odometer, histories in
                DispatchQueue.dispatchOnMainThread {
                    if let viewController = viewController {
                        viewController.hideLoader()
                        if status == .success {
                            let alert = UIAlertController(title: Bundle.main.appName ?? "",
                                                          message: "dk_vehicle_odometer_reference_delete_success".dkVehicleLocalized(),
                                                          preferredStyle: .alert)
                            let okAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: { action in
                                viewController.navigationController?.popViewController(animated: true)
                            })
                            alert.addAction(okAction)
                            viewController.present(alert, animated: true)
                        } else {
                            let message: String?
                            switch status {
                                case .error:
                                    message = DKCommonLocalizable.error.text()
                                case .lastOdometerError:
                                    message = "dk_vehicle_odometer_last_history_error".dkVehicleLocalized()
                                case .historyNotFound:
                                    message = "dk_vehicle_odometer_history_not_found".dkVehicleLocalized()
                                case .vehicleNotFound:
                                    message = "dk_vehicle_not_found".dkVehicleLocalized()
                                case .success:
                                    message = nil
                            }
                            if let message = message {
                                viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: message, back: false, cancel: false)
                            }
                        }
                    }
                }
            }
        }
    }
}
