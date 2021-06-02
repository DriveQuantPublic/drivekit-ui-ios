//
//  ChallengeResultsViewModel.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 28/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBChallengeAccessModule

struct ChallengeResultsViewModel {
    private let challengeDetail: DKChallengeDetail

    init(challengeDetail: DKChallengeDetail) {
        self.challengeDetail = challengeDetail
    }
}
