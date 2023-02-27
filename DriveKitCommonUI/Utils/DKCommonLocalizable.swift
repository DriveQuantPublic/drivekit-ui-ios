// swiftlint:disable all
//
//  DKLocalizable.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 27/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public enum DKCommonLocalizable: String {
    case unitMeter = "dk_common_unit_meter",
    unitKilometer = "dk_common_unit_kilometer",
    unitMile = "dk_common_unit_mile",
    unitSecond = "dk_common_unit_second",
    unitMinute = "dk_common_unit_minute",
    unitHour = "dk_common_unit_hour",
    unitDay = "dk_common_unit_day",
    unitGram = "dk_common_unit_g",
    unitKilogram = "dk_common_unit_kg",
    unitTon = "dk_common_unit_ton",
    unitLiter = "dk_common_unit_liter",
    unitGallon = "dk_common_unit_gallon",
    unitGperKM = "dk_common_unit_g_per_km",
    unitKmPerHour = "dk_common_unit_km_per_hour",
    unitLPer100Km = "dk_common_unit_l_per_100km",
    unitkWhPer100Km = "dk_common_unit_kwh_per_100km",
    unitPower = "dk_common_unit_power",
    unitMPG = "dk_common_unit_mpg",
    unitMPH = "dk_common_unit_mph",
    unitAcceleration = "dk_common_unit_accel_meter_per_second_square",
    unitScore = "dk_common_unit_score",
    speed = "dk_common_speed",
    distance = "dk_common_distance",
    duration = "dk_common_duration",
    meanSpeed = "dk_common_mean_speed",
    mass = "dk_common_mass",
    tripSingular = "dk_common_trip_singular",
    tripPlural = "dk_common_trip_plural",
    daySingular = "dk_common_day_singular",
    dayPlural = "dk_common_day_plural",
    consumption = "dk_common_consumption",
    ok = "dk_common_ok",
    cancel = "dk_common_cancel",
    save = "dk_common_save",
    validate = "dk_common_validate",
    confirm = "dk_common_confirm",
    later = "dk_common_later",
    close = "dk_common_close",
    finish = "dk_common_finish",
    edit = "dk_common_edit",
    delete = "dk_common_delete",
    loading = "dk_common_loading",
    error = "dk_common_error_message",
    errorEmpty = "dk_common_error_empty_field",
    safety = "dk_common_safety",
    speeding = "dk_common_speed_limit",
    distraction = "dk_common_distraction",
    ecodriving = "dk_common_ecodriving",
    contextCityDense = "dk_common_driving_context_city_dense",
    contextCity = "dk_common_driving_context_city",
    contextExternal = "dk_common_driving_context_external",
    contextFastlane = "dk_common_driving_context_fastlane",
    ecodrivingAccelerationLow = "dk_common_ecodriving_accel_low",
    ecodrivingAccelerationWeak = "dk_common_ecodriving_accel_weak",
    ecodrivingAccelerationGood = "dk_common_ecodriving_accel_good",
    ecodrivingAccelerationStrong = "dk_common_ecodriving_accel_strong",
    ecodrivingAccelerationHigh = "dk_common_ecodriving_accel_high",
    ecodrivingSpeedMaintainGood = "dk_common_ecodriving_speed_good_maintain",
    ecodrivingSpeedMaintainWeak = "dk_common_ecodriving_speed_weak_maintain",
    ecodrivingSpeedMaintainBad = "dk_common_ecodriving_speed_bad_maintain",
    ecodrivingDecelerationLow = "dk_common_ecodriving_decel_low",
    ecodrivingDecelerationWeak = "dk_common_ecodriving_decel_weak",
    ecodrivingDecelerationGood = "dk_common_ecodriving_decel_good",
    ecodrivingDecelerationStrong = "dk_common_ecodriving_decel_strong",
    ecodrivingDecelerationHigh = "dk_common_ecodriving_decel_high",
    updatePhotoTitle = "dk_common_update_photo_title",
    camera = "dk_common_take_picture",
    gallery = "dk_common_select_image_gallery",
    cameraPermission = "dk_common_permission_camera_rationale",
    sendMailError = "dk_common_send_mail_error",
    yes = "dk_common_yes",
    no = "dk_common_no",
    rank = "dk_common_ranking_rank",
    rankingScore = "dk_common_ranking_score",
    rankingDriver = "dk_common_ranking_driver",
    pseudo = "dk_common_pseudo",
    noPseudo = "dk_common_no_pseudo_set",
    anonymous = "dk_common_anonymous_driver",
    seeMoreTrips = "dk_common_see_more_trips",
    periodSelectorWeek = "dk_common_period_selector_week",
    periodSelectorMonth = "dk_common_period_selector_month",
    periodSelectorYear = "dk_common_period_selector_year"

    public func text() -> String {
        return self.rawValue.dkLocalized(tableName: "CommonLocalizable", bundle: .driveKitCommonUIBundle ?? .main)
    }
}

public extension String {
    func dkLocalized(tableName: String, bundle: Bundle) -> String {
        if let overridedFile = DriveKitUI.shared.overridedStringFileName {
            let localizedString = NSLocalizedString(self, tableName: overridedFile, bundle: .main, value: "", comment: "")
            if localizedString.isEmpty || localizedString == self {
                return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: self, comment: "")
            } else {
                return localizedString
            }
        } else {
            return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: self, comment: "")
        }
    }
}
