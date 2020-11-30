//
//  AdviceTripInfo.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 27/11/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitDBTripAccessModule

class AdviceTripInfo: DKTripInfo {
    
    func isDisplayable(trip: Trip) -> Bool {
        guard let tripAdvices: [TripAdvice]  = trip.tripAdvices?.allObjects as? [TripAdvice] else {
            return false
        }
        return tripAdvices.count > 0
    }
    
    func image(trip: Trip) -> UIImage? {
        guard let tripAdvices: [TripAdvice]  = trip.tripAdvices?.allObjects as? [TripAdvice] else {
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
    
    func text(trip: Trip) -> String? {
        guard let tripAdvices: [TripAdvice]  = trip.tripAdvices?.allObjects as? [TripAdvice] else {
            return nil
        }
        if tripAdvices.count > 1 {
            return "\(tripAdvices.count)"
        } else {
            return nil
        }
    }
    
    func hasActionConfigured() -> Bool {
        return true
    }
    
    func clickAction(trip: Trip, parentViewController: UIViewController) {
        let showAdvice = (trip.tripAdvices?.allObjects as? [TripAdvice])?.count ?? 0 > 0
        if let itinId = trip.itinId {
            if let navigationController = parentViewController.navigationController {
                let tripDetail = TripDetailVC(itinId: itinId, showAdvice: showAdvice)
                navigationController.pushViewController(tripDetail, animated: true)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DKShowTripDetail"), object: nil, userInfo: ["itinId": itinId])
            }
        }
    }
}
