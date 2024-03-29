//
//  RoadContextView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Frédéric Ruaudel on 15/12/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class RoadContextView: UIView {
    private var viewModel: RoadContextViewModel!
    private var roadContextDataView: DKContextCardView!
    private var emptyRoadContextView: EmptyRoadContextView!
    
    override init(frame: CGRect) {
        self.roadContextDataView = DKContextCardView.createView()

        guard let emptyRoadContextView = Bundle.driverDataTimelineUIBundle?.loadNibNamed(
            "EmptyRoadContextView",
            owner: nil,
            options: nil
        )?.first as? EmptyRoadContextView else {
            preconditionFailure("Can't find bundle or nib for EmptyRoadContextView")
        }
        self.emptyRoadContextView = emptyRoadContextView

        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: RoadContextViewModel) {
        self.viewModel = viewModel
        self.updateUI()
    }
    
    private func updateUI() {
        self.removeSubviews()
        if self.viewModel.hasData {
            self.roadContextDataView.configure(viewModel: self.viewModel)
            self.embedSubview(roadContextDataView)
        } else {
            emptyRoadContextView.configure(
                withTitle: viewModel.title,
                description: viewModel.getEmptyDataDescription()
            )
            self.embedSubview(emptyRoadContextView)
        }
    }
}

extension RoadContextView: RoadContextViewModelDelegate {
    func roadContextViewModelDidUpdate() {
        self.updateUI()
    }
}

extension RoadContextView {
    static func createRoadContextView(
        configuredWith viewModel: RoadContextViewModel,
        embededIn containerView: UIView,
        withCardStyle hasCardStyle: Bool
    ) {
        let roadContextView = RoadContextView()
        if hasCardStyle {
            roadContextView.roundCorners(clipping: true)
            containerView.applyCardStyle()
        }
        viewModel.delegate = roadContextView
        roadContextView.configure(viewModel: viewModel)
        containerView.embedSubview(roadContextView)
    }
}
