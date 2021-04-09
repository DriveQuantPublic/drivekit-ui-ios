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
}

extension Route {
        
    var startLocation: CLLocationCoordinate2D {
        return coordinate(at: 0)
    }
    
    var endLocation: CLLocationCoordinate2D {
        return coordinate(at: lastIndex)
    }
    
    var lastIndex: Int {
        return numberOfCoordinates - 1
    }
    
    var numberOfCoordinates: Int {
        return longitude?.count ?? 0
    }
    
    func coordinate(at index: Int) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude![index], longitude![index])
    }
}

extension TripAdvice {
    func adviceImage() -> UIImage?{
        if self.theme == "SAFETY" {
            return UIImage(named: "dk_safety_advice", in: Bundle.driverDataUIBundle, compatibleWith: nil)
        }else if self.theme == "ECODRIVING" {
            return UIImage(named: "dk_eco_advice", in: Bundle.driverDataUIBundle, compatibleWith: nil)
        }else{
            return nil
        }
    }
}

extension ScoreType {
    func isScored(trip: Trip) -> Bool {
        switch self {
        case .ecoDriving:
            return rawValue(trip: trip) <= 10 ? true : false
        case .safety:
            return rawValue(trip: trip) <= 10 ? true : false
        case .distraction:
            return rawValue(trip: trip) <= 10 ? true : false
        case .speeding:
            return rawValue(trip: trip) <= 10 ? true : false
        }
    }
    
    func rawValue(trip: Trip) -> Double {
        switch self {
        case .ecoDriving:
            return trip.ecoDriving?.score ?? 0
        case .safety:
            return  trip.safety?.safetyScore ?? 0
        case .distraction:
            return trip.driverDistraction?.score ?? 0
        case .speeding:
            return trip.speedingStatistics?.score ?? 0
        }
    }
}

extension DKStyle {
    static let driverDataText = DKStyles.normalText.withSizeDelta(-2)
}
