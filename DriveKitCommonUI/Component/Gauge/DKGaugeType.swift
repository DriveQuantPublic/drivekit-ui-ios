//
//  DKGaugeType.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 28/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

public enum DKGaugeType {
    case open
    case openWithIcon(_ icon: UIImage)
    case close

    func getStartAngle() -> Float {
        switch self {
            case .close:
                return Float(0)
            case .open, .openWithIcon:
                return Float(45)
        }
    }

    func getEndAngle() -> Float {
        switch self {
            case .close:
                return Float(360)
            case .open, .openWithIcon:
                return Float(270)
        }
    }
}
