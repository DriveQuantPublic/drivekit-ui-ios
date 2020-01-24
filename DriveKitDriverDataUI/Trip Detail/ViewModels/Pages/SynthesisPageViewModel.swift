//
//  SynthesisPageViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Meryl Barantal on 17/12/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverData

class SynthesisPageViewModel {
    let tripDetailViewModel : TripDetailViewModel
    let trip : Trip
    
    init(tripDetailViewModel: TripDetailViewModel, trip: Trip) {
        self.trip = trip
        self.tripDetailViewModel = tripDetailViewModel
    }
    
    let synthesisVehicle = "dk_synthesis_vehicle".dkLocalized()
    let meanSpeed = "dk_synthesis_mean_speed".dkLocalized()
    let stopTime = "dk_synthesis_stop_time".dkLocalized()
    let fuelConsumption = "dk_synthesis_fuel_consumption".dkLocalized()
    let co2Emissions = "dk_synthesis_co2_emmissions".dkLocalized()
    let co2Mass = "dk_synthesis_co2_mass".dkLocalized()
    let condition = "dk_synthesis_condition".dkLocalized()
    let weather = "dk_synthesis_weather".dkLocalized()
    let roadContext = "dk_synthesis_road_context".dkLocalized()
    let unitKg = "dk_unit_kg".dkLocalized()
    let unitG = "dk_unit_g".dkLocalized()
    let unitGperKm = "dk_unit_g_per_km".dkLocalized()
    let unitLiterPerKm = "dk_unit_liter_per_100km".dkLocalized()
    let unitKmPerHour = "dk_unit_km_per_hour".dkLocalized()
    let unknown = "dk_unknown".dkLocalized()
    let drivingContextDense = "dk_driving_context_city_dense".dkLocalized()
    let drivingContextCity = "dk_driving_context_city".dkLocalized()
    let drivingContextExternal = "dk_driving_context_external".dkLocalized()
    let drivingContextFastlane = "dk_driving_context_fastlane".dkLocalized()
    let weatherSun = "dk_weather_sun".dkLocalized()
    let weatherCloud = "dk_weather_cloud".dkLocalized()
    let weatherFog = "dk_weather_fog".dkLocalized()
    let weatherRain = "dk_weather_rain".dkLocalized()
    let weatherSnow = "dk_weather_snow".dkLocalized()
    let weatherHail = "dk_weather_hail".dkLocalized()
    let day = "dk_day".dkLocalized()
    let night = "dk_night".dkLocalized()

    var fuelConsumptionValue : String {
        let unit = unitLiterPerKm
        if let value = trip.fuelEstimation?.fuelConsumption, value != 0{
            return String(format: "%.1f %@", value, unit)
        } else {
            return unknown
        }
    }
    
    var conditionValue: String {
        if let dayValue = trip.tripStatistics?.day {
            return dayValue ? day : night
        } else {
            return unknown
        }
    }
    
    var meanSpeedValue : String {
        if let value = trip.tripStatistics?.speedMean {
            return String(format: "%.0f %@", value, unitKmPerHour)
        } else {
            return unknown
        }
    }
    
    var stopTimeValue : String {
        if let value = trip.tripStatistics?.idlingDuration {
            let durationInMinutes = value / 60
            return durationInMinutes.formattedDuration
        } else {
            return unknown
        }
    }
    
    var co2EmissionValue : String {
        if let value = trip.fuelEstimation?.co2Emission {
            return String(format: "%.0f %@", value, unitGperKm)
        } else {
            return unknown
        }
    }
    
    var weatherValue : String {
        if let meteo = trip.tripStatistics?.meteo {
            switch meteo {
                case 1:
                    return weatherSun
                case 2:
                    return weatherCloud
                case 3:
                    return weatherRain
                case 4:
                    return weatherFog
                case 5:
                    return weatherSnow
                case 6:
                    return weatherHail
                default:
                    return weatherSun
            }
        } else {
            return unknown
        }
    }
    
    var co2MassValue: String {
        if let value = trip.fuelEstimation?.co2Mass {
            if value < 1 {
                let co2Value = value * 1000
                return String(format: "%.0f %@", co2Value, unitG)
            } else {
                return String(format: "%.0f %@", value, unitKg)
            }
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
                return drivingContextDense
            case 2:
                return drivingContextCity
            case 3:
                return drivingContextExternal
            case 4:
                return drivingContextFastlane
            default:
                return drivingContextExternal
            }
        } else {
            return unknown
        }
    }
}
