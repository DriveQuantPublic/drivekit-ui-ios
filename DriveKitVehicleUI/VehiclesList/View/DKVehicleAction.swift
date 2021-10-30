//
//  VehicleOption.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBVehicleAccessModule

public protocol DKVehicleActionItem {
    func title() -> String
    func alertAction(pos: Int, viewModel: DKVehiclesListViewModel) -> UIAlertAction
    func isDisplayable(vehicle: DKVehicle) -> Bool
}

public enum DKVehicleAction: String, CaseIterable, DKVehicleActionItem {
    case show
    case odometer
    case rename
    case replace
    case delete

    public func title() -> String {
        switch self {
            case .delete:
                return "dk_vehicle_delete".dkVehicleLocalized()
            case .replace:
                return "dk_vehicle_replace".dkVehicleLocalized()
            case .show:
                return "dk_vehicle_show".dkVehicleLocalized()
            case .rename:
                return "dk_vehicle_rename".dkVehicleLocalized()
            case .odometer:
                return "dk_vehicle_odometer".dkVehicleLocalized()
        }
    }
    
    public func alertAction(pos: Int, viewModel: DKVehiclesListViewModel) -> UIAlertAction {
        var completionHandler: ((UIAlertAction) -> Void)? = nil
        switch self {
            case .show:
                completionHandler = { _ in
                    let detailVC = VehicleDetailVC(viewModel: VehicleDetailViewModel(vehicle: viewModel.vehicles[pos], vehicleDisplayName: viewModel.vehicleName(pos: pos)))
                    viewModel.delegate?.pushViewController(detailVC, animated: true)
                }
            case .rename:
                completionHandler = { _ in
                    viewModel.renameVehicle(pos: pos)
                }
            case .replace:
                completionHandler = { _ in
                    viewModel.delegate?.showVehiclePicker(vehicle: viewModel.vehicles[pos])
                }
            case .delete:
                completionHandler = { _ in
                    viewModel.deleteVehicle(pos: pos)
                }
            case .odometer:
                completionHandler = { _ in
                    let odometerVehicleListViewModel = OdometerVehicleListViewModel(vehicleId: viewModel.vehicles[pos].vehicleId)
                    let odometerVehicleListVC = OdometerVehicleListVC(viewModel: odometerVehicleListViewModel)
                    viewModel.delegate?.pushViewController(odometerVehicleListVC, animated: true)
                }
        }
        return UIAlertAction(title: self.title(), style: .default, handler: completionHandler)
    }
    
    public func isDisplayable(vehicle: DKVehicle) -> Bool {
        switch self {
            case .show:
                return !vehicle.liteConfig
            case .rename, .replace, .delete, .odometer:
                return true
        }
    }
}
