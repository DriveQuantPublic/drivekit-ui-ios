// swiftlint:disable no_magic_numbers
//
//  DKContextCardColor.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 17/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

public enum DKContextCardColor {
    case level1, level2, level3, level4, level5, level6

    public func getColor() -> UIColor {
        switch self {
            case .level1:
                return UIColor(hex: 0x036A82)
            case .level2:
                return UIColor(hex: 0x3B8497)
            case .level3:
                return UIColor(hex: 0x699DAD)
            case .level4:
                return UIColor(hex: 0x8FB7C2)
            case .level5:
                return UIColor(hex: 0x9ACBDA)
            case .level6:
                return UIColor(hex: 0xD5E6EB)
        }
    }
}
