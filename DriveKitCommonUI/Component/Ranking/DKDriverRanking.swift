//
//  DKDriverRanking.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 21/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import UIKit

public protocol DKDriverRanking {
    func getHeaderDisplayType() -> DKRankingHeaderDisplayType
    func getDriverRankingItems() -> [DKDriverRankingItem]
    func getTitle() -> String
    func getImage() -> UIImage
    func getProgressionImage() -> UIImage?
    func getDriverGlobalRankAttributedText() -> NSAttributedString
}

public protocol DKDriverRankingItem {
    func getRank() -> Int
    func getRankImage() -> UIImage?
    func getNickname() -> String
    func getDistance() -> String
    func getScoreAttributedText() -> NSAttributedString
    func isCurrnetUser() -> Bool
    func isJumpRank() -> Bool
}

public enum DKRankingHeaderDisplayType {
    case compact, full
}
