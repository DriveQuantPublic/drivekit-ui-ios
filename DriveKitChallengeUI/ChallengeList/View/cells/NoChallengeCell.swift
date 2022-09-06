//
//  NoChallengeCell.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 03/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class NoChallengeCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        label.font = DKUIFonts.primary.fonts(size: 16).with(.traitBold)
        imageView.image = DKImages.emptyData.image
    }

    func configure(viewModel: NoChallengeViewModel) {
        label.text = viewModel.text
        imageView.image = viewModel.image
        contentView.backgroundColor = viewModel.backgroundColor
        backgroundColor = viewModel.backgroundColor
        label.textColor = viewModel.textColor
    }
}
