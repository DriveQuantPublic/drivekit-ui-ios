//
//  RoadContextView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Frédéric Ruaudel on 15/12/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

class RoadContextView: UIView {
    private var viewModel: RoadContextViewModel?

    func configure(viewModel: RoadContextViewModel) {
        self.viewModel = viewModel
    }
}

extension RoadContextView: RoadContextViewModelDelegate {
    func roadContextViewModelDidUpdate() {
        #warning("TBD")
    }
}
