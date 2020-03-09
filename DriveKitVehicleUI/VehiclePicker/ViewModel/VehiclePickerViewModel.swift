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
    private var currentStep : VehiclePickerStep
    
    var previousSteps : [VehiclePickerStep] = []
    
    var vehicleType : DKVehicleType? = nil
    var vehicleCategory : DKVehicleCategory? = nil
    var vehicleBrand : DKVehicleBrand? = nil
    var vehicleEngineIndex : DKVehicleEngineIndex? = nil
    var vehicleModel : String? = nil
    var vehicleYear : String? = nil
    var vehicleVersion : DKVehicleVersion? = nil
    var liteConfig: Bool = false
    var vehicleName : String? = nil
    var vehicleCharacteristics : DKVehicleCharacteristics? = nil
    
    
    var models : [String]? = nil
    var years : [String]? = nil
    var versions : [DKVehicleVersion]? = nil
    
    init(coordinator : VehiclePickerCoordinator) {
        self.coordinator = coordinator
        if DriveKitVehiculeUI.shared.vehicleTypes.count > 1 {
            self.currentStep = .type
        } else {
            self.vehicleType = DriveKitVehiculeUI.shared.vehicleTypes[0]
            self.currentStep = .category
        }
    }
    
    func updateCurrentStep(step : VehiclePickerStep) {
        previousSteps.append(currentStep)
        currentStep = step
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
    
    func getCategoryItem() -> VehiclePickerTextDelegate? {
        return vehicleCategory
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
    
    func getVersions(completion: @escaping (StepStatus) -> ()) {
        guard let selectedBrand = vehicleBrand, let selectedEngineIndex = vehicleEngineIndex, let selectedModel = vehicleModel, let selectedYear = vehicleYear else {
            completion(.failedToRetreiveData)
            return
        }
        DriveKitVehiclePicker.shared.getVersions(brand: selectedBrand, engineIndex: selectedEngineIndex, model: selectedModel, year: selectedYear, completionHandler: { status, response in
            if status {
                if let vehicleVersions = response, !vehicleVersions.isEmpty {
                    self.versions = vehicleVersions
                    completion(.noError)
                } else {
                    completion(.noData)
                }
            } else {
                completion(.failedToRetreiveData)
            }
        })
    }
    
    func getCharacteristics(completion: @escaping (StepStatus) -> ()) {
        guard let selectedVersion = vehicleVersion else {
            return
        }
        DriveKitVehiclePicker.shared.getCharacteristics(version: selectedVersion, completionHandler: { status, response in
            if status {
                if let vehicleCharacteristics = response {
                    self.vehicleCharacteristics = vehicleCharacteristics
                    completion(.noError)
                } else {
                    completion(.noData)
                }
            } else {
                completion(.failedToRetreiveData)
            }
        })
    }

    func addVehicle(completion : @escaping (DKVehicleManagerStatus) -> ()) {
        if let characteristics = vehicleCharacteristics {
            DriveKitVehicleManager.shared.createVehicle(characteristics: characteristics, name: vehicleName, completionHandler: { status, vehicle in
                completion(status)
            })
        }
    }
    
    func showPreviousStep() {
        if let step = previousSteps.last {
            self.currentStep = step
            previousSteps.removeLast(1)
            coordinator.showPrevious()
        } else {
            coordinator.navigationController.dismiss(animated: true, completion: nil)
        }
    }
    
    func getStepDescription() -> String? {
        return currentStep.description()
    }
    
    func showStepLabel() -> Bool {
        return currentStep.showLabel()
    }
}
