//
//  DKVehiclePickerStep.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

enum VehiclePickerStep {
    case type, category, categoryDescription, brandsIcons, brandsFull, engine, models, years//, versions, name
    
    
    func getViewController(viewModel: VehiclePickerViewModel) -> UIViewController? {
        switch self {
        case .type:
            return VehiclePickerTableViewVC(viewModel: viewModel)
        case .category:
            return VehiclePickerCollectionViewVC(viewModel: viewModel)
        case .categoryDescription:
            return nil
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
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .type:
            return ""
        case .category, .categoryDescription:
            return ""
        case .brandsIcons, .brandsFull:
            return ""
        case .engine:
            return ""
        case .models:
            return ""
        case .years:
            return ""
        }
    }
}

enum StepStatus {
    case noError, noData, failedToRetreiveData
}

