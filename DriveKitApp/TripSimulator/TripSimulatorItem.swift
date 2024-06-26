// swiftlint:disable cyclomatic_complexity
//
//  TripSimulatorItem.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 20/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitTripSimulatorModule

enum TripSimulatorItem {
    case trip(PresetTrip)
    case crashTrip(PresetCrashConfiguration)

    func getTitle() -> String {
        switch self {
            case .trip(let presetTrip):
                switch presetTrip {
                    case .shortTrip:
                        return "trip_simulator_short_trip_title".keyLocalized()
                    case .mixedTrip:
                        return "trip_simulator_city_suburban_title".keyLocalized()
                    case .cityTrip:
                        return "trip_simulator_city_title".keyLocalized()
                    case .suburbanTrip:
                        return "trip_simulator_suburban_title".keyLocalized()
                    case .highwayTrip:
                        return "trip_simulator_highway_title".keyLocalized()
                    case .trainTrip:
                        return "trip_simulator_train_title".keyLocalized()
                    case .busTrip:
                        return "trip_simulator_bus_title".keyLocalized()
                    case .boatTrip:
                        return "trip_simulator_boat_title".keyLocalized()
                    case .tripWithCrash,
                         .tripWithCrashStillDriving:
                        return ""
                    @unknown default:
                        return ""
                }
            case .crashTrip(let presetCrashConfiguration):
                switch presetCrashConfiguration {
                    case .unconfirmed0KmH:
                        return "trip_simulator_crash_0_title".keyLocalized()
                    case .confirmed10KmH:
                        return "trip_simulator_crash_10_title".keyLocalized()
                    case .confirmed20KmH:
                        return "trip_simulator_crash_20_title".keyLocalized()
                    case .confirmed30KmH:
                        return "trip_simulator_crash_30_title".keyLocalized()
                    case .confirmed30KmHStillDriving:
                        return "trip_simulator_crash_followed_by_driving_title".keyLocalized()
                    @unknown default:
                        return ""
                }
        }
    }

    func getDescription() -> String {
        switch self {
            case .trip(let presetTrip):
                switch presetTrip {
                    case .shortTrip:
                        return "trip_simulator_short_trip_description".keyLocalized()
                    case .mixedTrip:
                        return "trip_simulator_city_suburban_description".keyLocalized()
                    case .cityTrip:
                        return "trip_simulator_city_description".keyLocalized()
                    case .suburbanTrip:
                        return "trip_simulator_suburban_description".keyLocalized()
                    case .highwayTrip:
                        return "trip_simulator_highway_description".keyLocalized()
                    case .trainTrip:
                        return "trip_simulator_train_description".keyLocalized()
                    case .busTrip:
                        return "trip_simulator_bus_description".keyLocalized()
                    case .boatTrip:
                        return "trip_simulator_boat_description".keyLocalized()
                    case .tripWithCrash,
                         .tripWithCrashStillDriving:
                        return ""
                    @unknown default:
                        return ""
                }
            case .crashTrip(let presetCrashConfiguration):
                switch presetCrashConfiguration {
                    case .unconfirmed0KmH:
                        return "trip_simulator_crash_0_description".keyLocalized()
                    case .confirmed10KmH:
                        return "trip_simulator_crash_10_description".keyLocalized()
                    case .confirmed20KmH:
                        return "trip_simulator_crash_20_description".keyLocalized()
                    case .confirmed30KmH:
                        return "trip_simulator_crash_30_description".keyLocalized()
                    case .confirmed30KmHStillDriving:
                        return "trip_simulator_crash_followed_by_driving_description".keyLocalized()
                    @unknown default:
                        return ""
                }
        }
    }

    func getSimulationDuration() -> Double {
        switch self {
        case .trip(let presetTrip):
            return presetTrip.getSimulationDuration()
        case .crashTrip(let presetCrashConfiguration):
            return presetCrashConfiguration.getPresetTrip().getSimulationDuration()
        }
    }
}
