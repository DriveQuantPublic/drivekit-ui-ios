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
    private let trip: DKTrip
    let unknown = "dk_driverdata_unknown".dkDriverDataLocalized()
    
    init(trip: DKTrip) {
        self.trip = trip
    }
    
    var conditionValue: String {
        if let dayValue = trip.tripStatistics?.day {
            return dayValue ? "dk_driverdata_day".dkDriverDataLocalized() : "dk_driverdata_night".dkDriverDataLocalized()
        } else {
            return unknown
        }
    }
    
    var weatherValue: String {
        if let meteo = trip.tripStatistics?.weather {
            switch meteo {
                case .sun:
                    return "dk_driverdata_weather_sun".dkDriverDataLocalized()
                case .cloud:
                    return "dk_driverdata_weather_cloud".dkDriverDataLocalized()
                case .fog:
                    return "dk_driverdata_weather_fog".dkDriverDataLocalized()
                case .rain:
                    return "dk_driverdata_weather_rain".dkDriverDataLocalized()
                case .snow:
                    return "dk_driverdata_weather_snow".dkDriverDataLocalized()
                case .ice:
                    return "dk_driverdata_weather_hail".dkDriverDataLocalized()
                default:
                    return "dk_driverdata_weather_sun".dkDriverDataLocalized()
            }
        } else {
            return unknown
        }
    }
    
    var meanSpeedValue: String {
        let transportationMode = declaredTransportationMode() ?? detectedTransportationMode()
        if transportationMode == .idle {
            return "-"
        } else {
            if let value = trip.tripStatistics?.speedMean {
                return value.formatSpeedMean()
            } else {
                return unknown
            }
        }
    }

    func detectedTransportationMode() -> TransportationMode {
        return trip.transportationMode
    }

    func declaredTransportationMode() -> TransportationMode? {
        if let declaredTransportation = trip.declaredTransportationMode?.transportationMode {
            return declaredTransportation
        } else {
            return nil
        }
    }

    func getTransportationModeViewModel() -> TransportationModeViewModel {
        return TransportationModeViewModel(trip: self.trip)
    }
}
