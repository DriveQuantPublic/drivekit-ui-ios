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
import DriveKitCoreModule
import DriveKitDBTripAccessModule

extension DKTrip: @retroactive DKTripListItem {
    public func getItinId() -> String {
        return self.itinId
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
    public func getDepartureAddress() -> String? {
        self.departureAddress
    }
    public func getArrivalCity() -> String? {
        return self.arrivalCity
    }
    public func getArrivalAddress() -> String? {
        self.arrivalAddress
    }

    public func isScored(tripData: TripData) -> Bool {
        let maxScore: Double = 10
        switch tripData {
        case .safety, .ecoDriving:
            return !self.unscored
        case .distraction:
            if !self.unscored, let score = self.driverDistraction?.score {
                return score <= maxScore
            }
            return false
        case .speeding:
            if !self.unscored, let score = self.speedingStatistics?.score {
                return score <= maxScore
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

    public func getTransportationModeImage() -> UIImage? {
        return self.declaredTransportationMode?.transportationMode.getImage() ?? self.transportationMode.getImage()
    }

    public func isAlternative() -> Bool {
        guard self.transportationMode != .unknown else {
            return true
        }
        return transportationMode.isAlternative()
    }

    public func infoText() -> String? {
        if let customTripInfo = DriveKitDriverDataUI.shared.customTripInfo {
            return customTripInfo.infoText(trip: self)
        } else {
            guard let tripAdvices: [DKTripAdvice] = self.tripAdvices else {
                return nil
            }
            if tripAdvices.count > 1 {
                return "\(tripAdvices.count)"
            } else {
                return nil
            }
        }
    }

    public func infoImage() -> UIImage? {
        if let customTripInfo = DriveKitDriverDataUI.shared.customTripInfo {
            return customTripInfo.infoImage(trip: self)
        } else {
            guard let tripAdvices: [DKTripAdvice] = self.tripAdvices else {
                return nil
            }
            if tripAdvices.count > 1 {
                return DKImages.tripInfoCount.image
            } else if tripAdvices.count == 1 {
                let advice = tripAdvices[0]
                return advice.adviceImage()
            } else {
                return nil
            }
        }
    }

    public func infoClickAction(parentViewController: UIViewController) {
        if let customTripInfo = DriveKitDriverDataUI.shared.customTripInfo {
            return customTripInfo.infoClickAction(parentViewController: parentViewController, trip: self)
        } else {
            let showAdvice = self.tripAdvices?.count ?? 0 > 0
            let itinId = self.itinId
                if let navigationController = parentViewController.navigationController {
                    let tripDetail = TripDetailVC(itinId: itinId, showAdvice: showAdvice, listConfiguration: .motorized())
                    navigationController.pushViewController(tripDetail, animated: true)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DKShowTripDetail"), object: nil, userInfo: ["itinId": itinId])
                }
        }
    }

    public func hasInfoActionConfigured() -> Bool {
        if let customTripInfo = DriveKitDriverDataUI.shared.customTripInfo {
            return customTripInfo.hasInfoActionConfigured(trip: self)
        } else {
            return true
        }
    }

    public func isInfoDisplayable() -> Bool {
        if let customTripInfo = DriveKitDriverDataUI.shared.customTripInfo {
            return customTripInfo.isInfoDisplayable(trip: self)
        } else {
            guard let tripAdvices: [DKTripAdvice] = self.tripAdvices else {
                return false
            }
            return !tripAdvices.isEmpty
        }
    }
}
