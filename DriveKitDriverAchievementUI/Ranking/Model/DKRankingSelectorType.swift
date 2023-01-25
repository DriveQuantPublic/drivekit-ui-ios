// swiftlint:disable all
//
//  DKRankingSelectorType.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 30/06/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

import DriveKitDBAchievementAccessModule

public enum DKRankingSelectorType {
    case none
    case period(rankingPeriods: [DKRankingPeriod])
}
