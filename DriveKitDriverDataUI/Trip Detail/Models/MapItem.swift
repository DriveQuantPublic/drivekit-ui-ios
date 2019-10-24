//
//  MapItem.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

public enum MapItem {
    case ecoDriving, safety, distraction, history
    
    func normalImageID() -> String {
        switch self {
        case .safety:
            return "dk_safety"
        case .ecoDriving:
            return "dk_ecoDriving"
        case .history:
            return "dk_history"
        case .distraction:
            return "dk_distraction"
        }
    }
    
    func selectedImageID() -> String {
        switch self {
        case .safety:
            return "dk_safety_filled"
        case .ecoDriving:
            return "dk_ecoDriving_filled"
        case .history:
            return "dk_history_filled"
        case .distraction:
            return "dk_distraction_filled"
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
        case .history:
            return 2
        case .distraction:
            return 3
        }
    }
}
