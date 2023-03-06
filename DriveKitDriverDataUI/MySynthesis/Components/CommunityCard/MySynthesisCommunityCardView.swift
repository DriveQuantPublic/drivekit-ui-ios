//
//  MySynthesisCommunityCardView.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 06/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class MySynthesisCommunityCardView: UIView {
    private var viewModel: MySynthesisCommunityCardViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        
        self.refreshView()
    }
    
    func refreshView() {
        guard let viewModel else {
            return
        }
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
