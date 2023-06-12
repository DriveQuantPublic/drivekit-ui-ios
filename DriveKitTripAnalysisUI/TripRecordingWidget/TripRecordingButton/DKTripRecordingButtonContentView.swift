//
//  DKTripRecordingButtonContentView.swift
//  DriveKitTripAnalysisUI
//
//  Created by Frédéric Ruaudel on 12/05/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class DKTripRecordingButtonContentView: UIView {
    let iconContainerCornerRadius: CGFloat = 5.0
    let iconContainerBorderWidth: CGFloat = 1.5
    let darkerBorderColorValue: Int = 0x5DB089
    @IBOutlet private weak var iconContainer: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var allLabelsContainer: UIStackView!
    @IBOutlet private var subTitleLabelsContainer: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var distanceSubtitleLabel: UILabel!
    @IBOutlet private weak var durationSubtitleLabel: UILabel!
    private var viewModel: DKTripRecordingButtonViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        iconContainer.layer.cornerRadius = iconContainerCornerRadius
        iconContainer.layer.borderWidth = iconContainerBorderWidth
        iconContainer.layer.borderColor = UIColor(
            hex: darkerBorderColorValue
        ).tinted(
            usingHueOf: DKUIColors.secondaryColor.color
        ).cgColor
        iconContainer.clipsToBounds = true
        iconContainer.backgroundColor = .white
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        self.updateUI()
    }
    
    func updateUI() {
        guard let viewModel else {
            return
        }
        
        titleLabel.attributedText = viewModel.title
        self.subTitleLabelsContainer.removeFromSuperview()
        if viewModel.hasSubtitles {
            self.allLabelsContainer.addArrangedSubview(subTitleLabelsContainer)
        }
        durationSubtitleLabel.attributedText = viewModel.durationSubtitle
        distanceSubtitleLabel.attributedText = viewModel.distanceSubtitle
        iconImageView.image = viewModel.iconImage
        iconImageView.tintColor = DKUIColors.secondaryColor.color
    }
    
    func configure(viewModel: DKTripRecordingButtonViewModel) {
        self.viewModel = viewModel
        self.updateUI()
    }

}
