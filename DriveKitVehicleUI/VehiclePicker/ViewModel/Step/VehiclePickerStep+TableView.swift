//
//  VehiclePickerStep+TableView.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicleModule
import DriveKitCommonUI
import DriveKitCoreModule

extension VehiclePickerStep: VehiclePickerTableViewDelegate {

    // swiftlint:disable:next cyclomatic_complexity
    func getTableViewItems(viewModel: VehiclePickerViewModel) -> [VehiclePickerTableViewItem] {
        switch self {
        case .type:
            return DriveKitVehicleUI.shared.vehicleTypes
        case .brandsFull:
            if let type = viewModel.vehicleType {
                var brands: [VehiclePickerTableViewItem] = []
                for brand in  DriveKitVehiclePicker.shared.getBrands(vehicleType: type)
                where DriveKitVehicleUI.shared.brands.contains(brand) {
                    brands.append(brand)
                }
                return brands
            }
        case .engine:
            if let type = viewModel.vehicleType {
                var engineIndexes: [DKVehicleEngineIndex] = []
                for engineIndex in DriveKitVehicleUI.shared.vehicleEngineIndexes 
                where DriveKitVehiclePicker
                        .shared
                        .getEnginesIndex(vehicleType: type)
                        .contains(engineIndex) {
                    engineIndexes.append(engineIndex)
                }
                return engineIndexes
            }
        case .models:
            if let models = viewModel.models {
                return  models
            }
        case .years:
            if let years = viewModel.years {
                return years
            }
        case .versions:
            if let versions = viewModel.versions {
                return versions
            }
        default:
            break
        }
        return []
    }

    func onTableViewItemSelected(pos: Int, viewModel: VehiclePickerViewModel) {
        if let analytics = DriveKitUI.shared.analytics {
            analytics.trackEvent(.vehicleAddStep, parameters: [
                DKAnalyticsEventKey.vehicleAddStep.rawValue: "\(self.description() ?? ""), selectedIndex: \(pos), totalCount: \(self.getTableViewItems(viewModel: viewModel).count)"
            ])
        }

        switch self {
            case .type:
                viewModel.vehicleType = DriveKitVehicleUI.shared.vehicleTypes[pos]
                viewModel.nextStep(self)
            case .brandsFull:
                    viewModel.vehicleBrand = self.getTableViewItem(pos: pos, viewModel: viewModel)
                viewModel.nextStep(self)
            case .engine:
                viewModel.vehicleEngineIndex = self.getTableViewItem(pos: pos, viewModel: viewModel)
                viewModel.nextStep(self)
            case .models:
                viewModel.vehicleModel = self.getTableViewItem(pos: pos, viewModel: viewModel)
                viewModel.nextStep(self)
            case .years:
                viewModel.vehicleYear = self.getTableViewItem(pos: pos, viewModel: viewModel)
                viewModel.nextStep(self)
            case .versions:
                viewModel.vehicleVersion = self.getTableViewItem(pos: pos, viewModel: viewModel)
                viewModel.nextStep(self)
            default:
                viewModel.vehicleDataDelegate?.onDataRetrieved(status: .noData)
            }
    }

    func description() -> String? {
        switch self {
        case .type:
            return "dk_vehicle_type_selection_title".dkVehicleLocalized()
        case .truckType:
            return "dk_vehicle_category_truck_selection_title".dkVehicleLocalized()
        case .engine:
            return "dk_vehicle_engine_description".dkVehicleLocalized()
        case .models:
            return "dk_vehicle_model_description".dkVehicleLocalized()
        case .years:
            return "dk_vehicle_year_description".dkVehicleLocalized()
        case .versions:
            return "dk_vehicle_version_description".dkVehicleLocalized()
        case .brandsFull:
            return "dk_vehicle_brand_description".dkVehicleLocalized()
        default:
            break
        }
        return nil
    }

    private func getTableViewItem<T: VehiclePickerTableViewItem>(pos: Int, viewModel: VehiclePickerViewModel) -> T {
        let items = self.getTableViewItems(viewModel: viewModel)
        guard !items.isEmpty else {
            fatalError("Empty vehicle picker items")
        }

        let position: Int
        if pos < items.count {
            position = pos
        } else {
            DriveKitLog.shared.errorLog(tag: DriveKitVehicleUI.tag, message: "Vehicle picker items count is less than index")
            position = 0
        }
        guard let item = self.getTableViewItems(viewModel: viewModel)[position] as? T else {
            fatalError("failed to cast item of type \(T.self)")
        }
        return item
    }
}
