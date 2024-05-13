//
//  ChallengeDriverRank.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 31/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitCommonUI

class ChallengeDriverRank: DKDriverRankingItem {
    let position: Int
    let positionImageName: String?
    let name: String
    let distanceString: String
    let scoreString: String
    let totalScoreString: String
    
    init(position: Int, positionImageName: String?, name: String, distanceString: String, scoreString: String, totalScoreString: String) {
        self.position = position
        self.positionImageName = positionImageName
        self.distanceString = distanceString
        self.scoreString = scoreString
        self.totalScoreString = totalScoreString
        self.name = name
    }

    func getRank() -> Int {
        return position
    }

    func getRankImage() -> UIImage? {
        if let positionImageName = positionImageName,
           let positionImage = DKImages(rawValue: positionImageName) {
            return positionImage.image
        } else {
            return nil
        }
    }

    func getPseudo() -> String {
        return name
    }

    func getDistance() -> String {
        return distanceString
    }

    func getScoreAttributedText() -> NSAttributedString {
        let scoreLabelColor: DKUIColors
        if isCurrentUser() {
            scoreLabelColor = .fontColorOnSecondaryColor
        } else {
            scoreLabelColor = .mainFontColor
        }
        let userScoreString = scoreString.dkAttributedString().font(dkFont: .primary, style: .bigtext).color(scoreLabelColor).build()
        let numberOfUsersString = totalScoreString.dkAttributedString().font(dkFont: .primary, style: .smallText).color(scoreLabelColor).build()
        return "%@%@".dkAttributedString().buildWithArgs(userScoreString, numberOfUsersString)
    }

    func isCurrentUser() -> Bool {
        return false
    }

    func isJumpRank() -> Bool {
        return false
    }
}

class CurrentChallengeDriverRank: ChallengeDriverRank {
    override func isCurrentUser() -> Bool {
        return true
    }
}
