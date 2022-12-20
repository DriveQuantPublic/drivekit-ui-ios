//
//  TimelineViewController.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class TimelineViewController: DKUIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scoreSelectorView: UIStackView!
    @IBOutlet private weak var periodSelectorContainer: UIView!
    @IBOutlet private weak var dateSelectorContainer: UIView!
    @IBOutlet private weak var roadContextContainer: UIView!
    @IBOutlet private weak var timelineGraphViewContainer: UIView!
    @IBOutlet weak var showTimelineDetailButton: UIButton!
    private let viewModel: TimelineViewModel
    private var selectedScoreSelectionTypeView: ScoreSelectionTypeView? = nil

    init(viewModel: TimelineViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TimelineViewController.self), bundle: .driverDataTimelineUIBundle)
        viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "dk_timeline_title".dkDriverDataTimelineLocalized()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_ :)), for: .valueChanged)
        self.scrollView.refreshControl = refreshControl

        setupSelectors()
        setupDateSelector()
        setupGraphView()
        setupRoadContext()
        setupDetailButton()

        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe(_:)))
        leftSwipeGestureRecognizer.direction = .left
        self.view.addGestureRecognizer(leftSwipeGestureRecognizer)
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(_:)))
        rightSwipeGestureRecognizer.direction = .right
        self.view.addGestureRecognizer(rightSwipeGestureRecognizer)

        if self.viewModel.updating {
            showRefreshControl()
        } else {
            hideRefreshControl()
        }
    }

    @objc private func handleLeftSwipe(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        self.viewModel.showNextGraphData()
    }

    @objc private func handleRightSwipe(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        self.viewModel.showPreviousGraphData()
    }

    @IBAction private func openScoreDetailScreen() {
        
        let timelineDetailVC = TimelineDetailViewController(viewModel: viewModel.timelineDetailViewModel)
        self.navigationController?.pushViewController(timelineDetailVC, animated: true)
    }

    @objc private func refresh(_ sender: Any) {
        self.viewModel.updateTimeline()
    }

    private func showRefreshControl() {
        self.scrollView.refreshControl?.beginRefreshing()
    }

    private func hideRefreshControl() {
        self.scrollView.refreshControl?.endRefreshing()
    }

    @objc private func onScoreSelectionTypeViewSelected(sender: ScoreSelectionTypeView) {
        self.selectedScoreSelectionTypeView?.setSelected(false)
        self.selectedScoreSelectionTypeView = sender
        sender.setSelected(true)
        if let scoreType = sender.scoreType, self.viewModel.selectedScore != scoreType {
            self.viewModel.selectedScore = scoreType
        }
    }

    private func setupSelectors() {
        let scores = self.viewModel.scores
        if scores.count < 2 {
            self.scoreSelectorView.isHidden = true
        } else {
            let selectedScore = self.viewModel.selectedScore
            self.scoreSelectorView.isHidden = false
            self.scoreSelectorView.removeAllSubviews()
            for score in scores {
                if let selectorView = Bundle.driverDataTimelineUIBundle?.loadNibNamed("ScoreSelectionTypeView", owner: nil, options: nil)?.first as? ScoreSelectionTypeView {
                    selectorView.update(scoreType: score)
                    let selected = score == selectedScore
                    selectorView.setSelected(selected)
                    if selected {
                        self.selectedScoreSelectionTypeView = selectorView
                    }
                    selectorView.addTarget(self, action: #selector(onScoreSelectionTypeViewSelected(sender:)), for: .touchUpInside)
                    self.scoreSelectorView.addArrangedSubview(selectorView)
                }
            }
        }
        
        PeriodSelectorView.createPeriodSelectorView(
            configuredWith: viewModel.periodSelectorViewModel,
            embededIn: periodSelectorContainer
        )
    }

    private func setupGraphView() {
        TimelineGraphView.createTimelineGraphView(
            configuredWith: viewModel.timelineGraphViewModel,
            embededIn: timelineGraphViewContainer
        )
    }

    private func setupDateSelector() {
        DateSelectorView.createDateSelectorView(
            configuredWith: viewModel.dateSelectorViewModel,
            embededIn: dateSelectorContainer
        )
    }

    private func setupRoadContext() {
        RoadContextView.createRoadContextView(
            configuredWith: viewModel.roadContextViewModel,
            embededIn: roadContextContainer
        )
    }
    
    private func setupDetailButton() {
        showTimelineDetailButton.configure(text: viewModel.timelineDetailButtonTitle, style: .empty)
    }
}

extension TimelineViewController: TimelineViewModelDelegate {
    func willUpdateTimeline() {
        showRefreshControl()
    }

    func didUpdateTimeline() {
        hideRefreshControl()
    }
    
    func didUpdateSelection() {
        self.showTimelineDetailButton.isHidden = viewModel.shouldHideDetailButton
    }
}
