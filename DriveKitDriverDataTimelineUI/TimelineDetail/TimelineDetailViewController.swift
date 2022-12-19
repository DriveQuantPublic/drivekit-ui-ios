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
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe(_:)))
        leftSwipeGestureRecognizer.direction = .left
        self.view.addGestureRecognizer(leftSwipeGestureRecognizer)
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(_:)))
        rightSwipeGestureRecognizer.direction = .right
        self.view.addGestureRecognizer(rightSwipeGestureRecognizer)
    }
    
    @objc private func handleLeftSwipe(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        self.viewModel.showNextGraphData()
    }

    @objc private func handleRightSwipe(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        self.viewModel.showPreviousGraphData()
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
        RoadContextView.createRoadContextView(
            configuredWith: viewModel.roadContextViewModel,
            embededIn: roadContextContainerView
        )
    }
    
    private func setupScoreItemGraphViews() {
        viewModel.orderedScoreItemTypeToDisplay.forEach { scoreItemType in
            guard let viewModel = viewModel.timelineGraphViewModelByScoreItem[scoreItemType] else {
                assertionFailure("We should have a viewModel for score item type \(scoreItemType)")
                return
            }
            
            TimelineGraphView.createTimelineGraphView(
                configuredWith: viewModel,
                embededIn: scoreItemGraphStackView
            )
        }
    }
}
