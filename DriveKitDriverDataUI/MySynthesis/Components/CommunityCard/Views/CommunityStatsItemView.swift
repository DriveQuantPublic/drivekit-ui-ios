//
//  CommunityStatsItemView.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 06/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class CommunityStatsItemView: UIStackView {
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var legendLabel: UILabel!
    @IBOutlet weak var tripCountLabel: UILabel!
    @IBOutlet weak var distanceCountLabel: UILabel!
    @IBOutlet weak var driverCountLabel: UILabel!
    
    private var viewModel: CommunityStatsItemViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        circleView.backgroundColor = .clear
        legendLabel.textColor = DKUIColors.mainFontColor.color
        legendLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.refreshView()
    }
    
    func refreshView() {
        guard let viewModel else {
            return
        }
        
        circleView.image = MySynthesisConstants.circleIcon(
            diameter: circleView.bounds.height,
            insideColor: viewModel.legendColor
        )
        legendLabel.text = viewModel.legendTitle
        tripCountLabel.attributedText = viewModel.tripCountText
        distanceCountLabel.attributedText = viewModel.distanceCountText
        driverCountLabel.attributedText = viewModel.driverCountText
    }
    
    func configure(viewModel: CommunityStatsItemViewModel) {
        self.viewModel = viewModel
        self.refreshView()
    }
}

extension CommunityStatsItemView {
    public static func createCommunityStatsItemView(
        embededIn stackView: UIStackView
    ) -> CommunityStatsItemView {
        guard let communityStatsItemView = Bundle.driverDataUIBundle?.loadNibNamed(
            "CommunityStatsItemView",
            owner: nil
        )?.first as? CommunityStatsItemView else {
            preconditionFailure("Can't find bundle or nib for CommunityStatsItemView")
        }
        
        stackView.addArrangedSubview(communityStatsItemView)
        return communityStatsItemView
    }
}
