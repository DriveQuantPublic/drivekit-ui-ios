//
//  DKRankingSelectorType.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 30/06/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

import DriveKitDBAchievementAccess

public enum DKRankingSelectorType {
    case none
    case period(rankingPeriods: [DKRankingPeriod])
}
