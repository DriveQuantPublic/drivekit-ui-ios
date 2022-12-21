//
//  DoubleExtension.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Frédéric Ruaudel on 20/12/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

extension Double {
    var ceiledToValueDivisibleBy10: Double {
        let intValue = Int(ceil(self))
        let nextValueDivisibleBy10 = ((intValue / 10) + (intValue % 10 == 0 ? 0 : 1)) * 10
        return Double(nextValueDivisibleBy10)
    }
    
    var ceiledToLowestValueWithNiceStep: Double {
        switch Int(ceil(self)) {
        case 0...10:
            return 10
        case 11...100:
            return 100
        case 101...200:
            return 200
        case 201...500:
            return 500
        case 501...1000:
            return 1000
        default:
            return self.ceiledToValueDivisibleBy10
        }
    }
}
