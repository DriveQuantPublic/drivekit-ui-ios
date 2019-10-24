//
//  CalloutViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 17/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

struct TripEventCalloutViewModel {

    let event: TripEvent
    let location: String
    var detailConfig: TripDetailViewConfig

    init(event: TripEvent, location: String, detailConfig: TripDetailViewConfig) {
        self.event = event
        self.detailConfig = detailConfig
        self.location = location
    }

    var time: String {
        return event.date.dateToTime()
    }

    var title: String {
        return event.getTitle(detailConfig: detailConfig)
    }

    var subtitle: NSAttributedString {
        
        let attributes = [NSAttributedString.Key.foregroundColor: highColor]
        let valuePrefix = NSMutableAttributedString(string: "dk_value".dkLocalized(),
                                        attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        switch event.type {
        case .acceleration, .brake:
            let attString = NSMutableAttributedString()
            attString.append(valuePrefix)
            attString.append(NSAttributedString(string: " \(String(format: "%.2f", event.value)) \(detailConfig.accelUnitText)", attributes: attributes))
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
            return UIColor.dkCriticalEvent
        } else {
            return UIColor.dkHighEvent
        }
    }
}
