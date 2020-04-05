//
//  VehiclePickerViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicle
import DriveKitDBVehicleAccess

protocol VehicleDataDelegate : AnyObject {
    func onDataRetrieved(status: StepStatus)
}

protocol VehicleNavigationDelegate : AnyObject {
    func showStep(viewController: UIViewController)
}

class VehiclePickerViewModel {
    
    let detectionMode : DKDetectionMode
    let previousVehicle: DKVehicle?
    
    var currentStep : VehiclePickerStep
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
    
    weak var vehicleDataDelegate: VehicleDataDelegate? = nil
    weak var vehicleNavigationDelegate: VehicleNavigationDelegate? = nil
    
    init(detectionMode : DKDetectionMode, previousVehicle: DKVehicle? = nil) {
        self.detectionMode = detectionMode
        self.previousVehicle = previousVehicle
        if DriveKitVehicleUI.shared.vehicleTypes.count > 1 {
            self.currentStep = .type
        } else if DriveKitVehicleUI.shared.categories.count > 1 && DriveKitVehicleUI.shared.categoryConfigType != .brandsConfigOnly  {
            self.vehicleType = DriveKitVehicleUI.shared.vehicleTypes[0]
            self.currentStep = .category
        } else if DriveKitVehicleUI.shared.categories.count == 1 && DriveKitVehicleUI.shared.categoryConfigType == .liteConfigOnly {
            self.vehicleType = DriveKitVehicleUI.shared.vehicleTypes[0]
            self.vehicleCategory = DriveKitVehicleUI.shared.categories[0]
            self.liteConfig = true
            self.currentStep = .name
            self.vehicleCharacteristics = DKVehicleCharacteristics()
            self.vehicleCharacteristics?.dqIndex = self.vehicleCategory!.liteConfigId()
        } else if DriveKitVehicleUI.shared.brands.count > 1 {
            self.vehicleType = DriveKitVehicleUI.shared.vehicleTypes[0]
            self.vehicleCategory = DriveKitVehicleUI.shared.categories[0]
            if !DriveKitVehicleUI.shared.brandsWithIcons {
                self.currentStep = .brandsFull
            } else {
                self.currentStep = .brandsIcons
            }
        } else {
            self.vehicleType = DriveKitVehicleUI.shared.vehicleTypes[0]
            self.vehicleCategory = DriveKitVehicleUI.shared.categories[0]
            self.vehicleBrand = DriveKitVehicleUI.shared.brands[0]
            self.currentStep = .engine
        }
    }
    
    func updateCurrentStep(step : VehiclePickerStep) {
        previousSteps.append(currentStep)
        currentStep = step
    }
    
    func showStep() {
        self.vehicleNavigationDelegate?.showStep(viewController: getViewController())
    }
    
    func getDefaultName() -> String {
        if liteConfig {
            guard let category = vehicleCategory else {
                return ""
            }
            vehicleName = category.title()
        } else {
            vehicleName = String(format: "%@ %@ %@", self.vehicleBrand?.name ?? "", self.vehicleModel ?? "", self.vehicleVersion?.version ?? "")
        }
        return vehicleName ?? ""
    }
    
    func getViewController() -> UIViewController {
        return currentStep.getViewController(viewModel: self)
    }
    
    func getTableViewItems() -> [VehiclePickerTableViewItem] {
        return currentStep.getTableViewItems(viewModel: self)
    }
    
    func onTableViewItemSelected(pos: Int) {
        self.currentStep.onTableViewItemSelected(pos: pos, viewModel: self)
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
        DriveKitVehiclePicker.shared.getCharacteristics(dqIndex: selectedVersion.dqIndex, completionHandler: { status, response in
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
            if let previousVehicle = self.previousVehicle {
                replaceVehicle(previousVehicle: previousVehicle, completion: completion)
            }else{
                DriveKitVehicle.shared.createVehicle(characteristics: characteristics, vehicleType: vehicleType ?? .car, name: vehicleName, liteConfig: liteConfig, detectionMode: detectionMode, completionHandler: { status, vehicle in
                    completion(status)
                })
            }
        }
    }
    
    func replaceVehicle(previousVehicle: DKVehicle, completion : @escaping (DKVehicleManagerStatus) -> ()) {
        if let characteristics = vehicleCharacteristics {
            let detectionMode = previousVehicle.detectionMode ?? .disabled
            let previousBeacon = previousVehicle.beacon
            let previousBluetooth = previousVehicle.bluetooth
            
            DriveKitVehicle.shared.createVehicle(characteristics: characteristics, vehicleType: vehicleType ?? .car, name: vehicleName, liteConfig: liteConfig, detectionMode: detectionMode, completionHandler: { status, vehicle in
                DriveKitVehicle.shared.deleteVehicle(vehicleId: previousVehicle.vehicleId, completionHandler: { deleteStatus in
                    if deleteStatus == .success {
                        if previousBeacon != nil {
                            
                            DriveKitVehicle.shared.addBeacon(vehicleId: vehicle?.vehicleId ?? "", beacon: previousBeacon!, completionHandler: { beaconStatus in
                                if beaconStatus == .success {
                                    completion(status)
                                }
                            })
                            
                        } else if previousBluetooth != nil {
                            DriveKitVehicle.shared.addBluetooth(vehicleId: vehicle?.vehicleId ?? "", bluetooth: previousBluetooth!, completionHandler: { bluetoothSuccess in
                                if bluetoothSuccess == .success {
                                    completion(status)
                                }
                            })
                        } else {
                            completion(status)
                        }
                    }
                })
            })
        }
    }
    
    func getStepDescription() -> String? {
        return currentStep.description()
    }
    
    func showStepLabel() -> Bool {
        return currentStep.showLabel()
    }
    
    func getTitle() -> String {
        return currentStep.getTitle(viewModel: self)
    }
}
