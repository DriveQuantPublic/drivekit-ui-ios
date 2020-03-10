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
                var brands : [VehiclePickerTableViewItem] = []
                for brand in  DriveKitVehiclePicker.shared.getBrands(vehicleType: type) {
                    if DriveKitVehiculeUI.shared.brands.contains(brand) {
                        brands.append(brand)
                    }
                }
                return brands
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
        case .versions:
            if let versions = viewModel.versions {
                return versions
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
            viewModel.updateCurrentStep(step: .category)
            completion(.noError)
            break
        case .brandsFull:
            viewModel.vehicleBrand = (self.getTableViewItems(viewModel: viewModel)[pos] as! DKVehicleBrand)
            viewModel.updateCurrentStep(step: .engine)
            completion(.noError)
        case .engine:
            viewModel.vehicleEngineIndex = (self.getTableViewItems(viewModel: viewModel)[pos] as! DKVehicleEngineIndex)
            viewModel.getModels(completion: {status in
                if status == .noError {
                    viewModel.updateCurrentStep(step: .models)
                }else {
                    viewModel.vehicleEngineIndex = nil
                }
                completion(status)
            })
        case .models:
            viewModel.vehicleModel = (self.getTableViewItems(viewModel: viewModel)[pos] as! String)
            viewModel.getYears(completion: {status in
                if status == .noError {
                    viewModel.updateCurrentStep(step: .years)
                }else{
                    viewModel.vehicleModel = nil
                }
                completion(status)
            })
        case .years:
            viewModel.vehicleYear = (self.getTableViewItems(viewModel: viewModel)[pos] as! String)
            viewModel.getVersions(completion: {status in
                if status == .noError {
                    viewModel.updateCurrentStep(step: .versions)
                }else{
                    viewModel.vehicleVersion = nil
                }
                completion(status)
            })
        case .versions:
            viewModel.vehicleVersion = (self.getTableViewItems(viewModel: viewModel)[pos] as! DKVehicleVersion)
            viewModel.getCharacteristics(completion: {status in
                if status == .noError {
                    viewModel.updateCurrentStep(step: .name)
                }else{
                    viewModel.vehicleVersion = nil
                }
                completion(status)
            })
        default:
            completion(.noData)
        }
    }
    
    func description() -> String? {
        switch self {
        case .engine:
            return "dk_vehicle_engine_description".dkVehicleLocalized()
        case .models:
            return "dk_vehicle_model_description".dkVehicleLocalized()
        case .years:
            return "dk_vehicle_year_description".dkVehicleLocalized()
        case .versions:
            return "dk_vehicle_version_description".dkVehicleLocalized()
        case .brandsFull :
            return "dk_vehicle_brand_description".dkVehicleLocalized()
        default:
            break
        }
        return nil
    }
}
