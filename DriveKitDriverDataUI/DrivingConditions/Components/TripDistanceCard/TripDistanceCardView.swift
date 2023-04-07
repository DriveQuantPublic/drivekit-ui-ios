//
//  TripDistanceCardView.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 07/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class TripDistanceCardView: UIView {
    private var viewModel: TripDistanceCardViewModel?
    
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
    
    func configure(viewModel: TripDistanceCardViewModel) {
        self.viewModel = viewModel
        self.refreshView()
    }
}

extension TripDistanceCardView {
    public static func createTripDistanceCardView(
        configuredWith viewModel: TripDistanceCardViewModel,
        embededIn containerView: UIView
    ) {
        guard let tripDistanceCardView = Bundle.driverDataUIBundle?.loadNibNamed(
            "TripDistanceCardView",
            owner: nil
        )?.first as? TripDistanceCardView else {
            preconditionFailure("Can't find bundle or nib for TripDistanceCardView")
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
