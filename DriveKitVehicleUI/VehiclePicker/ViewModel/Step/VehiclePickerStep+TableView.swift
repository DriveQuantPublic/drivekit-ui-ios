//
//  VehiclePickerStep+VPTV.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicle

extension VehiclePickerStep : VehiclePickerTableViewDelegate {
    
    func getTableViewItems(viewModel : VehiclePickerViewModel) -> [VehiclePickerTableViewItem] {
        switch self {
        case .type:
            return DriveKitVehiculeUI.shared.vehicleTypes
        case .brandsFull:
            if let type = viewModel.vehicleType {
                return  DriveKitVehiclePicker.shared.getBrands(vehicleType: type)
            }
        case .engine:
            if let type = viewModel.vehicleType {
                return  DriveKitVehiclePicker.shared.getEnginesIndex(vehicleType: type)
            }
        case .models:
            if let models = viewModel.models {
                return  models
            }
        case .years:
            if let years = viewModel.years {
                return years
            }
        default:
            break
        }
        
        return []
    }
    
    func onTableViewItemSelected(pos: Int, viewModel : VehiclePickerViewModel, completion : @escaping (StepStatus) -> ()) {
        switch self {
        case .type:
            viewModel.vehicleType = DriveKitVehiculeUI.shared.vehicleTypes[pos]
            viewModel.currentStep = .category
            completion(.noError)
            break
        case .engine:
            viewModel.vehicleEngineIndex = (self.getTableViewItems(viewModel: viewModel)[pos] as! DKVehicleEngineIndex)
            viewModel.getModels(completion: {status in
                if status == .noError {
                    viewModel.currentStep = .models
                }else {
                    viewModel.vehicleEngineIndex = nil
                }
                completion(status)
            })
        case .models:
            viewModel.vehicleModel = (self.getTableViewItems(viewModel: viewModel)[pos] as! String)
            viewModel.getYears(completion: {status in
                if status == .noError {
                    viewModel.currentStep = .years
                }else{
                    viewModel.vehicleModel = nil
                }
                completion(status)
            })
        default:
            completion(.noData)
        }
    }
    
    func description() -> String? {
        /*switch self {
         case .engine:
         return "dk_vehicle_engine_description"
         case .models:
         return "dk_vehicle_model_description"
         case .years:
         return "dk_vehicle_year_description"
         case .versions:
         return "dk_vehicle_version_description"
         case .brandsFull :
         return "dk_vehicle_brand_description"
         default:
         return nil
         }*/
        return nil
    }
}
