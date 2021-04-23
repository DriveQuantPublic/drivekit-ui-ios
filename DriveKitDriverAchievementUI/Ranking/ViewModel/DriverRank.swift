//
//  DriverRank.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 07/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import UIKit

protocol AnyDriverRank {
    var nbDrivers: Int { get }
    var position: Int { get }
    var positionString: String { get }
    var positionImageName: String? { get }
    var rankString: String { get }
    var name: String { get }
    var distance: Double { get }
    var distanceString: String { get }
    var score: Double { get }
    var scoreString: String { get }
    var totalScoreString: String { get }
}


class DriverRank: DKDriverRankingItem {
    let nbDrivers: Int
    let position: Int
    let positionString: String
    let positionImageName: String?
    let rankString: String
    let name: String
    let distance: Double
    let distanceString: String
    let score: Double
    let scoreString: String
    let totalScoreString: String
    
    init(nbDrivers: Int, position: Int, positionString: String,
         positionImageName: String?, rankString: String, name: String,
         distance: Double, distanceString: String, score: Double, scoreString: String,
         totalScoreString: String) {
        self.nbDrivers = nbDrivers
        self.position = position
        self.positionString = positionString
        self.positionImageName = positionImageName
        self.rankString = rankString
        self.distance = distance
        self.distanceString = distanceString
        self.score = score
        self.scoreString = scoreString
        self.totalScoreString = totalScoreString
        self.name = name
    }

    func getRank() -> Int {
        return position
    }

    func getRankImage() -> UIImage? {
        if let positionImageName = positionImageName {
            return UIImage(named: positionImageName)
        } else {
            return nil
        }
    }

    func getNickname() -> String {
        return name
    }

    func getDistance() -> String {
        return distanceString
    }

    func getScoreAttributedText() -> NSAttributedString {
        let scoreLabelColor: DKUIColors
        if isCurrnetUser() {
            scoreLabelColor = .fontColorOnSecondaryColor
        } else {
            scoreLabelColor = .mainFontColor
        }
        let userScoreString = scoreString.dkAttributedString().font(dkFont: .primary, style: .bigtext).color(scoreLabelColor).build()
        let numberOfUsersString = totalScoreString.dkAttributedString().font(dkFont: .primary, style: .smallText).color(scoreLabelColor).build()
        return "%@%@".dkAttributedString().buildWithArgs(userScoreString, numberOfUsersString)
    }

    func isCurrnetUser() -> Bool {
        return false
    }

    func isJumpRank() -> Bool {
        return false
    }
}

class CurrentDriverRank: DriverRank {
    override func isCurrnetUser() -> Bool {
        return true
    }
}

class JumpDriverRank: DKDriverRankingItem {
    func getRank() -> Int {
        return 0
    }

    func getRankImage() -> UIImage? {
        return nil
    }

    func getNickname() -> String {
        return ""
    }

    func getDistance() -> String {
        return ""
    }

    func getScoreAttributedText() -> NSAttributedString {
        return NSAttributedString()
    }

    func isCurrnetUser() -> Bool {
        return false
    }

    func isJumpRank() -> Bool {
        return true
    }
}
