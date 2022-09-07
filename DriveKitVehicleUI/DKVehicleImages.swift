//
//  DKVehicleImages.swift
//  DriveKitVehicleUI
//
//  Created by Amine Gahbiche on 23/08/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

public enum DKVehicleImages: String {
    case beaconBattery25 = "dk_beacon_battery_25",
         beaconBattery50 = "dk_beacon_battery_50",
         beaconBattery75 = "dk_beacon_battery_75",
         beaconBattery100 = "dk_beacon_battery_100",
         beaconSignalIntensity = "dk_beacon_signal_intensity",
         beaconDistance = "dk_beacon_distance",
         beaconNotFound = "dk_beacon_not_found",
         beaconOk = "dk_beacon_ok",
         beaconRetry = "dk_beacon_retry",
         beaconScanRunning = "dk_beacon_scan_running",
         beaconStart = "dk_beacon_start",
         vehicleCongrats = "dk_vehicle_congrats",
         galleryImage = "dk_gallery_image",
         iconCommercial = "dk_icon_commercial",
         iconStraightTruck = "dk_icon_straight_truck",
         iconSemiTrailerTruck = "dk_icon_semi_trailer_truck",
         iconRoadTrain = "dk_icon_road_train",
         iconSuv = "dk_icon_suv",
         iconCompact = "dk_icon_compact",
         iconLuxury = "dk_icon_luxury",
         iconMicro = "dk_icon_micro",
         iconMinivan = "dk_icon_minivan",
         iconSedan = "dk_icon_sedan",
         iconSport = "dk_icon_sport",
         imageLuxury = "dk_image_luxury",
         imageMicro = "dk_image_micro",
         imageMinivan = "dk_image_minivan",
         imageSedan = "dk_image_sedan",
         imageSport = "dk_image_sport",
         imageSuv = "dk_image_suv",
         imageCommercial = "dk_image_commercial",
         imageCompact = "dk_image_compact",
         defaultCar = "dk_default_car",
         defaultTruck = "dk_default_truck",
         vehicleNameChooser = "dk_vehicle_name_chooser",
         vehicleOdometer = "dk_vehicle_odometer"
    


    public var image: UIImage? {
        if let image = UIImage(named: self.rawValue, in: .main, compatibleWith: nil) {
            return image
        } else {
            return UIImage(named: self.rawValue, in: .vehicleUIBundle, compatibleWith: nil)
        }
    }
}
