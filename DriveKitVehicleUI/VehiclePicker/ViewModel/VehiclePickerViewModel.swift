// swiftlint:disable file_length
//
//  VehiclePickerViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitVehicleModule
import DriveKitDBVehicleAccessModule

protocol VehicleDataDelegate: AnyObject {
    func onDataRetrieved(status: StepStatus)
}

protocol VehicleNavigationDelegate: AnyObject {
    func showStep(viewController: UIViewController)
}

// swiftlint:disable:next type_body_length
class VehiclePickerViewModel {
    let detectionMode: DKDetectionMode
    let previousVehicle: DKVehicle?

    var currentStep: VehiclePickerStep = .type
    var previousSteps: [VehiclePickerStep] = []

    var vehicleType: DKVehicleType?
    var truckType: DKTruckType?
    var vehicleCategory: DKVehicleCategory?
    var vehicleBrand: DKVehicleBrand?
    var vehicleEngineIndex: DKVehicleEngineIndex?
    var vehicleModel: String?
    var vehicleYear: String?
    var vehicleVersion: DKVehicleVersion?
    var liteConfig: Bool = false
    var vehicleName: String?
    var vehicleCharacteristics: DKVehicleCharacteristics?
    var isElectric: Bool = false

    var models: [String]?
    var years: [String]?
    var versions: [DKVehicleVersion]?

    let showCancel: Bool

    weak var vehicleDataDelegate: VehicleDataDelegate?
    weak var vehicleNavigationDelegate: VehicleNavigationDelegate?

    init(detectionMode: DKDetectionMode, previousVehicle: DKVehicle? = nil, showCancel: Bool = true) {
        self.detectionMode = detectionMode
        self.previousVehicle = previousVehicle
        self.showCancel = showCancel
        nextStepInternal(nil)
    }

    func nextStep(_ step: VehiclePickerStep?) {
        nextStepInternal(step, appendPrevious: true)
    }

    // swiftlint:disable:next cyclomatic_complexity
    private func nextStepInternal(_ step: VehiclePickerStep?, appendPrevious: Bool = false) {
        if let step = step {
            switch step {
                case .type:
                    nextStepAfterTypeStep(appendPrevious: appendPrevious)
                case .truckType:
                    nextStepAfterTruckTypeStep(appendPrevious: appendPrevious)
                case .category:
                    nextStepAfterCategoryStep(appendPrevious: appendPrevious)
                case .categoryDescription:
                    nextStepAfterCategoryDescriptionStep(appendPrevious: appendPrevious)
                case .brandsFull:
                    nextStepAfterBrandsFullStep(appendPrevious: appendPrevious)
                case .brandsIcons:
                    nextStepAfterBrandsIconsStep(appendPrevious: appendPrevious)
                case .engine:
                    nextStepAfterEngineStep(appendPrevious: appendPrevious)
                case .models:
                    nextStepAfterModelsStep(appendPrevious: appendPrevious)
                case .years:
                    nextStepAfterYearsStep(appendPrevious: appendPrevious)
                case .versions:
                    nextStepAfterVersionsStep(appendPrevious: appendPrevious)
                case .defaultCarEngine:
                    nextStepAfterDefaultEngineStep(appendPrevious: appendPrevious)
                case .name:
                    // Last step. Nothing to do.
                    break

            }
        } else {
            // Determine the very first step.
            if DriveKitVehicleUI.shared.vehicleTypes.count > 1 {
                self.currentStep = .type
            } else {
                let vehicleType = DriveKitVehicleUI.shared.vehicleTypes.first
                self.vehicleType = vehicleType
                nextStepInternal(.type, appendPrevious: appendPrevious)
            }
        }
    }

    private func nextStepAfterTypeStep(appendPrevious: Bool) {
        if let vehicleType = self.vehicleType {
            let driveKitVehicleUI = DriveKitVehicleUI.shared
            if vehicleType == .truck {
                if driveKitVehicleUI.truckTypes.count > 1 {
                    updateStep(.truckType, appendPrevious: appendPrevious)
                } else {
                    self.truckType = driveKitVehicleUI.truckTypes.first
                    nextStepInternal(.truckType, appendPrevious: appendPrevious)
                }
            } else {
                let filteredCategories = driveKitVehicleUI.categories.filter({ category -> Bool in
                    switch vehicleType {
                        case .car:
                            return category.isCar
                        case .truck:
                            return category.isTruck
                        @unknown default:
                            return false
                    }
                })
                if filteredCategories.count > 1 && driveKitVehicleUI.categoryConfigType != .brandsConfigOnly {
                    updateStep(.category, appendPrevious: appendPrevious)
                } else {
                    self.vehicleCategory = filteredCategories.first
                    nextStepInternal(.category, appendPrevious: appendPrevious)
                }
            }
        } else {
            nextStepInternal(nil, appendPrevious: appendPrevious)
        }
    }

    private func nextStepAfterTruckTypeStep(appendPrevious: Bool) {
        if self.truckType != nil {
            let filteredBrands = DriveKitVehicleUI.shared.brands.filter { $0.isTruck }
            if filteredBrands.count > 1 {
                if !DriveKitVehicleUI.shared.brandsWithIcons || VehiclePickerStep.brandsIcons.getCollectionViewItems(viewModel: self).isEmpty {
                    updateStep(.brandsFull, appendPrevious: appendPrevious)
                } else {
                    updateStep(.brandsIcons, appendPrevious: appendPrevious)
                }
            } else {
                self.vehicleBrand = filteredBrands.first
                nextStepInternal(.brandsFull, appendPrevious: appendPrevious)
            }
        } else {
            nextStepInternal(nil, appendPrevious: appendPrevious)
        }
    }

    private func nextStepAfterCategoryStep(appendPrevious: Bool) {
        if self.vehicleCategory != nil, let vehicleType = self.vehicleType, vehicleType != .truck {
            let driveKitVehicleUI = DriveKitVehicleUI.shared
            let filteredCategories = driveKitVehicleUI.categories.filter({ category -> Bool in
                switch vehicleType {
                    case .car:
                        return category.isCar
                    case .truck:
                        return category.isTruck
                    @unknown default:
                        return false
                }
            })
            if filteredCategories.count == 1 && driveKitVehicleUI.categoryConfigType == .liteConfigOnly {
                self.liteConfig = true
                updateStep(.defaultCarEngine, appendPrevious: appendPrevious)
            } else if driveKitVehicleUI.categoryConfigType != .brandsConfigOnly {
                updateStep(.categoryDescription, appendPrevious: appendPrevious)
            } else {
                let filteredBrands = driveKitVehicleUI.brands.filter { !$0.isTruck }
                if filteredBrands.count > 1 {
                    if !driveKitVehicleUI.brandsWithIcons || VehiclePickerStep.brandsIcons.getCollectionViewItems(viewModel: self).isEmpty {
                        updateStep(.brandsFull, appendPrevious: appendPrevious)
                    } else {
                        updateStep(.brandsIcons, appendPrevious: appendPrevious)
                    }
                } else {
                    self.vehicleBrand = filteredBrands.first
                    nextStepInternal(.brandsFull, appendPrevious: appendPrevious)
                }
            }
        } else {
            nextStepInternal(nil, appendPrevious: appendPrevious)
        }
    }

    private func nextStepAfterCategoryDescriptionStep(appendPrevious: Bool) {
        if self.liteConfig {
            updateStep(.defaultCarEngine, appendPrevious: appendPrevious)
        } else {
            let filteredBrands = DriveKitVehicleUI.shared.brands.filter { !$0.isTruck }
            if filteredBrands.count > 1 {
                if !DriveKitVehicleUI.shared.brandsWithIcons || VehiclePickerStep.brandsIcons.getCollectionViewItems(viewModel: self).isEmpty {
                    updateStep(.brandsFull, appendPrevious: appendPrevious)
                } else {
                    updateStep(.brandsIcons, appendPrevious: appendPrevious)
                }
            } else {
                self.vehicleBrand = filteredBrands.first
                nextStepInternal(.brandsFull, appendPrevious: appendPrevious)
            }
        }
    }

    private func nextStepAfterBrandsFullStep(appendPrevious: Bool) {
        if self.vehicleBrand != nil, let vehicleType = self.vehicleType {
            if vehicleType == .truck {
                self.vehicleEngineIndex = DKVehicleEngineIndex.diesel
                nextStepInternal(.engine, appendPrevious: appendPrevious)
            } else {
                let filteredEngineIndexes = DriveKitVehicleUI.shared.vehicleEngineIndexes.filter { engineIndex -> Bool in
                    switch vehicleType {
                        case .car:
                            return engineIndex.isCar
                        case .truck:
                            return engineIndex.isTruck
                        @unknown default:
                            return false
                    }
                }
                if filteredEngineIndexes.count > 1 {
                    updateStep(.engine, appendPrevious: appendPrevious)
                } else {
                    self.vehicleEngineIndex = filteredEngineIndexes.first
                    nextStepInternal(.engine, appendPrevious: appendPrevious)
                }
            }
        } else {
            nextStepInternal(nil, appendPrevious: appendPrevious)
        }
    }

    private func nextStepAfterBrandsIconsStep(appendPrevious: Bool) {
        if self.vehicleBrand != nil, let vehicleType = self.vehicleType {
            if vehicleType == .truck {
                self.vehicleEngineIndex = DKVehicleEngineIndex.diesel
                nextStepInternal(.engine, appendPrevious: appendPrevious)
            } else {
                let filteredEngineIndexes = DriveKitVehicleUI.shared.vehicleEngineIndexes.filter { engineIndex -> Bool in
                    switch vehicleType {
                        case .car:
                            return engineIndex.isCar
                        case .truck:
                            return engineIndex.isTruck
                        @unknown default:
                            return false
                    }
                }
                if filteredEngineIndexes.count > 1 {
                    updateStep(.engine, appendPrevious: appendPrevious)
                } else {
                    self.vehicleEngineIndex = filteredEngineIndexes.first
                    nextStepInternal(.engine, appendPrevious: appendPrevious)
                }
            }
        } else {
            updateStep(.brandsFull, appendPrevious: appendPrevious)
        }
    }

    private func nextStepAfterEngineStep(appendPrevious: Bool) {
        if let vehicleEngineIndex = self.vehicleEngineIndex, let vehicleType = self.vehicleType, let vehicleBrand = self.vehicleBrand {
            let completionHandler: (Bool, [String]?) -> Void = { [weak self] status, response in
                if let self = self {
                    if status {
                        if let listModels = response, !listModels.isEmpty {
                            self.models = listModels
                            self.updateStep(.models, appendPrevious: appendPrevious)
                        } else {
                            self.vehicleEngineIndex = nil
                            self.vehicleDataDelegate?.onDataRetrieved(status: .noData)
                        }
                    } else {
                        self.vehicleDataDelegate?.onDataRetrieved(status: .failedToRetreiveData)
                    }
                }
            }
            switch vehicleType {
                case .car:
                    DriveKitVehiclePicker.shared.getCarModels(brand: vehicleBrand, engineIndex: vehicleEngineIndex, completionHandler: completionHandler)
                case .truck:
                    if let truckType = self.truckType {
                        DriveKitVehiclePicker.shared.getTruckModels(truckType: truckType, brand: vehicleBrand, completionHandler: completionHandler)
                    } else {
                        nextStepInternal(nil, appendPrevious: appendPrevious)
                    }
                @unknown default:
                    break
            }
        } else {
            nextStepInternal(nil, appendPrevious: appendPrevious)
        }
    }

    private func nextStepAfterModelsStep(appendPrevious: Bool) {
        if let vehicleModel = self.vehicleModel, let vehicleType = self.vehicleType, let vehicleBrand = self.vehicleBrand {
            let completionHandler: (Bool, [String]?) -> Void = { [weak self] status, response in
                if let self = self {
                    if status {
                        if let modelYears = response, !modelYears.isEmpty {
                            self.years = modelYears
                            self.updateStep(.years, appendPrevious: appendPrevious)
                        } else {
                            self.vehicleModel = nil
                            self.vehicleDataDelegate?.onDataRetrieved(status: .noData)
                        }
                    } else {
                        self.vehicleDataDelegate?.onDataRetrieved(status: .failedToRetreiveData)
                    }
                }
            }
            switch vehicleType {
                case .car:
                    if let vehicleEngineIndex = self.vehicleEngineIndex {
                        DriveKitVehiclePicker.shared.getCarYears(brand: vehicleBrand, engineIndex: vehicleEngineIndex, model: vehicleModel, completionHandler: completionHandler)
                    } else {
                        nextStepInternal(nil, appendPrevious: appendPrevious)
                    }
                case .truck:
                    if let truckType = self.truckType {
                        DriveKitVehiclePicker.shared.getTruckYears(truckType: truckType, brand: vehicleBrand, model: vehicleModel, completionHandler: completionHandler)
                    } else {
                        nextStepInternal(nil, appendPrevious: appendPrevious)
                    }
                @unknown default:
                    break
            }
        } else {
            nextStepInternal(nil, appendPrevious: appendPrevious)
        }
    }

    private func nextStepAfterYearsStep(appendPrevious: Bool) {
        if let vehicleYear = self.vehicleYear, let vehicleType = self.vehicleType, let vehicleBrand = self.vehicleBrand, let vehicleModel = self.vehicleModel {
            let completionHandler: (Bool, [DKVehicleVersion]?) -> Void = { [weak self] status, response in
                if let self = self {
                    if status {
                        if let vehicleVersions = response, !vehicleVersions.isEmpty {
                            self.versions = vehicleVersions
                            self.updateStep(.versions, appendPrevious: appendPrevious)
                        } else {
                            self.vehicleVersion = nil
                            self.vehicleDataDelegate?.onDataRetrieved(status: .noData)
                        }
                    } else {
                        self.vehicleDataDelegate?.onDataRetrieved(status: .failedToRetreiveData)
                    }
                }
            }
            switch vehicleType {
                case .car:
                    if let vehicleEngineIndex = self.vehicleEngineIndex {
                        DriveKitVehiclePicker.shared.getCarVersions(
                            brand: vehicleBrand,
                            engineIndex: vehicleEngineIndex,
                            model: vehicleModel,
                            year: vehicleYear,
                            completionHandler: completionHandler)
                    } else {
                        nextStepInternal(nil, appendPrevious: appendPrevious)
                    }
                case .truck:
                    if let truckType = self.truckType {
                        DriveKitVehiclePicker.shared.getTruckVersions(
                            truckType: truckType,
                            brand: vehicleBrand,
                            model: vehicleModel,
                            year: vehicleYear,
                            completionHandler: completionHandler)
                    } else {
                        nextStepInternal(nil, appendPrevious: appendPrevious)
                    }
                @unknown default:
                    break
            }
        } else {
            nextStepInternal(nil, appendPrevious: appendPrevious)
        }
    }

    private func nextStepAfterVersionsStep(appendPrevious: Bool) {
        guard let vehicleVersion = self.vehicleVersion, let vehicleType = self.vehicleType else {
            nextStepInternal(nil, appendPrevious: appendPrevious)
            return
        }
        let completionHandler: (Bool, DKVehicleCharacteristics?) -> Void = { [weak self] status, response in
            if let self = self {
                if status {
                    if let vehicleCharacteristics = response {
                        self.vehicleCharacteristics = vehicleCharacteristics
                        self.updateStep(.name, appendPrevious: appendPrevious)
                    } else {
                        self.vehicleVersion = nil
                        self.vehicleDataDelegate?.onDataRetrieved(status: .noData)
                    }
                } else {
                    self.vehicleDataDelegate?.onDataRetrieved(status: .failedToRetreiveData)
                }
            }
        }
        switch vehicleType {
            case .car:
                DriveKitVehiclePicker.shared.getCarCharacteristics(dqIndex: vehicleVersion.dqIndex, completionHandler: completionHandler)
            case .truck:
                DriveKitVehiclePicker.shared.getTruckCharacteristics(dqIndex: vehicleVersion.dqIndex, completionHandler: completionHandler)
            @unknown default:
                break
        }
    }

    private func nextStepAfterDefaultEngineStep(appendPrevious: Bool) {
        if liteConfig, self.vehicleType == .car {
            self.vehicleCharacteristics = DKCarVehicleCharacteristics()
            self.vehicleCharacteristics?.dqIndex = vehicleCategory?.liteConfigId(isElectric: self.isElectric) ?? ""
            updateStep(.name, appendPrevious: appendPrevious)
        } else {
            nextStepInternal(nil, appendPrevious: appendPrevious)
        }
    }
    
    private func updateStep(_ step: VehiclePickerStep, appendPrevious: Bool) {
        if appendPrevious {
            previousSteps.append(self.currentStep)
        }
        self.currentStep = step
        if let vehicleDataDelegate = self.vehicleDataDelegate {
            vehicleDataDelegate.onDataRetrieved(status: .noError)
        } else {
            showStep()
        }
    }

    func showStep() {
        DispatchQueue.dispatchOnMainThread {
            self.vehicleNavigationDelegate?.showStep(viewController: self.createViewController())
        }
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

    func getCategoryItem() -> VehiclePickerTextDelegate? {
        return vehicleCategory
    }

    // swiftlint:disable:next cyclomatic_complexity
    func addVehicle(completion: @escaping (DKVehicleManagerStatus, String?) -> Void) {
        if let characteristics = self.vehicleCharacteristics {
            if let previousVehicle = self.previousVehicle {
                replaceVehicle(previousVehicle: previousVehicle, completion: { status, vehicleId in
                    let vehicleManagerStatus: DKVehicleManagerStatus
                    switch status {
                        case .success:
                            vehicleManagerStatus = .success
                        case .invalidVehicle, .error:
                            vehicleManagerStatus = .error
                        @unknown default:
                            vehicleManagerStatus = .error
                    }
                    completion(vehicleManagerStatus, vehicleId)
                })
            } else if let vehicleType = self.vehicleType {
                switch vehicleType {
                    case .car:
                        if let carCharacteristics = characteristics as? DKCarVehicleCharacteristics {
                            DriveKitVehicle.shared.createCarVehicle(
                                characteristics: carCharacteristics,
                                name: self.vehicleName,
                                liteConfig: self.liteConfig,
                                detectionMode: self.detectionMode,
                                completionHandler: { status, vehicle in
                                    completion(status, vehicle?.vehicleId)
                                })
                        }
                    case .truck:
                        if let truckCharacteristics = characteristics as? DKTruckVehicleCharacteristics {
                            DriveKitVehicle.shared.createTruckVehicle(
                                characteristics: truckCharacteristics,
                                name: self.vehicleName,
                                detectionMode: self.detectionMode,
                                completionHandler: { status, vehicle in
                                    completion(status, vehicle?.vehicleId)
                                })
                        }
                    @unknown default:
                        completion(.error, nil)
                }
            }
        }
    }

    func replaceVehicle(previousVehicle: DKVehicle, completion: @escaping (DKVehicleReplaceStatus, String?) -> Void) {
        if let vehicleType = self.vehicleType, let characteristics = vehicleCharacteristics {
            let completionHandler: (DKVehicleReplaceStatus, DKVehicle?) -> Void = { status, vehicle in
                guard status == .success else {
                    completion(status, nil)
                    return
                }
                
                completion(status, vehicle?.vehicleId)
            }

            switch vehicleType {
                case .car:
                    if let carCharacteristics = characteristics as? DKCarVehicleCharacteristics {
                        DriveKitVehicle.shared.replaceWithCarVehicle(
                            oldVehicleId: previousVehicle.vehicleId,
                            characteristics: carCharacteristics,
                            name: self.vehicleName,
                            liteConfig: self.liteConfig,
                            completionHandler: completionHandler
                        )
                    }
                case .truck:
                    if let truckCharacteristics = characteristics as? DKTruckVehicleCharacteristics {
                        DriveKitVehicle.shared.replaceWithTruckVehicle(
                            oldVehicleId: previousVehicle.vehicleId,
                            characteristics: truckCharacteristics,
                            name: self.vehicleName,
                            completionHandler: completionHandler
                        )
                    }
                @unknown default:
                    completion(.error, nil)
            }
        }
    }

    func createViewController() -> UIViewController {
        let stepViewModel = VehiclePickerStepViewModel(step: currentStep, pickerViewModel: self)
        return currentStep.getViewController(viewModel: stepViewModel)
    }
}
