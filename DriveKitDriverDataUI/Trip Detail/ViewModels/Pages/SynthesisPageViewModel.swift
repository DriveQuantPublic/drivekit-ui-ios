//
//  SynthesisPageViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Meryl Barantal on 17/12/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverData
import DriveKitDBTripAccess
import DriveKitCommonUI

class SynthesisPageViewModel {
    let tripDetailViewModel : TripDetailViewModel
    let trip : Trip
    
    let unknown = "dk_driverdata_unknown".dkDriverDataLocalized()
    
    init(tripDetailViewModel: TripDetailViewModel, trip: Trip) {
        self.trip = trip
        self.tripDetailViewModel = tripDetailViewModel
    }
    
    var fuelConsumptionValue : String {
        if let value = trip.fuelEstimation?.fuelConsumption, value != 0{
            return value.formatConsumption()
        } else {
            return unknown
        }
    }
    
    var conditionValue: String {
        if let dayValue = trip.tripStatistics?.day {
            return dayValue ? "dk_driverdata_day".dkDriverDataLocalized() : "dk_driverdata_night".dkDriverDataLocalized()
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
    
    var stopTimeValue : String {
        if let value = trip.tripStatistics?.idlingDuration {
            return value.formatSecondDuration()
        } else {
            return unknown
        }
    }
    
    var co2EmissionValue : String {
        if let value = trip.fuelEstimation?.co2Emission {
            return value.formatCO2Emission()
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
    
    var co2MassValue: String {
        if let value = trip.fuelEstimation?.co2Mass {
            return value.formatCO2Mass()
        } else {
            return unknown
        }
    }
    
    var contextValue : String {
        if let contexts = trip.ecoDrivingContexts?.allObjects as? [EcoDrivingContext] {
            var mainContext: EcoDrivingContext = contexts[0]
            
            for context in contexts {
                if context.distance > mainContext.distance {
                    mainContext = context
                }
            }
            switch mainContext.contextId {
            case 0, 1:
                return DKCommonLocalizable.contextCityDense.text()
            case 2:
                return DKCommonLocalizable.contextCity.text()
            case 3:
                return DKCommonLocalizable.contextExternal.text()
            case 4:
                return DKCommonLocalizable.contextFastlane.text()
            default:
                return DKCommonLocalizable.contextExternal.text()
            }
        } else {
            return unknown
        }
    }
}
