//
//  DKDriverRanking.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 21/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import UIKit

public protocol DKDriverRanking: AnyObject {
    func getHeaderDisplayType() -> DKRankingHeaderDisplayType
    func getDriverRankingItems() -> [DKDriverRankingItem]
    func getTitle() -> String
    func getImage() -> UIImage?
    func getProgressionImage() -> UIImage?
    func getDriverGlobalRankAttributedText() -> NSAttributedString
    func getScoreTitle() -> String
}

public protocol DKDriverRankingItem {
    func getRank() -> Int
    func getRankImage() -> UIImage?
    func getPseudo() -> String
    func getDistance() -> String
    func getScoreAttributedText() -> NSAttributedString
    func isCurrentUser() -> Bool
    func isJumpRank() -> Bool
}

public enum DKRankingHeaderDisplayType {
    case compact, full
}
