// swiftlint:disable all
//
//  DKScoreType.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 02/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule

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
        }
    }
}
