// swiftlint:disable all
//
//  RankingJumpCell.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 16/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class RankingJumpCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.image = DKImages.jump.image
        self.imageView.tintColor = DKUIColors.mainFontColor.color
    }
}
