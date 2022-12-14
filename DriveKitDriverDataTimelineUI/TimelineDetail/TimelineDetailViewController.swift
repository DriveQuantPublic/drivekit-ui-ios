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
        if let periodSelector = Bundle.driverDataTimelineUIBundle?.loadNibNamed(
            "PeriodSelectorView",
            owner: nil,
            options: nil
        )?.first as? PeriodSelectorView {
            self.periodSelectorContainerView.embedSubview(periodSelector)
            periodSelector.viewModel = viewModel.periodSelectorViewModel
        }
    }
    
    private func setupDateSelector() {
        guard let dateSelectorView = Bundle.driverDataTimelineUIBundle?.loadNibNamed(
            "DateSelectorView",
            owner: nil
        )?.first as? DateSelectorView else {
            return
        }
        
        dateSelectorView.configure(viewModel: viewModel.dateSelectorViewModel)
        dateSelectorContainerView.embedSubview(dateSelectorView)
        dateSelectorContainerView.layer.cornerRadius = TimelineConstants.UIStyle.cornerRadius
        dateSelectorContainerView.clipsToBounds = true
    }
    
    private func setupRoadContext() {
        
    }
    
    private func setupScoreItemGraphViews() {
        
    }
}
