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
    private var viewModel: DrivingConditionsSummaryCardViewModel!
    private var summaryCardDataView: DrivingConditionsSummaryCardDataView!
    private var emptySummaryCardView: NoDataDrivingConditionsSummaryCardView!
    
    override init(frame: CGRect) {
        guard let summaryCardDataView = Bundle.driverDataUIBundle?.loadNibNamed(
            "DrivingConditionsSummaryCardDataView",
            owner: nil,
            options: nil
        )?.first as? DrivingConditionsSummaryCardDataView else {
            preconditionFailure("Can't find bundle or nib for DrivingConditionsSummaryCardDataView")
        }
        self.summaryCardDataView = summaryCardDataView
        
        guard let emptySummaryCardView = Bundle.driverDataUIBundle?.loadNibNamed(
            "NoDataDrivingConditionsSummaryCardView",
            owner: nil,
            options: nil
        )?.first as? NoDataDrivingConditionsSummaryCardView else {
            preconditionFailure("Can't find bundle or nib for NoDataDrivingConditionsSummaryCardView")
        }
        self.emptySummaryCardView = emptySummaryCardView
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: DrivingConditionsSummaryCardViewModel) {
        self.viewModel = viewModel
        self.updateUI()
    }

    private func updateUI() {
        self.removeSubviews()
        if self.viewModel.hasNoData {
            emptySummaryCardView.configure(
                withTitle: viewModel.noDataTitleText,
                description: viewModel.noDataDescriptionText
            )
            self.embedSubview(emptySummaryCardView)
        } else {
            self.summaryCardDataView.configure(viewModel: self.viewModel)
            self.embedSubview(summaryCardDataView)
        }
    }
}

extension DrivingConditionsSummaryCardView {
    public static func createSummaryCardView(
        configuredWith viewModel: DrivingConditionsSummaryCardViewModel,
        embededIn containerView: UIView,
        withCardStyle hasCardStyle: Bool
    ) {
        let summaryCardView = DrivingConditionsSummaryCardView()
        
        viewModel.summaryCardViewModelDidUpdate = { [unowned summaryCardView] in
            summaryCardView.updateUI()
        }
        summaryCardView.configure(viewModel: viewModel)
        containerView.embedSubview(summaryCardView)

        if hasCardStyle {
            summaryCardView.roundCorners(clipping: true)
            containerView.applyCardStyle()
        }
    }
}
