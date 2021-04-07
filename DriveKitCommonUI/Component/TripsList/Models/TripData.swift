//
//  TripData.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 07/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

public enum TripData: String {
    case ecoDriving, safety, distraction, distance, duration, speeding

    func displayType() -> DisplayType {
        switch self {
        case .ecoDriving, .safety, .distraction, .speeding:
            return .gauge
        case .duration, .distance:
            return .text
        }
    }
}

public enum DisplayType {
    case gauge, text
}
