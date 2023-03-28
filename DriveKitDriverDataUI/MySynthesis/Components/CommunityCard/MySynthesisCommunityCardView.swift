//
//  MySynthesisCommunityCardView.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 06/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class MySynthesisCommunityCardView: UIStackView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var communityGaugeContainerView: UIView!
    @IBOutlet weak var communityStatsStackView: UIStackView!
    @IBOutlet weak var userCommunityStatsItemView: CommunityStatsItemView?
    @IBOutlet weak var userStatsItemView: CommunityStatsItemView?
    @IBOutlet weak var gaugeView: MySynthesisGaugeView?
    private var viewModel: MySynthesisCommunityCardViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        titleLabel.font = DKStyles.headLine2.style.applyTo(font: .primary)
        userCommunityStatsItemView = .createCommunityStatsItemView(embededIn: communityStatsStackView)
        userStatsItemView = .createCommunityStatsItemView(embededIn: communityStatsStackView)
        gaugeView = .createSynthesisGaugeView(embededIn: communityGaugeContainerView)
        self.refreshView()
    }
    
    func refreshView() {
        guard let viewModel else {
            return
        }
        
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.titleColor.color
        userCommunityStatsItemView?.configure(viewModel: viewModel.userCommunityStatsItemViewModel)
        userStatsItemView?.configure(viewModel: viewModel.userStatsItemViewModel)
        gaugeView?.configure(viewModel: viewModel.synthesisGaugeViewModel)
    }
    
    func configure(viewModel: MySynthesisCommunityCardViewModel) {
        self.viewModel = viewModel
        self.refreshView()
    }
}

extension MySynthesisCommunityCardView {
    public static func createCommunityCardView(
        configuredWith viewModel: MySynthesisCommunityCardViewModel,
        embededIn containerView: UIView
    ) {
        guard let communityCardView = Bundle.driverDataUIBundle?.loadNibNamed(
            "MySynthesisCommunityCardView",
            owner: nil
        )?.first as? MySynthesisCommunityCardView else {
            preconditionFailure("Can't find bundle or nib for MySynthesisCommunityCardView")
        }
        
        viewModel.communityCardViewModelDidUpdate = { [unowned communityCardView] in
            communityCardView.refreshView()
        }
        communityCardView.configure(viewModel: viewModel)
        containerView.embedSubview(communityCardView)
        containerView.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        containerView.clipsToBounds = true
    }
}
