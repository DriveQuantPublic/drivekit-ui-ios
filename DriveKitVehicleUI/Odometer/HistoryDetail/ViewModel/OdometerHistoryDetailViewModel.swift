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
    case vehicle(DKVehicle?)

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
                return vehicle?.getVehicleImage()
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
                return date.format(pattern: .fullDate).capitalizeFirstLetter()
            case let .vehicle(vehicle):
                return vehicle?.computeName() ?? ""
        }
        return ""
    }
}

class OdometerHistoryDetailViewModel {
    let vehicleId: String
    let isEditable: Bool
    var updatedValue: Double?
    private let vehicle: DKVehicle?
    private let odometer: DKVehicleOdometer?
    private let history: DKVehicleOdometerHistory?
    private let previousHistory: DKVehicleOdometerHistory?
    private let historiesNumber: Int
    private let cellTypes: [HistoryCellType]

    init(vehicleId: String, historyId: Int?, previousHistoryId: Int?, isEditable: Bool) {
        self.vehicleId = vehicleId
        self.vehicle = DriveKitVehicle.getVehicle(withId: vehicleId)
        self.odometer = self.vehicle?.odometer
        if let histories = self.vehicle?.odometerHistories {
            self.historiesNumber = histories.count
            if let historyId = historyId, let history = histories.first(where: { $0.historyId == historyId }) {
                self.history = history
            } else {
                self.history = nil
            }
            if let previousHistoryId = previousHistoryId, let previousHistory = histories.first(where: { $0.historyId == previousHistoryId }) {
                self.previousHistory = previousHistory
            } else {
                self.previousHistory = nil
            }
        } else {
            self.historiesNumber = 0
            self.history = nil
            self.previousHistory = nil
        }
        self.isEditable = isEditable
        self.cellTypes = [.distance(self.history), .date(self.history), .vehicle(self.vehicle)]
    }

    func getTitle() -> String {
        if self.history == nil {
            return "dk_vehicle_odometer_history_add".dkVehicleLocalized()
        } else {
            return "dk_vehicle_odometer_history_update".dkVehicleLocalized()
        }
    }

    func getOdometerHistoryDetailCellViewModel(at index: Int) -> OdometerHistoryDetailCellViewModel {
        return OdometerHistoryDetailCellViewModel(initialDistance: self.history?.distance, type: self.cellTypes[index], isEditable: self.isEditable)
    }

    func canDelete() -> Bool {
        return self.history != nil && self.historiesNumber > 1
    }

    func validateHistory(viewController: UIViewController, showConfirmationAlert: Bool = true, completion: @escaping () -> Void) {
        if self.history != nil {
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_vehicles_odometer_histories_edit", viewController: viewController)
            updateHistory(viewController: viewController, showConfirmationAlert: showConfirmationAlert, completion: completion)
        } else {
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_vehicles_odometer_histories_add", viewController: viewController)
            addHistory(viewController: viewController, showConfirmationAlert: showConfirmationAlert, completion: completion)
        }
    }

    private func addHistory(viewController: UIViewController, showConfirmationAlert: Bool, completion: @escaping () -> Void) {
        if let vehicle = self.vehicle, let distance = self.updatedValue {
            if distance >= self.odometer?.distance ?? 0 {
                if distance >= 1_000_000 {
                    viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: "dk_vehicle_odometer_history_error".dkVehicleLocalized(), back: false, cancel: false)
                } else {
                    viewController.showLoader()
                    DriveKitVehicle.shared.addOdometerHistory(vehicleId: vehicle.vehicleId, distance: distance) { [weak viewController] status, _, _ in
                        DispatchQueue.dispatchOnMainThread {
                            if let viewController = viewController {
                                viewController.hideLoader()
                                if status == .success {
                                    if showConfirmationAlert {
                                        let alert = UIAlertController(title: Bundle.main.appName ?? "",
                                                                      message: "dk_vehicle_odometer_history_add_success".dkVehicleLocalized(),
                                                                      preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: { _ in
                                            completion()
                                        })
                                        alert.addAction(okAction)
                                        viewController.present(alert, animated: true)
                                    } else {
                                        completion()
                                    }
                                } else if status == .error {
                                    viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: "dk_vehicle_odometer_failed_to_sync".dkVehicleLocalized(), back: false, cancel: false)
                                } else if status == .vehicleNotFound {
                                    viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: "dk_vehicle_not_found".dkVehicleLocalized(), back: false, cancel: false)
                                } else if status == .badDistance {
                                    viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: "dk_vehicle_odometer_bad_distance".dkVehicleLocalized(), back: false, cancel: false)
                                }
                            }
                        }
                    }
                }
            } else {
                viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: "dk_vehicle_odometer_history_error_value".dkVehicleLocalized(), back: false, cancel: false)
            }
        }
    }

    private func updateHistory(viewController: UIViewController, showConfirmationAlert: Bool, completion: @escaping () -> Void) {
        if let vehicle = self.vehicle, let distance = self.updatedValue, let history = self.history {
            if distance >= self.previousHistory?.distance ?? 0 {
                if distance >= 1_000_000 {
                    viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: "dk_vehicle_odometer_history_error".dkVehicleLocalized(), back: false, cancel: false)
                } else {
                    viewController.showLoader()
                    DriveKitVehicle.shared.updateOdometerHistory(vehicleId: vehicle.vehicleId, historyId: String(history.historyId), distance: distance) { [weak viewController] status, _, _ in
                        DispatchQueue.dispatchOnMainThread {
                            if let viewController = viewController {
                                viewController.hideLoader()
                                if status == .success {
                                    if showConfirmationAlert {
                                        let alert = UIAlertController(title: Bundle.main.appName ?? "",
                                                                      message: "dk_vehicle_odometer_history_update_success".dkVehicleLocalized(),
                                                                      preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: { _ in
                                            completion()
                                        })
                                        alert.addAction(okAction)
                                        viewController.present(alert, animated: true)
                                    } else {
                                        completion()
                                    }
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
                                        @unknown default:
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
            } else {
                viewController.showAlertMessage(title: Bundle.main.appName ?? "", message: "dk_vehicle_odometer_history_error_value".dkVehicleLocalized(), back: false, cancel: false)
            }
        }
    }

    func deleteHistory(viewController: UIViewController) {
        if let vehicle = self.vehicle, let history = self.history {
            viewController.showLoader()
            DriveKitVehicle.shared.deleteOdometerHistory(vehicleId: vehicle.vehicleId, historyId: String(history.historyId)) { [weak viewController] status, _, _ in
                DispatchQueue.dispatchOnMainThread {
                    if let viewController = viewController {
                        viewController.hideLoader()
                        if status == .success {
                            let alert = UIAlertController(title: Bundle.main.appName ?? "",
                                                          message: "dk_vehicle_odometer_history_delete_success".dkVehicleLocalized(),
                                                          preferredStyle: .alert)
                            let okAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: { _ in
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
                                @unknown default:
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
