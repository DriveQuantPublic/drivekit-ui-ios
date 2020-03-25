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
                var categories : [VehiclePickerCollectionViewItem] = []
                for category in DriveKitVehiclePicker.shared.getCategories(vehicleType: type) {
                    if DriveKitVehicleUI.shared.categories.contains(category) {
                        categories.append(category)
                    }
                }
                return categories
            }
        case .brandsIcons:
            if let type = viewModel.vehicleType {
                var brands : [VehiclePickerCollectionViewItem] = []
                for brand in DriveKitVehiclePicker.shared.getBrands(vehicleType: type) {
                    if brand.hasImage() && DriveKitVehicleUI.shared.brands.contains(brand) {
                        brands.append(brand)
                    }
                }
                if !brands.isEmpty && brands.count != DriveKitVehicleUI.shared.brands.count {
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
            if DriveKitVehicleUI.shared.categoryConfigType != .brandsConfigOnly {
                viewModel.updateCurrentStep(step: .categoryDescription)
            } else {
                if DriveKitVehicleUI.shared.brands.count > 1 {
                    if !DriveKitVehicleUI.shared.brandsWithIcons || VehiclePickerStep.brandsIcons.getCollectionViewItems(viewModel: viewModel).isEmpty {
                        viewModel.updateCurrentStep(step: .brandsFull)
                    } else {
                        viewModel.updateCurrentStep(step: .brandsIcons)
                    }
                }else{
                    viewModel.vehicleBrand = DriveKitVehicleUI.shared.brands[0]
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
