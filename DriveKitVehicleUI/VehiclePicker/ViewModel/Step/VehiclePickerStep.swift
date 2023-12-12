// swiftlint:disable cyclomatic_complexity
//
//  DKVehiclePickerStep.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

enum VehiclePickerStep {
    case type, truckType, category, categoryDescription, brandsIcons, brandsFull, engine, models, years, versions, name, defaultCarEngine

    func getViewController(viewModel: VehiclePickerViewModel) -> UIViewController {
        switch self {
            case .type:
                return VehiclePickerTableViewVC(viewModel: viewModel)
            case .truckType:
                return VehiclePickerTruckTypeVC(viewModel: viewModel)
            case .category:
                return VehiclePickerCollectionViewVC(viewModel: viewModel)
            case .categoryDescription:
                return VehiclePickerTextVC(viewModel: viewModel)
            case .brandsIcons:
                return VehiclePickerCollectionViewVC(viewModel: viewModel)
            case .brandsFull:
                return VehiclePickerTableViewVC(viewModel: viewModel)
            case .engine:
                return VehiclePickerTableViewVC(viewModel: viewModel)
            case .models:
                return VehiclePickerTableViewVC(viewModel: viewModel)
            case .years:
                return VehiclePickerTableViewVC(viewModel: viewModel)
            case .versions:
                return VehiclePickerTableViewVC(viewModel: viewModel)
            case .name:
                return VehiclePickerInputVC(viewModel: viewModel)
            case .defaultCarEngine:
                return VehiclePickerDefaultCarEngineVC(viewModel: viewModel)
        }
    }

    func getTitle(viewModel: VehiclePickerViewModel) -> String {
        switch self {
            case.categoryDescription:
                return viewModel.vehicleCategory?.title().dkVehicleLocalized() ?? ""
            case .name:
                return "dk_vehicle_name".dkVehicleLocalized()
            default:
                return "dk_vehicle_my_vehicle".dkVehicleLocalized()
        }
    }
}

enum StepStatus {
    case noError, noData, failedToRetreiveData
}
