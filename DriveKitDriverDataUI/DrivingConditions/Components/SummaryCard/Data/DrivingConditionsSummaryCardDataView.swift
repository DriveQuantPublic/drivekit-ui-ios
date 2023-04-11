//
//  DrivingConditionsSummaryCardDataView.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 11/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

class DrivingConditionsSummaryCardDataView: UIView {
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
