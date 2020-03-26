//
//  MapItem.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccess
import DriveKitCommonUI

public enum MapItem {
    case ecoDriving, safety, distraction, interactiveMap, synthesis
    
    func normalImage() -> UIImage? {
        switch self {
        case .safety:
            return DKImages.safety.image
        case .ecoDriving:
            return DKImages.ecoDriving.image
        case .interactiveMap:
            return UIImage(named: "dk_history", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        case .distraction:
            return DKImages.distraction.image
        case .synthesis:
            return DKImages.info.image
        }
    }
    
    func selectedImage() -> UIImage? {
        switch self {
        case .safety:
            return DKImages.safetyFilled.image
        case .ecoDriving:
            return DKImages.ecoDrivingFilled.image
        case .interactiveMap:
            return UIImage(named: "dk_history_filled", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        case .distraction:
            return DKImages.distractionFilled.image
        case .synthesis:
            return DKImages.infoFilled.image
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
