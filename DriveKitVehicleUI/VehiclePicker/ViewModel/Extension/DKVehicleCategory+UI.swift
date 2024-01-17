// swiftlint:disable cyclomatic_complexity
//
//  DKVehicleCategory+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitVehicleModule

extension DKVehicleCategory: VehiclePickerCollectionViewItem {
    func title() -> String {
        return titleRawValue().dkVehicleLocalized()
    }

    func titleRawValue() -> String {
        switch self {
            case .micro:
                return "dk_vehicle_category_car_micro_title"
            case .compact:
                return "dk_vehicle_category_car_compact_title"
            case .sedan:
                return "dk_vehicle_category_car_sedan_title"
            case .suv:
                return "dk_vehicle_category_car_suv_title"
            case .minivan:
                return "dk_vehicle_category_car_minivan_title"
            case .commercial:
                return "dk_vehicle_category_car_commercial_title"
            case .luxury:
                return "dk_vehicle_category_car_luxury_title"
            case .sport:
                return "dk_vehicle_category_car_sport_title"
            case .twoAxlesStraightTruck:
                return "dk_vehicle_category_truck_straight_2_axles"
            case .threeAxlesStraightTruck:
                return "dk_vehicle_category_truck_straight_3_axles"
            case .fourAxlesStraightTruck:
                return "dk_vehicle_category_truck_straight_4_axles"
            case .twoAxlesTractor:
                return "dk_vehicle_category_truck_trailer_2_axles"
            case .threeAxlesTractor:
                return "dk_vehicle_category_truck_trailer_3_axles"
            case .fourAxlesTractor:
                return "dk_vehicle_category_truck_trailer_4_axles"
            @unknown default:
                return ""
        }
    }

    func image() -> UIImage? {
        switch self {
            case .micro:
                return DKVehicleImages.iconMicro.image
            case .compact:
                return DKVehicleImages.iconCompact.image
            case .sedan:
                return DKVehicleImages.iconSedan.image
            case .suv:
                return DKVehicleImages.iconSuv.image
            case .minivan:
                return DKVehicleImages.iconMinivan.image
            case .commercial:
                return DKVehicleImages.iconCommercial.image
            case .luxury:
                return DKVehicleImages.iconLuxury.image
            case .sport:
                return DKVehicleImages.iconSport.image
            case .twoAxlesStraightTruck, .threeAxlesStraightTruck, .fourAxlesStraightTruck, .twoAxlesTractor, .threeAxlesTractor, .fourAxlesTractor:
                return nil
            @unknown default:
                return nil
        }
    }
}

extension DKVehicleCategory: VehiclePickerTextDelegate {
    func onLiteConfigSelected(viewModel: VehiclePickerViewModel) {
        viewModel.liteConfig = true
        viewModel.nextStep(.categoryDescription)
    }

    func onFullConfigSelected(viewModel: VehiclePickerViewModel) {
        viewModel.liteConfig = false
        viewModel.nextStep(.categoryDescription)
    }

    func categoryDescription() -> String {
        switch self {
            case .micro:
                return "dk_vehicle_category_car_micro_description".dkVehicleLocalized()
            case .compact:
                return "dk_vehicle_category_car_compact_description".dkVehicleLocalized()
            case .sedan:
                return "dk_vehicle_category_car_sedan_description".dkVehicleLocalized()
            case .suv:
                return "dk_vehicle_category_car_suv_description".dkVehicleLocalized()
            case .minivan:
                return "dk_vehicle_category_car_minivan_description".dkVehicleLocalized()
            case .commercial:
                return "dk_vehicle_category_car_commercial_description".dkVehicleLocalized()
            case .luxury:
                return "dk_vehicle_category_car_luxury_description".dkVehicleLocalized()
            case .sport:
                return "dk_vehicle_category_car_sport_description".dkVehicleLocalized()
            case .twoAxlesStraightTruck, .threeAxlesStraightTruck, .fourAxlesStraightTruck, .twoAxlesTractor, .threeAxlesTractor, .fourAxlesTractor:
                return ""
            @unknown default:
                return ""
        }
    }

    func categoryImage() -> UIImage? {
        switch self {
            case .micro:
                return DKVehicleImages.imageMicro.image
            case .compact:
                return DKVehicleImages.imageCompact.image
            case .sedan:
                return DKVehicleImages.imageSedan.image
            case .suv:
                return DKVehicleImages.imageSuv.image
            case .minivan:
                return DKVehicleImages.imageMinivan.image
            case .commercial:
                return DKVehicleImages.imageCommercial.image
            case .luxury:
                return DKVehicleImages.imageLuxury.image
            case .sport:
                return DKVehicleImages.imageSport.image
            case .twoAxlesStraightTruck, .threeAxlesStraightTruck, .fourAxlesStraightTruck, .twoAxlesTractor, .threeAxlesTractor, .fourAxlesTractor:
                return nil
            @unknown default:
                return nil
        }
    }

    func liteConfigId(isElectric: Bool) -> String? {
        self.getLiteConfigDqIndex(isElectric: isElectric)
    }
}
