//
//  VehiclePickerStep+CollectionView.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicleModule

extension VehiclePickerStep: VehiclePickerCollectionViewDelegate {
    func getCollectionViewItems(viewModel: VehiclePickerViewModel) -> [VehiclePickerCollectionViewItem] {
        switch self {
        case .category:
            if let type = viewModel.vehicleType {
                let filteredCategories = DriveKitVehicleUI.shared.categories.filter { category -> Bool in
                    switch type {
                        case .car:
                            return category.isCar
                        case .truck:
                            return category.isTruck
                        @unknown default:
                            return false
                    }
                }
                var categories: [VehiclePickerCollectionViewItem] = []
                for category in DriveKitVehiclePicker.shared.getCategories(vehicleType: type) {
                    if filteredCategories.contains(category) {
                        categories.append(category)
                    }
                }
                return categories
            }
        case .brandsIcons:
            if let type = viewModel.vehicleType {
                let filteredBrands = DriveKitVehicleUI.shared.brands.filter { brand -> Bool in
                    switch type {
                        case .car:
                            return brand.isCar
                        case .truck:
                            return brand.isTruck
                        @unknown default:
                            return false
                    }
                }
                var brands: [VehiclePickerCollectionViewItem] = []
                for brand in DriveKitVehiclePicker.shared.getBrands(vehicleType: type) {
                    if brand.hasImage() && filteredBrands.contains(brand) {
                        brands.append(brand)
                    }
                }
                if !brands.isEmpty && brands.count != filteredBrands.count {
                    brands.append(OtherVehicles())
                }
                return brands
            }
        case .truckType:
            return DKTruckType.allCases
        default:
            break
        }
        return []
    }

    func onCollectionViewItemSelected(pos: Int, viewModel: VehiclePickerViewModel, completion: (StepStatus) -> Void) {
        switch self {
        case .category:
            let items = DriveKitVehiclePicker.shared.getCategories(vehicleType: viewModel.vehicleType!)
            viewModel.vehicleCategory = items[pos]
            viewModel.nextStep(self)
            completion(.noError)
        case .brandsIcons:
            let items = VehiclePickerStep.brandsIcons.getCollectionViewItems(viewModel: viewModel)
            let item = items[pos]
            viewModel.vehicleBrand = item as? DKVehicleBrand
            viewModel.nextStep(self)
            completion(.noError)
        case .truckType:
            let items = VehiclePickerStep.truckType.getCollectionViewItems(viewModel: viewModel)
            let item = items[pos]
            viewModel.truckType = item as? DKTruckType
            viewModel.nextStep(self)
            completion(.noError)
        default:
            completion(.noData)
        }
    }

    func showLabel() -> Bool {
        switch self {
        case .category, .truckType:
            return true
        case .brandsIcons:
            return false
        default:
            return false
        }
    }
}
