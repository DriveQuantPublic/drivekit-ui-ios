// swiftlint:disable all
//
//  TimelineDetailViewModelDelegate.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Frédéric Ruaudel on 13/12/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

protocol TimelineDetailViewModelDelegate: AnyObject {
    func didUpdate(selectedDate: Date)
    func didUpdate(selectedPeriod: DKTimelinePeriod)
}
