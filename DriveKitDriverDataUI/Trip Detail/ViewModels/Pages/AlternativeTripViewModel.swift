//
//  AlternativeTripViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 09/12/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

class AlternativeTripViewModel {
   
    private let trip: Trip
    let unknown = "dk_driverdata_unknown".dkDriverDataLocalized()
    
    init(trip: Trip) {
        self.trip = trip
    }
    
    func detectedTransportationMode() -> TransportationMode {
        return TransportationMode(rawValue: Int(trip.transportationMode)) ?? .unknown
    }
    
    func declaredTransportationMode() -> TransportationMode? {
        if let declaredTransportation = trip.declaredTransportationMode?.transportationMode {
            return TransportationMode(rawValue: Int(declaredTransportation))
        } else {
            return nil
        }
    }
    
    var conditionValue: String {
        if let dayValue = trip.tripStatistics?.day {
            return dayValue ? "dk_driverdata_day".dkDriverDataLocalized() : "dk_driverdata_night".dkDriverDataLocalized()
        } else {
            return unknown
        }
    }
    
    var weatherValue : String {
        if let meteo = trip.tripStatistics?.meteo {
            switch meteo {
                case 1:
                    return "dk_driverdata_weather_sun".dkDriverDataLocalized()
                case 2:
                    return "dk_driverdata_weather_cloud".dkDriverDataLocalized()
                case 3:
                    return "dk_driverdata_weather_rain".dkDriverDataLocalized()
                case 4:
                    return "dk_driverdata_weather_fog".dkDriverDataLocalized()
                case 5:
                    return "dk_driverdata_weather_snow".dkDriverDataLocalized()
                case 6:
                    return "dk_driverdata_weather_hail".dkDriverDataLocalized()
                default:
                    return "dk_driverdata_weather_sun".dkDriverDataLocalized()
            }
        } else {
            return unknown
        }
    }
    
    var meanSpeedValue : String {
        if let value = trip.tripStatistics?.speedMean {
            return value.formatSpeedMean()
        } else {
            return unknown
        }
    }
}
