//
//  MapItem.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccess

public enum MapItem {
    case ecoDriving, safety, distraction, interactiveMap, synthesis
    
    func normalImageID() -> String {
        switch self {
        case .safety:
            return "dk_safety"
        case .ecoDriving:
            return "dk_ecoDriving"
        case .interactiveMap:
            return "dk_history"
        case .distraction:
            return "dk_distraction"
        case .synthesis:
            return "dk_synthesis"
        }
    }
    
    func selectedImageID() -> String {
        switch self {
        case .safety:
            return "dk_safety_filled"
        case .ecoDriving:
            return "dk_ecoDriving_filled"
        case .interactiveMap:
            return "dk_history_filled"
        case .distraction:
            return "dk_distraction_filled"
        case .synthesis:
            return "dk_synthesis_filled"
        }
    }
    
    func adviceImageID() -> String {
        switch self {
        case .ecoDriving:
            return "dk_eco_advice"
        case .safety:
            return "dk_safety_advice"
        default:
            return ""
        }
    }
    
    var tag: Int {
        switch self {
        case .safety:
            return 0
        case .ecoDriving:
            return 1
        case .interactiveMap:
            return 2
        case .distraction:
            return 3
        case .synthesis:
            return 4
        }
    }
    
    func getAdvice(trip: Trip) -> TripAdvice? {
        if let advices = trip.tripAdvices?.allObjects as! [TripAdvice]? {
            if advices.count > 0 {
                switch self {
                case .safety:
                    return advices.filter({$0.theme == "SAFETY"}).first
                case .ecoDriving:
                    return advices.filter({$0.theme == "ECODRIVING"}).first
                case .interactiveMap:
                    return nil
                case .distraction:
                    return nil
                case .synthesis:
                    return nil
                }
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
}
