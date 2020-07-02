//
//  RankingCell.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 01/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class RankingCell : UICollectionReusableView {
    @IBOutlet private weak var rankImage: UIImageView!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var rankUserBackground: UIView!
    @IBOutlet private weak var driverLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    private(set) var isUserRank = false
}
