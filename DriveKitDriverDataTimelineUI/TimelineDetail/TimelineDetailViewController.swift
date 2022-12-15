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
    @IBOutlet weak var periodSelectorContainerView: UIView!
    @IBOutlet weak var dateSelectorContainerView: UIView!
    @IBOutlet weak var roadContextContainerView: UIView!
    @IBOutlet weak var scoreItemGraphStackView: UIStackView!
    private let viewModel: TimelineDetailViewModel

    init(viewModel: TimelineDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TimelineDetailViewController.self), bundle: .driverDataTimelineUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel.localizedTitle
        
        setupPeriodSelector()
        setupDateSelector()
        setupRoadContext()
        setupScoreItemGraphViews()
    }
    
    private func setupPeriodSelector() {
        PeriodSelectorView.createPeriodSelectorView(
            configuredWith: viewModel.periodSelectorViewModel,
            embededIn: periodSelectorContainerView
        )
    }
    
    private func setupDateSelector() {
        DateSelectorView.createDateSelectorView(
            configuredWith: viewModel.dateSelectorViewModel,
            embededIn: dateSelectorContainerView
        )
    }
    
    private func setupRoadContext() {
        
    }
    
    private func setupScoreItemGraphViews() {
        
    }
}
