// swiftlint:disable no_magic_numbers
//
//  DoubleExtension.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Frédéric Ruaudel on 20/12/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

extension Double {
    var ceiledToValueDivisibleBy100: Double {
        let intValue = Int(ceil(self))
        let nextValueDivisibleBy100 = ((intValue / 100) + (intValue % 100 == 0 ? 0 : 1)) * 100
        return Double(nextValueDivisibleBy100)
    }
    
    var ceiledToLowestValueWithNiceStep: Double {
        switch Int(ceil(self)) {
        case 0...10:
            return 10
        default:
            return self.ceiledToValueDivisibleBy100
        }
    }
}
