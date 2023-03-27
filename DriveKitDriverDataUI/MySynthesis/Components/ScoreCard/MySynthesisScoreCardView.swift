//
//  MySynthesisScoreCardView.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class MySynthesisScoreCardView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var evolutionDescriptionLabel: UILabel!
    @IBOutlet weak var scoreEvolutionTrendImageView: UIImageView!
    private var viewModel: MySynthesisScoreCardViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.titleLabel.font = DKStyles.headLine2.style.applyTo(font: .primary)
        self.titleLabel.textColor = DKUIColors.mainFontColor.color
        
        self.currentScoreLabel.font = DKStyles.highlightBig.style.applyTo(font: .secondary)
        self.currentScoreLabel.textColor = DKUIColors.primaryColor.color
        
        self.evolutionDescriptionLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.evolutionDescriptionLabel.textColor = DKUIColors.complementaryFontColor.color
        
        self.refreshView()
    }
    
    func refreshView() {
        guard let viewModel else {
            return
        }
        self.titleLabel.text = viewModel.cardTitle
        self.currentScoreLabel.text = viewModel.currentScoreText
        self.currentScoreLabel.textColor = viewModel.currentScoreTextColor.color
        self.evolutionDescriptionLabel.attributedText = viewModel.evolutionText
        self.scoreEvolutionTrendImageView.image = viewModel.currentTrendScoreImage
            .image?
            .tintedImage(
                withColor: viewModel.currentTrendScoreImageColor.color
            )
    }

    func configure(viewModel: MySynthesisScoreCardViewModel) {
        self.viewModel = viewModel
        self.refreshView()
    }
}

extension MySynthesisScoreCardView {
    public static func createScoreCardView(
        configuredWith viewModel: MySynthesisScoreCardViewModel,
        embededIn containerView: UIView
    ) {
        guard let scoreCardView = Bundle.driverDataUIBundle?.loadNibNamed(
            "MySynthesisScoreCardView",
            owner: nil
        )?.first as? MySynthesisScoreCardView else {
            preconditionFailure("Can't find bundle or nib for MySynthesisScoreCardViewModel")
        }
        
        viewModel.scoreCardViewModelDidUpdate = { [unowned scoreCardView] in
            scoreCardView.refreshView()
        }
        scoreCardView.configure(viewModel: viewModel)
        containerView.embedSubview(scoreCardView)
        containerView.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        containerView.clipsToBounds = true
    }
}
