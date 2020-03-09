//
//  VehiclePickerViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicle

class VehiclePickerViewModel {
    
    var coordinator : VehiclePickerCoordinator
    var currentStep : VehiclePickerStep
    
    var vehicleType : DKVehicleType? = nil
    var vehicleCategory : DKVehicleCategory? = nil
    var vehicleBrand : DKVehicleBrand? = nil
    var vehicleEngineIndex : DKVehicleEngineIndex? = nil
    var vehicleModel : String? = nil
    
    
    var models : [String]? = nil
    var years : [String]? = nil
    
    init(coordinator : VehiclePickerCoordinator) {
        self.coordinator = coordinator
        if DriveKitVehiculeUI.shared.vehicleTypes.count > 1 {
            self.currentStep = .type
        } else {
            self.vehicleType = DriveKitVehiculeUI.shared.vehicleTypes[0]
            self.currentStep = .category
        }
    }
    
    func getViewController() -> UIViewController? {
        return currentStep.getViewController(viewModel: self)
    }
    
    func getTableViewItems() -> [VehiclePickerTableViewItem] {
        return currentStep.getTableViewItems(viewModel: self)
    }
    
    func onTableViewItemSelected(pos: Int, completion : @escaping (StepStatus) -> ()) {
        self.currentStep.onTableViewItemSelected(pos: pos, viewModel: self, completion: completion)
    }
    
    func getCollectionViewItems() -> [VehiclePickerCollectionViewItem] {
        self.currentStep.getCollectionViewItems(viewModel: self)
    }
    
    func onCollectionViewItemSelected(pos: Int, completion : (StepStatus) -> ()){
        self.currentStep.onCollectionViewItemSelected(pos: pos, viewModel: self, completion: completion)
    }
    
    func getModels(completion: @escaping (StepStatus) -> ()) {
        guard let selectedBrand = vehicleBrand, let selectedEngineIndex = vehicleEngineIndex else {
            completion(.failedToRetreiveData)
            return
        }
        DriveKitVehiclePicker.shared.getModels(brand: selectedBrand, engineIndex: selectedEngineIndex, completionHandler: { status, response in
            if status {
                if let listModels = response, !listModels.isEmpty {
                    self.models = listModels
                    completion(.noError)
                } else {
                    completion(.noData)
                }
            } else {
                completion(.failedToRetreiveData)
            }
        })
    }
    
    func getYears(completion: @escaping (StepStatus) -> ()) {
        guard let selectedBrand = vehicleBrand, let selectedEngineIndex = vehicleEngineIndex, let selectedModel = vehicleModel else {
            completion(.failedToRetreiveData)
            return
        }
        DriveKitVehiclePicker.shared.getYears(brand: selectedBrand, engineIndex: selectedEngineIndex, model: selectedModel, completionHandler: { status, response in
            if status {
                if let modelYears = response, !modelYears.isEmpty {
                    self.years = modelYears
                    completion(.noError)
                } else {
                    completion(.noData)
                }
            } else {
                completion(.failedToRetreiveData)
            }
        })
    }
}
