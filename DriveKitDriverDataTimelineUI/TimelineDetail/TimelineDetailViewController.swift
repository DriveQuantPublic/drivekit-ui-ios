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
        
        setupPeriodSelectors()
        setupDateSelector()
        setupRoadContext()
        setupScoreItemGraphViews()
    }
    
    private func setupPeriodSelectors() {
    }
    
    private func setupDateSelector() {
        
    }
    
    private func setupRoadContext() {
        
    }
    
    private func setupScoreItemGraphViews() {
        
    }
}
