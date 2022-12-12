//
//  TimelineScoreDetailViewController.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 08/11/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class TimelineDetailViewController: DKUIViewController {
    private let viewModel: TimelineDetailViewModel

    init(viewModel: TimelineDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TimelineDetailViewController.self), bundle: .driverDataTimelineUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
