//
//  CalloutViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 17/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

struct TripEventCalloutViewModel {

    let event: TripEvent
    let location: String

    init(event: TripEvent, location: String) {
        self.event = event
        self.location = location
    }

    var time: String {
        return event.date.format(pattern: .hourMinute)
    }

    var title: String {
        return event.getTitle()
    }

    var subtitle: NSAttributedString {
        
        let attributes = [NSAttributedString.Key.foregroundColor: highColor]
        let valuePrefix = NSMutableAttributedString(string: "dk_value".dkDriverDataLocalized(),
                                        attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        switch event.type {
        case .acceleration, .brake:
            let attString = NSMutableAttributedString()
            attString.append(valuePrefix)
            attString.append(NSAttributedString(string: " \(String(format: "%.2f", event.value)) \(DKCommonLocalizable.unitAcceleration.text())", attributes: attributes))
            return attString
        case .adherence:
            let attString = NSMutableAttributedString()
            attString.append(valuePrefix)
            attString.append(NSAttributedString(string: " \(String(format: "%.1f", event.value))",attributes: attributes))
            return attString
        case .unlock, .lock :
            return NSAttributedString(string: "")
        default:
            return NSAttributedString(string: location)
        }
    }
    
    var highColor: UIColor {
        if event.isHigh {
            return DKUIColors.criticalColor.color
        } else {
            return DKUIColors.warningColor.color
        }
    }
}
