//
//  RoadContextView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Frédéric Ruaudel on 15/12/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

class RoadContextView: UIView {
    private var viewModel: RoadContextViewModel!
    private var roadContextDataView: RoadContextDataView!
    private var emptyRoadContextView: EmptyRoadContextView!
    
    override init(frame: CGRect) {
        guard let roadContextDataView = Bundle.driverDataTimelineUIBundle?.loadNibNamed(
            "RoadContextDataView",
            owner: nil,
            options: nil
        )?.first as? RoadContextDataView else {
            preconditionFailure("Can't find bundle or nib for RoadContextDataView")
        }
        self.roadContextDataView = roadContextDataView
        
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
                description: viewModel.emptyDataDescription
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
