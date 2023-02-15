//
//  DateSelectorDelegate.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

public protocol DateSelectorDelegate: AnyObject {
    func dateSelectorDidSelectDate(_ date: Date)
}
