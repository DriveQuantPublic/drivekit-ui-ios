// swiftlint:disable no_magic_numbers
//
//  SpeedingPageViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 08/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import Foundation

class SpeedingPageViewModel {
    let scoreType: DKScoreType = .speeding
    var trip: DKTrip

    init(trip: DKTrip) {
        self.trip = trip
    }

    func getScore() -> Double {
        return self.scoreType.rawValue(trip: trip)
    }

    func getScoreTitle() -> String {
        return self.scoreType.stringValue()
    }

    func getDistanceTitle() -> String {
        return "dk_driverdata_speeding_events_distance".dkDriverDataLocalized()
    }

    func getDistanceDescription() -> String {
        if let speedingDistance = trip.speedingStatistics?.speedingDistance, speedingDistance > 0 {
            let formattedDistance: String = formatDistance(Double(speedingDistance))
            return String(format: "dk_driverdata_speeding_events_trip_description".dkDriverDataLocalized(), formattedDistance)
        } else {
            return "dk_driverdata_no_speeding_events".dkDriverDataLocalized()
        }
    }

    func getDurationTitle() -> String {
        if shouldDisplayDuration() {
            return "dk_driverdata_speeding_events_duration".dkDriverDataLocalized()
        } else {
            return "dk_driverdata_no_speeding_title_congratulations".dkDriverDataLocalized()
        }
    }

    func getDurationDescription() -> String {
        if let speedingDuration = trip.speedingStatistics?.speedingDuration, speedingDuration > 0 {
            let formattedDuration: String = formatDuration(Double(speedingDuration))
            return String(format: "dk_driverdata_speeding_events_trip_description".dkDriverDataLocalized(), formattedDuration)
        } else {
            return "dk_driverdata_no_speeding_content_congratulations".dkDriverDataLocalized()
        }
    }

    func shouldDisplayDuration() -> Bool {
        if let speedingDuration = trip.speedingStatistics?.speedingDuration, speedingDuration > 0 {
            return true
        }
        return false
    }

    func getDurationPercentage() -> String {
        if let speedingDuration = trip.speedingStatistics?.speedingDuration,
           let fullDuration = trip.speedingStatistics?.duration,
           speedingDuration > 0,
           fullDuration > speedingDuration {
            var percentage: Double = Double(speedingDuration) / Double(fullDuration) * 100
            if percentage > 0.5 {
                percentage.round(.up)
            }
            let formattedPercentage = percentage.format(maximumFractionDigits: 2, minimumFractionDigits: 0)
            return "\(formattedPercentage)%"
        }
        return "0%"
    }

    func getDistancePercentage() -> String {
        if let speedingDistance = trip.speedingStatistics?.speedingDistance,
            let fullDistance = trip.speedingStatistics?.distance,
            speedingDistance > 0,
            fullDistance > speedingDistance {
            var percentage: Double = Double(speedingDistance) / Double(fullDistance) * 100
            if percentage > 0.5 {
                percentage.round(.up)
            }
            let formattedPercentage = percentage.format(maximumFractionDigits: 2, minimumFractionDigits: 0)
            return "\(formattedPercentage)%"
        }
        return "0%"
    }

    private func formatDuration(_ duration: Double) -> String {
        return duration.ceilSecondDuration(ifGreaterThan: 600).formatSecondDuration()
    }

    private func formatDistance(_ distance: Double) -> String {
        return distance.ceilMeterDistance(ifGreaterThan: 10_000).formatMeterDistance()
    }
}
