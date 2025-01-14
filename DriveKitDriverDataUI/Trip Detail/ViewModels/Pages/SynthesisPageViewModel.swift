// swiftlint:disable no_magic_numbers
//
//  SynthesisPageViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Meryl Barantal on 17/12/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverDataModule
import DriveKitDBTripAccessModule
import DriveKitCommonUI

class SynthesisPageViewModel {
    let trip: DKTrip
    let unknown = "dk_driverdata_unknown".dkDriverDataLocalized()
    
    init(trip: DKTrip) {
        self.trip = trip
    }

    lazy var consumptionType: DKConsumptionType = {
        if trip.energyEstimation != nil {
            return .electric
        } else {
            return .fuel
        }
    }()

    var vehicleId: String? {
        return trip.vehicleId
    }
    
    var fuelConsumptionValue: String {
        if let value = trip.fuelEstimation?.fuelConsumption, value != 0 {
            return value.formatConsumption(.fuel)
        } else {
            return unknown
        }
    }

    var electricConsumptionValue: String {
        if let value = trip.energyEstimation?.energyConsumption, value != 0 {
            return value.formatConsumption(.electric)
        } else {
            return unknown
        }
    }

    var consumptionValue: String {
        if consumptionType == .fuel {
            return fuelConsumptionValue
        } else {
            return electricConsumptionValue
        }
    }

    var consumptionTitle: String {
        if consumptionType == .fuel {
            return "dk_driverdata_synthesis_fuel_consumption".dkDriverDataLocalized()
        } else {
            return "dk_driverdata_synthesis_energy_consumption".dkDriverDataLocalized()
        }
    }

    var conditionValue: String {
        if let dayValue = trip.tripStatistics?.day {
            return dayValue ? "dk_driverdata_day".dkDriverDataLocalized() : "dk_driverdata_night".dkDriverDataLocalized()
        } else {
            return unknown
        }
    }
    
    var meanSpeedValue: String {
        if let value = trip.tripStatistics?.speedMean {
            return value.formatSpeedMean()
        } else {
            return unknown
        }
    }
    
    var stopTimeValue: String {
        if let value = trip.tripStatistics?.idlingDuration {
            return value.formatSecondDuration()
        } else {
            return unknown
        }
    }
    
    var co2EmissionValue: String {
        if let value = trip.fuelEstimation?.co2Emission {
            return value.formatCO2Emission()
        } else {
            return unknown
        }
    }
    
    var weatherValue: String {
        if let weather = trip.tripStatistics?.weather {
            switch weather {
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
    
    var co2MassValue: String {
        if let value = trip.fuelEstimation?.co2Mass {
            return value.formatCO2Mass(shouldUseNaturalUnit: true)
        } else {
            return unknown
        }
    }
    
    var contextValue: String {
        if let contexts = trip.ecoDrivingContexts {
            var mainContext: DKEcoDrivingContext = contexts[0]
            
            for context in contexts where context.distance > mainContext.distance {
                mainContext = context
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
