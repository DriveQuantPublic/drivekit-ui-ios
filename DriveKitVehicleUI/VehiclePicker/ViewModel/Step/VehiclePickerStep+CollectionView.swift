//
//  VehiclePickerStep+CollectionView.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicle

extension VehiclePickerStep : VehiclePickerCollectionViewDelegate {
    func getCollectionViewItems(viewModel: VehiclePickerViewModel) -> [VehiclePickerCollectionViewItem] {
        switch self {
        case .category:
            if let type = viewModel.vehicleType {
                return DriveKitVehiclePicker.shared.getCategories(vehicleType: type)
            }
        case .brandsIcons:
            if let type = viewModel.vehicleType {
                var brands : [VehiclePickerCollectionViewItem] = []
                for brand in DriveKitVehiclePicker.shared.getBrands(vehicleType: type) {
                    if brand.hasImage() && DriveKitVehiculeUI.shared.brands.contains(brand) {
                        brands.append(brand)
                    }
                }
                if !brands.isEmpty && brands.count != DriveKitVehiculeUI.shared.brands.count {
                    brands.append(OtherVehicles())
                }
                return brands
            }
        default:
            break
        }
        return []
    }
    
    func onCollectionViewItemSelected(pos: Int, viewModel: VehiclePickerViewModel, completion : (StepStatus) -> ()) {
        switch self {
        case .category:
            let items = DriveKitVehiclePicker.shared.getCategories(vehicleType: viewModel.vehicleType!)
            viewModel.vehicleCategory = items[pos]
            if DriveKitVehiculeUI.shared.categoryType != .brandsConfigOnly {
                viewModel.updateCurrentStep(step: .categoryDescription)
            } else {
                if DriveKitVehiculeUI.shared.brands.count > 1 {
                    if !DriveKitVehiculeUI.shared.brandsWithIcons || VehiclePickerStep.brandsIcons.getCollectionViewItems(viewModel: viewModel).isEmpty {
                        viewModel.updateCurrentStep(step: .brandsFull)
                    } else {
                        viewModel.updateCurrentStep(step: .brandsIcons)
                    }
                }else{
                    viewModel.vehicleBrand = DriveKitVehiculeUI.shared.brands[0]
                    viewModel.updateCurrentStep(step: .engine)
                }
                
            }
            completion(.noError)
            break
        case .brandsIcons:
            let items = VehiclePickerStep.brandsIcons.getCollectionViewItems(viewModel: viewModel)
            let item = items[pos]
            if item is DKVehicleBrand {
                viewModel.vehicleBrand = (item as! DKVehicleBrand)
                viewModel.updateCurrentStep(step: .engine)
            } else {
                viewModel.updateCurrentStep(step: .brandsFull)
            }
            completion(.noError)
        default:
            completion(.noData)
        }
    }
    
    func showLabel() -> Bool {
        switch self {
        case .category:
            return true
        case .brandsIcons:
            return false
        default:
            return false
        }
    }
}
