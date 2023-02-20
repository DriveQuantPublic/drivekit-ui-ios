//
//  Array+Date.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 20/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation

extension Array where Element == Date {
    public func selectedIndex(for selectedDate: Date?) -> Int? {
        let selectedDateIndex: Int?
        if let date = selectedDate {
            selectedDateIndex = self.firstIndex(of: date)
        } else if !self.isEmpty {
            selectedDateIndex = self.count - 1
        } else {
            selectedDateIndex = nil
        }
        return selectedDateIndex
    }
}
