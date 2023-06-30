// swiftlint:disable all
//
//  DKDriverDataImages.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 13/07/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

public enum DKDriverDataImages: String {
    case mapAccel = "dk_map_accel",
         mapAccelHigh = "dk_map_accel_high",
         mapDecel = "dk_map_decel",
         mapDecelHigh = "dk_map_decel_high",
         mapAdh = "dk_map_adh",
         mapAdhHigh = "dk_map_adh_high",
         mapLock = "dk_map_lock",
         mapUnlock = "dk_map_unlock",
         mapBeginCall = "dk_map_begin_call",
         mapEndCall = "dk_map_end_call",
         mapArrival = "dk_map_arrival",
         mapDeparture = "dk_map_departure",
         lockEvent = "dk_lock_event",
         unlockEvent = "dk_unlock_event",
         endCall = "dk_end_call",
         arrival = "dk_arrival",
         departure = "dk_departure",
         history = "dk_history",
         historyFilled = "dk_history_filled",
         trash = "dk_trash",
         adviceAgree = "dk_advice_agree",
         adviceDisagree = "dk_advice_disagree",
         transportationOther = "dk_transportation_other",
         transportationCar = "dk_transportation_car",
         transportationMotorcycle = "dk_transportation_motorcycle",
         transportationTruck = "dk_transportation_truck",
         transportationBus = "dk_transportation_bus",
         transportationTrain = "dk_transportation_train",
         transportationBoat = "dk_transportation_boat",
         transportationBicyle = "dk_transportation_bicycle",
         transportationPlane = "dk_transportation_plane",
         transportationSkiing = "dk_transportation_skiing",
         transportationOnFoot = "dk_transportation_on_foot",
         transportationIdle = "dk_transportation_idle",
         transportationAll = "dk_transportation_all",
         transportationDriver = "dk_transportation_driver",
         transportationPassenger = "dk_transportation_passenger",
         placeholderNoTrips = "dk_placeholder_no_trip",
         noVehicleTrips = "dk_no_vehicle_trips",
         filter = "dk_filter",
         trendPositive = "dk_driver_data_trend_positive",
         trendNegative = "dk_driver_data_trend_negative",
         trendSteady = "dk_driver_data_trend_steady",
         driverProfileMobility = "dk_profile_mobility",
         driverProfileContext = "dk_profile_context",
         driverProfileRegularity = "dk_profile_regularity",
         driverProfileActivity = "dk_profile_activity",
         driverProfileDistance = "dk_profile_distance",
         driverProfileEmpty = "dk_profile_empty"
    
    public var image: UIImage? {
        if let image = UIImage(named: self.rawValue, in: .main, compatibleWith: nil) {
            return image
        } else {
            return UIImage(named: self.rawValue, in: .driverDataUIBundle, compatibleWith: nil)
        }
    }
}
