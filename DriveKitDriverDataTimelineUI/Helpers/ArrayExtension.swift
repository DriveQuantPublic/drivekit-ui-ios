//
//  ArrayExtension.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Frédéric Ruaudel on 20/12/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

extension Array {
    /// Allow access subscripting that returns nil when index is out of bounds
    ///  exemple: `myArray[safe: index]`
    subscript(safe index: Index) -> Element? {
        guard index >= 0 && index < self.count else {
            return nil
        }
        return self[index]
    }
}
