// swiftlint:disable all
//
//  Extension + DK.swift
//  
//
//  Created by Meryl Barantal on 21/10/2019.
//

import UIKit
import DriveKitDriverDataModule
import DriveKitDBTripAccessModule
import CoreLocation
import DriveKitCommonUI

extension Trip {    
    var duration: Int {
        guard let duration = self.tripStatistics?.duration else {
            return 0
        }
        return Int(duration)
    }

    var roundedDuration: Double {
        (Double(self.duration) / 60.0).rounded(.up) * 60.0
    }
    
    var tripStartDate: Date {
        return self.startDate ?? self.tripEndDate.addingTimeInterval(-1 * Double(duration)) as Date
    }
    
    var tripEndDate: Date {
        return self.endDate ?? Date()
    }
    
    var declaredTransportationModeInt: Int32? {
        return self.declaredTransportationMode?.transportationMode
    }

    var sortedCalls: [Call]? {
        if let calls = self.calls as? Set<Call> {
            let sortedCalls = calls.sorted(by: { call1, call2 -> Bool in
                call1.start < call2.start
            })
            return sortedCalls
        }
        return nil
    }

    fileprivate static let activeDayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
}

extension Array where Element: Trip {
    var totalActiveDays: Int {
        let keys = reduce(into: Set<String>()) { keys, trip in
            keys.insert(Trip.activeDayDateFormatter.string(from: trip.tripEndDate))
        }
        return keys.count
    }
}

extension Route {
    var startLocation: CLLocationCoordinate2D? {
        return coordinate(at: 0)
    }
    
    var endLocation: CLLocationCoordinate2D? {
        return coordinate(at: lastIndex)
    }
    
    var lastIndex: Int {
        return numberOfCoordinates - 1
    }
    
    var numberOfCoordinates: Int {
        return longitude?.count ?? 0
    }
    
    func coordinate(at index: Int) -> CLLocationCoordinate2D? {
        guard
            let longitude,
            let latitude,
            longitude.indexRange.contains(index),
            latitude.indexRange.contains(index)
        else {
            DriveKitUI.shared.analytics?.logNonFatalError(
                "Route's longitude and/or latitude is nil or index \(index) out of bounds (Route: \(self))",
                parameters: [
                    DKAnalyticsEventKey.itinId.rawValue: itinId ?? "nil"
                ]
            )
            return nil
        }
        return CLLocationCoordinate2DMake(latitude[index], longitude[index])
    }
}

extension TripAdvice {
    func adviceImage() -> UIImage? {
        if self.theme == "SAFETY" {
            return DKImages.safetyAdvice.image
        } else if self.theme == "ECODRIVING" {
            return DKImages.ecoAdvice.image
        } else {
            return nil
        }
    }
}

public extension SafetyContext {
    var roadCondition: DKRoadCondition? {
        return DKRoadCondition(rawValue: Int(self.contextId))
    }
}

public extension EcoDrivingContext {
    var roadCondition: DKRoadCondition? {
        return DKRoadCondition(rawValue: Int(self.contextId))
    }
}

public enum DKRoadCondition: Int, CaseIterable {
    case trafficJam = 0
    case heavyUrbanTraffic = 1
    case city = 2
    case suburban = 3
    case expressways = 4
}
