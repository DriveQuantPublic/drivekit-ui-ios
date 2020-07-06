//
//  LeaderboardScoreView.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 06/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI
import DriveKitDBAchievementAccess

class LeaderboardScoreView : UIView {

    @IBOutlet weak var userRankView: UILabel!
    @IBOutlet weak var progressionView: UIImageView!

    private(set) var userPosition: Int = 0
    private(set) var nbRankedDrivers: Int = 0
    private(set) var driverProgression: DriverProgression = .steady
    private(set) var rankingType: DKRankingType? = nil

    func update(userPosition: Int, nbRankedDrivers: Int, driverProgression: DriverProgression, rankingType: DKRankingType) {
        self.userPosition = userPosition
        self.nbRankedDrivers = nbRankedDrivers
        self.driverProgression = driverProgression
        self.rankingType = rankingType

        let userRankString = String(userPosition).dkAttributedString().font(dkFont: .primary, style: .highlightBig).color(.secondaryColor).build()
        let numberOfUsersString = " / \(nbRankedDrivers)".dkAttributedString().font(dkFont: .primary, style: .highlightBig).color(.mainFontColor).build()
        self.userRankView.attributedText = "%@%@".dkAttributedString().buildWithArgs(userRankString, numberOfUsersString)

        switch driverProgression {
            case .goingDown:
                self.progressionView.image = UIImage(named: "TODO", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
            case .goingUp:
                self.progressionView.image = UIImage(named: "TODO", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
            case .steady:
                self.progressionView.image = UIImage(named: "TODO", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
        }
    }

}
