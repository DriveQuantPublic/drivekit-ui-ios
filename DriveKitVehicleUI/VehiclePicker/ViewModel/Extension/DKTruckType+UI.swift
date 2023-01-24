//
//  DKTruckType+UI.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 03/06/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitVehicleModule

extension DKTruckType: VehiclePickerCollectionViewItem {

    func title() -> String {
        switch self {
            case .roadTrain:
                return "dk_vehicle_type_truck_road_train".dkVehicleLocalized()
            case .semiTrailerTruck:
                return "dk_vehicle_type_truck_tractor_semi_trailer".dkVehicleLocalized()
            case .straightTruck:
                return "dk_vehicle_category_truck_straight".dkVehicleLocalized()
            @unknown default:
                return ""
        }
    }

    func image() -> UIImage? {
        if let imageKey = imageKey() {
            return DKVehicleImages(rawValue: imageKey)?.image
        }
        return nil
    }

    func hasImage() -> Bool {
        return imageKey() != nil
    }

    private func imageKey() -> String? {
        switch self {
            case .roadTrain:
                return "dk_icon_road_train"
            case .semiTrailerTruck:
                return "dk_icon_semi_trailer_truck"
            case .straightTruck:
                return "dk_icon_straight_truck"
            @unknown default:
                return nil
        }
    }

}
