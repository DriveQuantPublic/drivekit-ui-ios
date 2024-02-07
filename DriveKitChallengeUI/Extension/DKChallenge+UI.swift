//
//  DKChallenge+UI.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 04/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import DriveKitDBChallengeAccessModule
import DriveKitCommonUI

extension Array where Element: DKChallenge {
    
    func filterDeprecated() -> [DKChallenge] {
        return self.filter { challenge in
            let type = challenge.challengeType
            switch type {
                case .safety, .ecoDriving, .distraction, .speeding, .hardBraking, .hardAcceleration:
                    return true
                case .deprecated, .unknown:
                    return false
                @unknown default:
                    return false
            }
        }
    }

    func sortByDate() -> [DKChallenge] {
        return self.sorted(by: { ($0.startDate, $1.id) > ($1.startDate, $0.id) })
    }

    func filterBy(year: Int) -> [DKChallenge] {
        guard let beginningOfYear = DriveKitUI.calendar.date(
            from: DateComponents(year: year, month: 1, day: 1)
        ),
              let endOfYear = beginningOfYear.endOfYear else {
            return []
        }
        return self.filter {
            $0.endDate <= endOfYear && $0.endDate >= beginningOfYear ||
            $0.startDate <= endOfYear && $0.startDate >= beginningOfYear
        }
    }

    func filterBy(tab: ChallengeListTab) -> [DKChallenge] {
        switch tab {
            case .active:
                let now = Date()
                return self.filter { $0.endDate > now }
            case .ranked:
                return self.filter { $0.conditionsFilled }
            case .all:
                return self
        }
    }
    
    func activeChallenges(year: Int) -> [DKChallenge] {
        return self.filterBy(tab: .active).filterBy(year: year).sortByDate()
    }
    
    func allChallenges(year: Int) -> [DKChallenge] {
        return self.filterBy(tab: .all).filterBy(year: year).sortByDate()
    }
    
    func rankedChallenges(year: Int) -> [DKChallenge] {
        return self.filterBy(tab: .ranked).filterBy(year: year).sortByDate()
    }
}
