//
//  Trip+DKTripsListItem.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 13/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

extension Trip: DKTripsListItem {
    public func getItinId() -> String {
        return self.itinId ?? ""
    }
    public func getDuration() -> Double {
        return Double(self.duration)
    }
    public func getDistance() -> Double? {
        return self.tripStatistics?.distance
    }
    public func getStartDate() -> Date? {
        return self.startDate
    }
    public func getEndDate() -> Date {
        return self.endDate ?? Date()
    }
    public func getDepartureCity() -> String? {
        return self.departureCity
    }
    public func getArrivalCity() -> String? {
        return self.arrivalCity
    }

    public func isScored(tripData: TripData) -> Bool {
        switch tripData {
        case .safety, .ecoDriving:
            return !self.unscored
        case .distraction:
            if !self.unscored, let score = self.driverDistraction?.score {
                return score <= 10
            }
            return false
        case .speeding:
            if !self.unscored, let score = self.speedingStatistics?.score {
                return score <= 10
            }
            return false
        case .distance, .duration:
            return true
        }
    }

    public func getScore(tripData: TripData) -> Double? {
        switch tripData {
        case .ecoDriving:
            return self.ecoDriving?.score ?? 0
        case .safety:
            return  self.safety?.safetyScore ?? 0
        case .distraction:
            return self.driverDistraction?.score ?? 0
        case .speeding:
            return self.speedingStatistics?.score ?? 0
        case .distance:
            return self.getDistance() ?? 0
        case .duration:
            return self.getDuration()
        }
    }

    public func getTransportationModeResource() -> UIImage? {
        return TransportationMode(rawValue: Int(self.declaredTransportationMode?.transportationMode ?? self.transportationMode))?.getImage()
    }

    public func isAlternative() -> Bool {
        return TransportationMode(rawValue: Int(self.transportationMode)) != TransportationMode.car
    }

    public func infoText() -> String? {
        guard let tripAdvices: Set<TripAdvice>  = self.tripAdvices as? Set<TripAdvice> else {
            return nil
        }
        if tripAdvices.count > 1 {
            return "\(tripAdvices.count)"
        } else {
            return nil
        }
    }

    public func infoImageResource() -> UIImage? {
        guard let tripAdvices: [TripAdvice]  = self.tripAdvices?.allObjects as? [TripAdvice] else {
            return nil
        }
        if tripAdvices.count > 1 {
            return UIImage(named: "dk_trip_info_count", in: Bundle.driverDataUIBundle, compatibleWith: nil)
        } else if tripAdvices.count == 1 {
            let advice = tripAdvices[0]
            return advice.adviceImage()
        } else {
            return nil
        }
    }

    public func infoClickAction(parentViewController: UIViewController) {
        let showAdvice = (self.tripAdvices as? Set<TripAdvice>)?.count ?? 0 > 0
        if let itinId = self.itinId {
            if let navigationController = parentViewController.navigationController {
                let tripDetail = TripDetailVC(itinId: itinId, showAdvice: showAdvice, listConfiguration: .motorized())
                navigationController.pushViewController(tripDetail, animated: true)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DKShowTripDetail"), object: nil, userInfo: ["itinId": itinId])
            }
        }
    }

    public func hasInfoActionConfigured() -> Bool {
        return true
    }

    public func isInfoDisplayable() -> Bool {
        guard let tripAdvices: Set<TripAdvice>  = self.tripAdvices as? Set<TripAdvice> else {
            return false
        }
        return tripAdvices.count > 0
    }
}
