//
//  TimelineViewController.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class TimelineViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scoreSelectorView: UIStackView!
    @IBOutlet private weak var periodSelectorContainer: UIView!
    @IBOutlet private weak var dateSelectorContainer: UIView!
    @IBOutlet private weak var roadContextContainer: UIView!
    @IBOutlet private weak var timelineGraphViewContainer: UIView!
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

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_ :)), for: .valueChanged)
        self.scrollView.refreshControl = refreshControl

        setupSelectors()
        setupGraphView()
        setupRoadContext()

        if self.viewModel.updating {
            showRefreshControl()
        } else {
            hideRefreshControl()
        }
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
            periodSelector.translatesAutoresizingMaskIntoConstraints = false
            self.periodSelectorContainer.addSubview(periodSelector)
            NSLayoutConstraint.activate([
                periodSelector.topAnchor.constraint(equalTo: self.periodSelectorContainer.topAnchor),
                periodSelector.bottomAnchor.constraint(equalTo: self.periodSelectorContainer.bottomAnchor),
                periodSelector.leftAnchor.constraint(equalTo: self.periodSelectorContainer.leftAnchor),
                periodSelector.rightAnchor.constraint(equalTo: self.periodSelectorContainer.rightAnchor)
            ])
            periodSelector.viewModel = self.viewModel.periodSelectorViewModel
        }
    }

    private func setupGraphView() {
        
    }

    private func setupRoadContext() {
        guard let roadContextview = Bundle.driverDataTimelineUIBundle?.loadNibNamed("RoadContextView", owner: nil, options: nil)?.first as? RoadContextView else {
            return
        }
        self.viewModel.roadContextViewModel.delegate = roadContextview
        roadContextview.configure(viewModel: self.viewModel.roadContextViewModel)
        self.roadContextContainer.embedSubview(roadContextview)
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
