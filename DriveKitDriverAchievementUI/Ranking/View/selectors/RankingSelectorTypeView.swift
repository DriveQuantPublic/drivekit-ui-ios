//
//  RankingSelectorTypeView.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 08/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class RankingSelectorTypeView: UIControl {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var selectionIndicator: UIView!
    private(set) var rankingType: RankingType?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionIndicator.backgroundColor = DKUIColors.secondaryColor.color
    }

    func update(rankingType: RankingType) {
        self.rankingType = rankingType
        self.imageView.image = rankingType.image
    }

    func setSelected(_ selected: Bool) {
        self.selectionIndicator.isHidden = !selected
    }

}
