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
    @IBOutlet weak var tripCountLabel: UILabel!
    @IBOutlet weak var tripCountUnitLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceUnitLabel: UILabel!
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
        
        tripCountLabel.attributedText = viewModel.tripCountText
        tripCountUnitLabel.attributedText = viewModel.tripCountUnitText
        distanceLabel.attributedText = viewModel.totalDistanceText
        distanceUnitLabel.attributedText = viewModel.totalDistanceUnitText
    }
    
    func configure(viewModel: DrivingConditionsSummaryCardViewModel) {
        self.viewModel = viewModel
        self.refreshView()
    }
}

extension DrivingConditionsSummaryCardView {
    public static func createSummaryCardView(
        configuredWith viewModel: DrivingConditionsSummaryCardViewModel,
        embededIn containerView: UIView
    ) {
        guard let summaryCardView = Bundle.driverDataUIBundle?.loadNibNamed(
            "DrivingConditionsSummaryCardView",
            owner: nil
        )?.first as? DrivingConditionsSummaryCardView else {
            preconditionFailure("Can't find bundle or nib for DrivingConditionsSummaryCardView")
        }
        
        viewModel.summaryCardViewModelDidUpdate = { [unowned summaryCardView] in
            summaryCardView.refreshView()
        }
        summaryCardView.configure(viewModel: viewModel)
        containerView.embedSubview(summaryCardView)
        containerView.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        containerView.clipsToBounds = true
    }
}
