//
//  DrivingConditionsSummaryCardView.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 07/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class DrivingConditionsSummaryCardView: UIView {
    private var viewModel: DrivingConditionsSummaryCardViewModel?
    
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
    
    func configure(viewModel: DrivingConditionsSummaryCardViewModel) {
        self.viewModel = viewModel
        self.refreshView()
    }
}

extension DrivingConditionsSummaryCardView {
    public static func createTripDistanceCardView(
        configuredWith viewModel: DrivingConditionsSummaryCardViewModel,
        embededIn containerView: UIView
    ) {
        guard let tripDistanceCardView = Bundle.driverDataUIBundle?.loadNibNamed(
            "DrivingConditionsSummaryCardView",
            owner: nil
        )?.first as? DrivingConditionsSummaryCardView else {
            preconditionFailure("Can't find bundle or nib for DrivingConditionsSummaryCardView")
        }
        
        viewModel.tripDistanceCardViewModelDidUpdate = { [unowned tripDistanceCardView] in
            tripDistanceCardView.refreshView()
        }
        tripDistanceCardView.configure(viewModel: viewModel)
        containerView.embedSubview(tripDistanceCardView)
        containerView.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        containerView.clipsToBounds = true
    }
}
