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
        
        let valuePrefix = "\("dk_driverdata_value".dkDriverDataLocalized() )".dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        
        switch event.type {
        case .acceleration, .brake:
            let attString = NSMutableAttributedString()
            attString.append(valuePrefix)
            attString.append(event.value.formatAcceleration().dkAttributedString().font(dkFont: .primary, style: .normalText).color(highColor).build())
            return attString
        case .adherence:
            let attString = NSMutableAttributedString()
            attString.append(valuePrefix)
            attString.append(event.value.formatDouble(places: 1).dkAttributedString().font(dkFont: .primary, style: .normalText).color(highColor).build())
            return attString
        case .unlock, .lock :
            return NSAttributedString(string: "")
        default:
            return location.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
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
