// swiftlint:disable all
//
//  TimelineViewModelDelegate.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 17/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

protocol TimelineViewModelDelegate: AnyObject {
    func willUpdateTimeline()
    func didUpdateTimeline()
    func didUpdateDetailButtonDisplay()
}
