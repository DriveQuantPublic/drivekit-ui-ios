//
//  LeaderboardViewModel.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 06/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

import DriveKitDBAchievementAccess

class LeaderboardViewModel {

    var selectedRankingType: DKRankingType? = nil
    var selectedRankingPeriod: DKRankingPeriod? = nil
    private(set) var rankingTypes: [DKRankingType] = []
    private(set) var rankingSelector: DKRankingSelectorType = .none

}
