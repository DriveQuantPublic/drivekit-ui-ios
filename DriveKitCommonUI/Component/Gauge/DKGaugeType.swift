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
        return 0
    }

    func getOpenAngle() -> Float {
        return 0
    }
}
