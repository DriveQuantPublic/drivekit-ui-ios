//
//  DoubleExtention.swift
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
}
