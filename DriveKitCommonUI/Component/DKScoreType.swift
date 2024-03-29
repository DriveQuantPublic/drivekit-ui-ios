//
//  DKScoreType.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 02/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule

@available(*, deprecated, renamed: "DKScoreType")
public typealias ScoreType = DKScoreType

extension DKScoreType {
    @available(*, deprecated, renamed: "gaugeImage")
    public func image() -> UIImage? {
        return gaugeImage()
    }
    
    public func gaugeImage() -> UIImage? {
        switch self {
        case .ecoDriving:
            return DKImages.ecoDriving.image
        case .safety:
            return DKImages.safety.image
        case .distraction:
            return DKImages.distraction.image
        case .speeding:
            return DKImages.speeding.image
        @unknown default:
            return nil
        }
    }
    
    public func stringValue() -> String {
        switch self {
        case .ecoDriving:
            return DKCommonLocalizable.ecodriving.text()
        case .safety:
            return  DKCommonLocalizable.safety.text()
        case .distraction:
            return DKCommonLocalizable.distraction.text()
        case .speeding:
            return DKCommonLocalizable.speed.text()
        @unknown default:
            return ""
        }
    }

    public func isScored(trip: DKTripListItem) -> Bool {
        switch self {
        case .ecoDriving:
            return trip.isScored(tripData: .ecoDriving)
        case .safety:
            return trip.isScored(tripData: .safety)
        case .distraction:
            return trip.isScored(tripData: .distraction)
        case .speeding:
            return trip.isScored(tripData: .speeding)
        @unknown default:
            return false
        }
    }
        
    public func rawValue(trip: DKTripListItem) -> Double {
        switch self {
        case .ecoDriving:
            return trip.getScore(tripData: .ecoDriving) ?? 0
        case .safety:
            return trip.getScore(tripData: .safety) ?? 0
        case .distraction:
            return trip.getScore(tripData: .distraction) ?? 0
        case .speeding:
            return trip.getScore(tripData: .speeding) ?? 0
        @unknown default:
            return 0
        }
    }
}
