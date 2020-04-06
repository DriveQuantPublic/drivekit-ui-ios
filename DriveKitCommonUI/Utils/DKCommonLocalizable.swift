//
//  DKLocalizable.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 27/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public enum DKCommonLocalizable : String {
    case unitMeter = "dk_common_unit_meter",
    unitKilometer = "dk_common_unit_kilometer",
    unitMile = "dk_common_unit_mile",
    unitSecond = "dk_common_unit_second",
    unitMinute = "dk_common_unit_minute",
    unitHour = "dk_common_unit_hour",
    unitDay = "dk_common_unit_day",
    unitGram = "dk_common_unit_g",
    unitKilogram = "dk_common_unit_kg",
    unitTon = "dk_common_unit_T",
    unitLiter = "dk_common_unit_liter",
    unitGallon = "dk_common_unit_gallon",
    unitGperKM = "dk_common_unit_g_per_km",
    unitKmPerHour = "dk_common_unit_km_per_hour",
    unitLPer100Km = "dk_common_unit_l_per_100km",
    unitPower = "dk_common_unit_power",
    unitMPG = "dk_common_unit_mpg",
    unitMPH = "dk_common_unit_mph",
    unitAcceleration = "dk_common_unit_accel_meter_per_second_square",
    speed = "dk_common_speed",
    distance = "dk_common_distance",
    duration = "dk_common_duration",
    meanSpeed = "dk_common_mean_speed",
    mass = "dk_common_mass",
    tripSingular = "dk_common_trip_singular",
    tripPlural = "dk_common_trip_plural",
    consumption = "dk_common_consumption",
    ok = "dk_common_ok",
    cancel = "dk_common_cancel",
    save = "dk_common_save",
    validate = "dk_common_validate",
    confirm = "dk_common_confirm",
    close = "dk_common_close",
    finish = "dk_common_finish",
    edit = "dk_common_edit",
    delete = "dk_common_delete",
    loading = "dk_common_loading",
    safety = "dk_common_safety",
    distraction = "dk_common_distraction",
    ecodriving = "dk_common_ecodriving",
    contextCityDense = "dk_common_driving_context_city_dense",
    contextCity = "dk_common_driving_context_city",
    contextExternal = "dk_common_driving_context_external",
    contextFastlane = "dk_common_driving_context_fastlane",
    updatePhotoTitle = "dk_common_update_photo_title",
    camera = "dk_common_take_picture",
    gallery = "dk_common_select_image_gallery",
    cameraPermission = "dk_common_permission_camera_rationale"
    
    
    
    public func text() -> String {
        return self.rawValue.dkLocalized(tableName: "CommonLocalizable", bundle: .driveKitCommonUIBundle ?? .main)
    }
}

public extension String {
    func dkLocalized(tableName: String, bundle : Bundle) -> String {
        if let overridedFile = DriveKitUI.shared.overridedStringFileName {
            let localizedString = NSLocalizedString(self, tableName: overridedFile, bundle: .main, value: "", comment: "")
            if localizedString.isEmpty || localizedString == self {
                return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: self, comment: "")
            } else {
                return localizedString
            }
        }else{
            return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: self, comment: "")
        }
    }
}
