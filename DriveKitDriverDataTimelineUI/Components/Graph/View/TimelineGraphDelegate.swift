//
//  TimelineGraphDelegate.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

protocol TimelineGraphDelegate: AnyObject {
    func graphDidSelectDate(_ date: Date)
}
