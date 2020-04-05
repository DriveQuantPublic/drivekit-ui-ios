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
            return DriveKitVehicleUI.shared.vehicleTypes
        case .brandsFull:
            if let type = viewModel.vehicleType {
                var brands : [VehiclePickerTableViewItem] = []
                for brand in  DriveKitVehiclePicker.shared.getBrands(vehicleType: type) {
                    if DriveKitVehicleUI.shared.brands.contains(brand) {
                        brands.append(brand)
                    }
                }
                return brands
            }
        case .engine:
            if let type = viewModel.vehicleType {
                var engineIndexes : [DKVehicleEngineIndex] = []
                for engineIndex in DriveKitVehicleUI.shared.vehicleEngineIndexes {
                    if DriveKitVehiclePicker.shared.getEnginesIndex(vehicleType: type).contains(engineIndex){
                        engineIndexes.append(engineIndex)
                    }
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
    
    func onTableViewItemSelected(pos: Int, viewModel : VehiclePickerViewModel) {
        switch self {
        case .type:
            if DriveKitVehicleUI.shared.categories.count > 1 {
                viewModel.vehicleType = DriveKitVehicleUI.shared.vehicleTypes[pos]
                viewModel.updateCurrentStep(step: .category)
            } else {
                viewModel.vehicleCategory = DriveKitVehicleUI.shared.categories[0]
                if DriveKitVehicleUI.shared.brands.count > 1 {
                    if !DriveKitVehicleUI.shared.brandsWithIcons || VehiclePickerStep.brandsIcons.getCollectionViewItems(viewModel: viewModel).isEmpty {
                        viewModel.updateCurrentStep(step: .brandsFull)
                    } else {
                        viewModel.updateCurrentStep(step: .brandsIcons)
                    }
                } else {
                    viewModel.vehicleBrand = DriveKitVehicleUI.shared.brands[0]
                    viewModel.updateCurrentStep(step: .engine)
                }
            }
            viewModel.vehicleDataDelegate?.onDataRetrieved(status: .noError)
            break
        case .brandsFull:
            viewModel.vehicleBrand = (self.getTableViewItems(viewModel: viewModel)[pos] as! DKVehicleBrand)
            viewModel.updateCurrentStep(step: .engine)
            viewModel.vehicleDataDelegate?.onDataRetrieved(status: .noError)
        case .engine:
            viewModel.vehicleEngineIndex = (self.getTableViewItems(viewModel: viewModel)[pos] as! DKVehicleEngineIndex)
            guard let selectedBrand = viewModel.vehicleBrand, let selectedEngineIndex = viewModel.vehicleEngineIndex else {
                viewModel.vehicleDataDelegate?.onDataRetrieved(status: .failedToRetreiveData)
                return
            }
            DriveKitVehiclePicker.shared.getModels(brand: selectedBrand, engineIndex: selectedEngineIndex, completionHandler: { [weak viewModel] status, response in
                if status {
                    if let listModels = response, !listModels.isEmpty {
                        viewModel?.models = listModels
                        viewModel?.updateCurrentStep(step: .models)
                        viewModel?.vehicleDataDelegate?.onDataRetrieved(status: .noError)
                    } else {
                        viewModel?.vehicleEngineIndex = nil
                        viewModel?.vehicleDataDelegate?.onDataRetrieved(status: .noData)
                    }
                } else {
                    viewModel?.vehicleDataDelegate?.onDataRetrieved(status: .failedToRetreiveData)
                }
            })
        case .models:
            viewModel.vehicleModel = (self.getTableViewItems(viewModel: viewModel)[pos] as! String)
            guard let selectedBrand = viewModel.vehicleBrand, let selectedEngineIndex = viewModel.vehicleEngineIndex, let selectedModel = viewModel.vehicleModel else {
                viewModel.vehicleDataDelegate?.onDataRetrieved(status: .failedToRetreiveData)
                return
            }
            DriveKitVehiclePicker.shared.getYears(brand: selectedBrand, engineIndex: selectedEngineIndex, model: selectedModel, completionHandler: { [weak viewModel] status, response in
                if status {
                    if let modelYears = response, !modelYears.isEmpty {
                        viewModel?.years = modelYears
                        viewModel?.updateCurrentStep(step: .years)
                        viewModel?.vehicleDataDelegate?.onDataRetrieved(status: .noError)
                    } else {
                        viewModel?.vehicleModel = nil
                        viewModel?.vehicleDataDelegate?.onDataRetrieved(status: .noData)
                    }
                } else {
                    viewModel?.vehicleDataDelegate?.onDataRetrieved(status: .failedToRetreiveData)
                }
            })
        case .years:
            viewModel.vehicleYear = (self.getTableViewItems(viewModel: viewModel)[pos] as! String)
            guard let selectedBrand = viewModel.vehicleBrand, let selectedEngineIndex = viewModel.vehicleEngineIndex, let selectedModel = viewModel.vehicleModel, let selectedYear = viewModel.vehicleYear else {
                viewModel.vehicleDataDelegate?.onDataRetrieved(status: .failedToRetreiveData)
                return
            }
            DriveKitVehiclePicker.shared.getVersions(brand: selectedBrand, engineIndex: selectedEngineIndex, model: selectedModel, year: selectedYear, completionHandler: { [weak viewModel] status, response in
                if status {
                    if let vehicleVersions = response, !vehicleVersions.isEmpty {
                        viewModel?.versions = vehicleVersions
                        viewModel?.updateCurrentStep(step: .versions)
                        viewModel?.vehicleDataDelegate?.onDataRetrieved(status: .noError)
                    } else {
                        viewModel?.vehicleVersion = nil
                        viewModel?.vehicleDataDelegate?.onDataRetrieved(status: .noData)
                    }
                } else {
                    viewModel?.vehicleDataDelegate?.onDataRetrieved(status: .failedToRetreiveData)
                }
            })
        case .versions:
            viewModel.vehicleVersion = (self.getTableViewItems(viewModel: viewModel)[pos] as! DKVehicleVersion)
            guard let selectedVersion = viewModel.vehicleVersion else {
                return
            }
            DriveKitVehiclePicker.shared.getCharacteristics(dqIndex: selectedVersion.dqIndex, completionHandler: { [weak viewModel] status, response in
                if status {
                    if let vehicleCharacteristics = response {
                        viewModel?.vehicleCharacteristics = vehicleCharacteristics
                        viewModel?.updateCurrentStep(step: .name)
                        viewModel?.vehicleDataDelegate?.onDataRetrieved(status: .noError)
                    } else {
                        viewModel?.vehicleVersion = nil
                        viewModel?.vehicleDataDelegate?.onDataRetrieved(status: .noData)
                    }
                } else {
                    viewModel?.vehicleDataDelegate?.onDataRetrieved(status: .failedToRetreiveData)
                }
            })
        default:
            viewModel.vehicleDataDelegate?.onDataRetrieved(status: .noData)
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
