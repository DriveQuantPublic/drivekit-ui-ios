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
    private let viewModel: TimelineViewModel
    private var selectedScoreSelectionTypeView: ScoreSelectionTypeView? = nil
    private let roadContextView = RoadContextView()
//    private let emptyRoadContextView = Bundle.driverDataTimelineUIBundle?.loadNibNamed("EmptyRoadContextView", owner: nil, options: nil)?.first as? EmptyRoadContextView
    private let cornerRadius: CGFloat = 8

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
        let timelineDetailViewModel = TimelineDetailViewModel()
        let timelineDetailVC = TimelineDetailViewController(viewModel: timelineDetailViewModel)
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

        let periodSelector = Bundle.driverDataTimelineUIBundle?.loadNibNamed("PeriodSelectorView", owner: nil, options: nil)?.first as? PeriodSelectorView
        if let periodSelector {
            self.periodSelectorContainer.embedSubview(periodSelector)
            periodSelector.viewModel = self.viewModel.periodSelectorViewModel
        }
    }

    private func setupGraphView() {
        self.timelineGraphViewContainer.layer.cornerRadius = self.cornerRadius
        self.timelineGraphViewContainer.clipsToBounds = true
        let timelineGraphView = Bundle.driverDataTimelineUIBundle?.loadNibNamed("TimelineGraphView", owner: nil, options: nil)?.first as? TimelineGraphView
        if let timelineGraphView {
            self.timelineGraphViewContainer.embedSubview(timelineGraphView)
            timelineGraphView.viewModel = self.viewModel.timelineGraphViewModel
            timelineGraphView.delegate = self.viewModel.timelineGraphViewModel
        }
    }

    private func setupDateSelector() {
        guard let dateSelectorView = Bundle.driverDataTimelineUIBundle?.loadNibNamed("DateSelectorView", owner: nil, options: nil)?.first as? DateSelectorView else {
            return
        }
        dateSelectorView.configure(viewModel: self.viewModel.dateSelectorViewModel)
        self.viewModel.dateSelectorViewModel.delegate = self.viewModel
        self.dateSelectorContainer.embedSubview(dateSelectorView)
        self.dateSelectorContainer.layer.cornerRadius = self.cornerRadius
        self.dateSelectorContainer.clipsToBounds = true
    }

    private func setupRoadContext() {
        self.roadContextContainer.layer.cornerRadius = self.cornerRadius
        self.roadContextContainer.clipsToBounds = true
        self.viewModel.roadContextViewModel.delegate = roadContextView
        roadContextView.configure(viewModel: self.viewModel.roadContextViewModel)
        self.roadContextContainer.embedSubview(roadContextView)
    }
}

extension TimelineViewController: TimelineViewModelDelegate {
    func willUpdateTimeline() {
        showRefreshControl()
    }

    func didUpdateTimeline() {
        hideRefreshControl()
    }
}
