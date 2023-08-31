// swiftlint:disable all
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
        previousSteps.append(self.currentStep)
        nextStepInternal(step)
    }

    private func nextStepInternal(_ step: VehiclePickerStep?) {
        if let step = step {
            switch step {
                case .type:
                    nextStepAfterTypeStep()
                case .truckType:
                    nextStepAfterTruckTypeStep()
                case .category:
                    nextStepAfterCategoryStep()
                case .categoryDescription:
                    nextStepAfterCategoryDescriptionStep()
                case .brandsFull:
                    nextStepAfterBrandsFullStep()
                case .brandsIcons:
                    nextStepAfterBrandsIconsStep()
                case .engine:
                    nextStepAfterEngineStep()
                case .models:
                    nextStepAfterModelsStep()
                case .years:
                    nextStepAfterYearsStep()
                case .versions:
                    nextStepAfterVersionsStep()
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
                nextStepInternal(.type)
            }
        }
    }

    private func nextStepAfterTypeStep() {
        if let vehicleType = self.vehicleType {
            let driveKitVehicleUI = DriveKitVehicleUI.shared
            if vehicleType == .truck {
                if driveKitVehicleUI.truckTypes.count > 1 {
                    updateStep(.truckType)
                } else {
                    self.truckType = driveKitVehicleUI.truckTypes.first
                    nextStepInternal(.truckType)
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
                    updateStep(.category)
                } else {
                    self.vehicleCategory = filteredCategories.first
                    nextStepInternal(.category)
                }
            }
        } else {
            nextStepInternal(nil)
        }
    }

    private func nextStepAfterTruckTypeStep() {
        if self.truckType != nil {
            let filteredBrands = DriveKitVehicleUI.shared.brands.filter { $0.isTruck }
            if filteredBrands.count > 1 {
                if !DriveKitVehicleUI.shared.brandsWithIcons || VehiclePickerStep.brandsIcons.getCollectionViewItems(viewModel: self).isEmpty {
                    updateStep(.brandsFull)
                } else {
                    updateStep(.brandsIcons)
                }
            } else {
                self.vehicleBrand = filteredBrands.first
                nextStepInternal(.brandsFull)
            }
        } else {
            nextStepInternal(nil)
        }
    }

    private func nextStepAfterCategoryStep() {
        if let vehicleCategory = self.vehicleCategory, let vehicleType = self.vehicleType, vehicleType != .truck {
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
                self.vehicleCharacteristics = DKCarVehicleCharacteristics()
                self.vehicleCharacteristics?.dqIndex = vehicleCategory.liteConfigId() ?? ""
                updateStep(.name)
            } else if driveKitVehicleUI.categoryConfigType != .brandsConfigOnly {
                updateStep(.categoryDescription)
            } else {
                let filteredBrands = driveKitVehicleUI.brands.filter { !$0.isTruck }
                if filteredBrands.count > 1 {
                    if !driveKitVehicleUI.brandsWithIcons || VehiclePickerStep.brandsIcons.getCollectionViewItems(viewModel: self).isEmpty {
                        updateStep(.brandsFull)
                    } else {
                        updateStep(.brandsIcons)
                    }
                } else {
                    self.vehicleBrand = filteredBrands.first
                    nextStepInternal(.brandsFull)
                }
            }
        } else {
            nextStepInternal(nil)
        }
    }

    private func nextStepAfterCategoryDescriptionStep() {
        if self.liteConfig {
            updateStep(.name)
        } else {
            let filteredBrands = DriveKitVehicleUI.shared.brands.filter { !$0.isTruck }
            if filteredBrands.count > 1 {
                if !DriveKitVehicleUI.shared.brandsWithIcons || VehiclePickerStep.brandsIcons.getCollectionViewItems(viewModel: self).isEmpty {
                    updateStep(.brandsFull)
                } else {
                    updateStep(.brandsIcons)
                }
            } else {
                self.vehicleBrand = filteredBrands.first
                nextStepInternal(.brandsFull)
            }
        }
    }

    private func nextStepAfterBrandsFullStep() {
        if self.vehicleBrand != nil, let vehicleType = self.vehicleType {
            if vehicleType == .truck {
                self.vehicleEngineIndex = DKVehicleEngineIndex.diesel
                nextStepInternal(.engine)
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
                    updateStep(.engine)
                } else {
                    self.vehicleEngineIndex = filteredEngineIndexes.first
                    nextStepInternal(.engine)
                }
            }
        } else {
            nextStepInternal(nil)
        }
    }

    private func nextStepAfterBrandsIconsStep() {
        if self.vehicleBrand != nil, let vehicleType = self.vehicleType {
            if vehicleType == .truck {
                self.vehicleEngineIndex = DKVehicleEngineIndex.diesel
                nextStepInternal(.engine)
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
                    updateStep(.engine)
                } else {
                    self.vehicleEngineIndex = filteredEngineIndexes.first
                    nextStepInternal(.engine)
                }
            }
        } else {
            updateStep(.brandsFull)
        }
    }

    private func nextStepAfterEngineStep() {
        if let vehicleEngineIndex = self.vehicleEngineIndex, let vehicleType = self.vehicleType, let vehicleBrand = self.vehicleBrand {
            let completionHandler: (Bool, [String]?) -> Void = { [weak self] status, response in
                if let self = self {
                    if status {
                        if let listModels = response, !listModels.isEmpty {
                            self.models = listModels
                            self.updateStep(.models)
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
                        nextStepInternal(nil)
                    }
                @unknown default:
                    break
            }
        } else {
            nextStepInternal(nil)
        }
    }

    private func nextStepAfterModelsStep() {
        if let vehicleModel = self.vehicleModel, let vehicleType = self.vehicleType, let vehicleBrand = self.vehicleBrand {
            let completionHandler: (Bool, [String]?) -> Void = { [weak self] status, response in
                if let self = self {
                    if status {
                        if let modelYears = response, !modelYears.isEmpty {
                            self.years = modelYears
                            self.updateStep(.years)
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
                        nextStepInternal(nil)
                    }
                case .truck:
                    if let truckType = self.truckType {
                        DriveKitVehiclePicker.shared.getTruckYears(truckType: truckType, brand: vehicleBrand, model: vehicleModel, completionHandler: completionHandler)
                    } else {
                        nextStepInternal(nil)
                    }
                @unknown default:
                    break
            }
        } else {
            nextStepInternal(nil)
        }
    }

    private func nextStepAfterYearsStep() {
        if let vehicleYear = self.vehicleYear, let vehicleType = self.vehicleType, let vehicleBrand = self.vehicleBrand, let vehicleModel = self.vehicleModel {
            let completionHandler: (Bool, [DKVehicleVersion]?) -> Void = { [weak self] status, response in
                if let self = self {
                    if status {
                        if let vehicleVersions = response, !vehicleVersions.isEmpty {
                            self.versions = vehicleVersions
                            self.updateStep(.versions)
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
                        DriveKitVehiclePicker.shared.getCarVersions(brand: vehicleBrand, engineIndex: vehicleEngineIndex, model: vehicleModel, year: vehicleYear, completionHandler: completionHandler)
                    } else {
                        nextStepInternal(nil)
                    }
                case .truck:
                    if let truckType = self.truckType {
                        DriveKitVehiclePicker.shared.getTruckVersions(truckType: truckType, brand: vehicleBrand, model: vehicleModel, year: vehicleYear, completionHandler: completionHandler)
                    } else {
                        nextStepInternal(nil)
                    }
                @unknown default:
                    break
            }
        } else {
            nextStepInternal(nil)
        }
    }

    private func nextStepAfterVersionsStep() {
        guard let vehicleVersion = self.vehicleVersion, let vehicleType = self.vehicleType else {
            nextStepInternal(nil)
            return
        }
        let completionHandler: (Bool, DKVehicleCharacteristics?) -> Void = { [weak self] status, response in
            if let self = self {
                if status {
                    if let vehicleCharacteristics = response {
                        self.vehicleCharacteristics = vehicleCharacteristics
                        self.updateStep(.name)
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

    private func updateStep(_ step: VehiclePickerStep) {
        self.currentStep = step
        if let vehicleDataDelegate = self.vehicleDataDelegate {
            vehicleDataDelegate.onDataRetrieved(status: .noError)
        } else {
            showStep()
        }
    }

    func showStep() {
        DispatchQueue.dispatchOnMainThread {
            self.vehicleNavigationDelegate?.showStep(viewController: self.getViewController())
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

    func onCollectionViewItemSelected(pos: Int, completion: (StepStatus) -> Void) {
        self.currentStep.onCollectionViewItemSelected(pos: pos, viewModel: self, completion: completion)
    }

    func getCategoryItem() -> VehiclePickerTextDelegate? {
        return vehicleCategory
    }

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
                    }
                    completion(vehicleManagerStatus, vehicleId)
                })
            } else if let vehicleType = self.vehicleType {
                switch vehicleType {
                    case .car:
                        if let carCharacteristics = characteristics as? DKCarVehicleCharacteristics {
                            DriveKitVehicle.shared.createCarVehicle(characteristics: carCharacteristics, name: self.vehicleName, liteConfig: self.liteConfig, detectionMode: self.detectionMode, completionHandler: { status, vehicle in
                                completion(status, vehicle?.vehicleId)
                            })
                        }
                    case .truck:
                        if let truckCharacteristics = characteristics as? DKTruckVehicleCharacteristics {
                            DriveKitVehicle.shared.createTruckVehicle(characteristics: truckCharacteristics, name: self.vehicleName, detectionMode: self.detectionMode, completionHandler: { status, vehicle in
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
