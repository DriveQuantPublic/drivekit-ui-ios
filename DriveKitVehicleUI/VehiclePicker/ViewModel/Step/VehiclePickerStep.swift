//
//  DKVehiclePickerStep.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

enum VehiclePickerStep {
    case type, category, categoryDescription, brandsIcons, brandsFull, engine, models, years, versions, name
    
    
    func getViewController(viewModel: VehiclePickerViewModel) -> UIViewController? {
        switch self {
        case .type:
            return VehiclePickerTableViewVC(viewModel: viewModel)
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
        }
    }
    
    func getTitle(viewModel: VehiclePickerViewModel) -> String {
        switch self {
        case.categoryDescription:
            return viewModel.vehicleCategory?.title() ?? ""
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

