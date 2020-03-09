//
//  DKVehicleCategory+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicle

extension DKVehicleCategory : VehiclePickerCollectionViewItem {
    func title() -> String {
        switch self {
        case .micro:
            return "micro"
        case .compact:
            return "compact"
        case .sedan:
            return "sedan"
        case .suv:
            return "suv"
        case .minivan:
            return "minivan"
        case .commercial:
            return "commercial"
        case .luxury:
            return "luxury"
        case .sport:
            return "sport"
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .micro:
            return UIImage(named: "dk_icon_micro", in: .vehicleUIBundle, compatibleWith: nil)
        case .compact:
            return UIImage(named: "dk_icon_compact", in: .vehicleUIBundle, compatibleWith: nil)
        case .sedan:
            return UIImage(named: "dk_icon_sedan", in: .vehicleUIBundle, compatibleWith: nil)
        case .suv:
            return UIImage(named: "dk_icon_suv", in: .vehicleUIBundle, compatibleWith: nil)
        case .minivan:
            return UIImage(named: "dk_icon_minivan", in: .vehicleUIBundle, compatibleWith: nil)
        case .commercial:
            return UIImage(named: "dk_icon_commercial", in: .vehicleUIBundle, compatibleWith: nil)
        case .luxury:
            return UIImage(named: "dk_icon_luxury", in: .vehicleUIBundle, compatibleWith: nil)
        case .sport:
            return UIImage(named: "dk_icon_sport", in: .vehicleUIBundle, compatibleWith: nil)
        }
    }
}

extension DKVehicleCategory : VehiclePickerTextDelegate {
    func onLiteConfigSelected(viewModel : VehiclePickerViewModel) {
        viewModel.liteConfig = true
        viewModel.currentStep = .name
        viewModel.vehicleCharacteristics = DKVehicleCharacteristics()
        viewModel.vehicleCharacteristics?.dqIndex = self.liteConfigId()
    }
    
    func onFullConfigSelected(viewModel : VehiclePickerViewModel) {
        viewModel.liteConfig = false
        if VehiclePickerStep.brandsIcons.getCollectionViewItems(viewModel: viewModel).isEmpty {
            viewModel.currentStep = .brandsFull
        } else {
            viewModel.currentStep = .brandsIcons
        }
    }
    
    func categoryDescription() -> String {
        switch self {
        case .micro:
            return "category_car_micro_compact_description".dkVehicleLocalized()
        case .compact:
            return "category_car_compact_description".dkVehicleLocalized()
        case .sedan:
            return "category_car_sedan_description".dkVehicleLocalized()
        case .suv:
            return "category_car_suv_description".dkVehicleLocalized()
        case .minivan:
            return "category_car_minivan_description".dkVehicleLocalized()
        case .commercial:
            return "category_car_commercial_description".dkVehicleLocalized()
        case .luxury:
            return "category_car_luxury_description".dkVehicleLocalized()
        case .sport:
            return "category_car_sport_description".dkVehicleLocalized()
        }
    }
    
    func categoryImage() -> UIImage? {
        switch self {
        case .micro:
            return UIImage(named: "dk_image_micro", in: .vehicleUIBundle, compatibleWith: nil)
        case .compact:
            return UIImage(named: "dk_image_compact", in: .vehicleUIBundle, compatibleWith: nil)
        case .sedan:
            return UIImage(named: "dk_image_sedan", in: .vehicleUIBundle, compatibleWith: nil)
        case .suv:
            return UIImage(named: "dk_image_suv", in: .vehicleUIBundle, compatibleWith: nil)
        case .minivan:
            return UIImage(named: "dk_image_minivan", in: .vehicleUIBundle, compatibleWith: nil)
        case .commercial:
            return UIImage(named: "dk_image_commercial", in: .vehicleUIBundle, compatibleWith: nil)
        case .luxury:
            return UIImage(named: "dk_image_luxury", in: .vehicleUIBundle, compatibleWith: nil)
        case .sport:
            return UIImage(named: "dk_image_sport", in: .vehicleUIBundle, compatibleWith: nil)
        }
    }
    
    func liteConfigId() -> String {
        switch self {
        case .micro:
            return "ToAy2018FT1P0069N008"
        case .compact:
            return "ReCl2018FT1P0090N018"
        case .sedan:
            return "FoMo2018FT2P0150N007"
        case .suv:
            return "ToRa2018FT1P0151N001"
        case .minivan:
            return "CiGr2018FT2P0120N007"
        case .commercial:
            return "ReMa2018FT2P0125N050"
        case .luxury:
            return "AuA62018FT2P0190N018"
        case .sport:
            return "AlA12018FT1P0252N001"
        }
    }
}
