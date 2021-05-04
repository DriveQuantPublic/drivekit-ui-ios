//
//  DKChallenge+UI.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 04/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import DriveKitDBChallengeAccessModule

extension Array where Element: DKChallenge {
    func pastChallenges() -> [DKChallenge] {
        let now = Date()
        return self.filter {
            $0.endDate <= now
        }
    }

    func currentChallenges() -> [DKChallenge] {
        let now = Date()
        return self.filter {
            return $0.endDate > now
        }
    }
}
