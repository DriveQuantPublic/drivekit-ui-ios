//
//  TimelineViewController.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class TimelineViewController: DKUIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scoreSelectorContainer: UIView!
    @IBOutlet private weak var periodSelectorContainer: UIView!
    @IBOutlet private weak var dateSelectorContainer: UIView!
    @IBOutlet private weak var roadContextContainer: UIView!
    @IBOutlet private weak var timelineGraphViewContainer: UIView!
    @IBOutlet weak var showTimelineDetailButton: UIButton!
    private let viewModel: TimelineViewModel

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
        setupGraphView()
        setupRoadContext()
        setupDetailButton()

        if self.viewModel.updating {
            showRefreshControl()
        } else {
            hideRefreshControl()
        }
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

    private func setupSelectors() {
        DKScoreSelectorView.createScoreSelectorView(
            configuredWith: viewModel.scoreSelectorViewModel,
            embededIn: scoreSelectorContainer
        )
        
        PeriodSelectorView.createPeriodSelectorView(
            configuredWith: viewModel.periodSelectorViewModel,
            embededIn: periodSelectorContainer
        )
        
        DKDateSelectorView.createDateSelectorView(
            configuredWith: viewModel.dateSelectorViewModel,
            embededIn: dateSelectorContainer
        )
    }

    private func setupGraphView() {
        TimelineGraphView.createTimelineGraphView(
            configuredWith: viewModel.timelineGraphViewModel,
            embededIn: timelineGraphViewContainer
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
        showTimelineDetailButton.isHidden = viewModel.shouldHideDetailButton
    }
}

extension TimelineViewController: TimelineViewModelDelegate {
    func willUpdateTimeline() {
        showRefreshControl()
    }

    func didUpdateTimeline() {
        hideRefreshControl()
    }
    
    func didUpdateDetailButtonDisplay() {
        self.showTimelineDetailButton.isHidden = viewModel.shouldHideDetailButton
    }
}
