//
//  ChallengeStatCell.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 03/06/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ChallengeStatCell: UITableViewCell, Nibable {
    @IBOutlet weak var statImage: UIImageView?
    @IBOutlet weak var driverStatLabel: UILabel?
    @IBOutlet weak var globalStatLabel: UILabel?
    @IBOutlet weak var containerView: CardView?

    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        layer.cornerRadius = 5
        self.backgroundColor = DKUIColors.backgroundView.color
    }
    
    func configure(viewModel: ChallengeResultsViewModel, type: ChallengeStatType){
        self.statImage?.image = type.image?.withRenderingMode(.alwaysTemplate)
        self.statImage?.tintColor = UIColor.black
        self.driverStatLabel?.attributedText = viewModel.getStatAttributedString(challengeStatType: type)
        self.globalStatLabel?.attributedText = viewModel.getGlobalStatAttributedString(challengeStatType: type)
    }
    
}
