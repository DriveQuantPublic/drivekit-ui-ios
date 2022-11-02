//
//  DateSelectorDelegate.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

@objc protocol DateSelectorDelegate: AnyObject {
    func dateSelectorDidSelectDate(_ date: Date)
    func dateSelectorUpdated()
}
