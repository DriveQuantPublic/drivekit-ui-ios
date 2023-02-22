// swiftlint:disable all
//
//  TimelineGraphView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import ChartsForDK
import DriveKitCommonUI

class TimelineGraphView: UIView {
    @IBOutlet private weak var titleView: UILabel!
    @IBOutlet private weak var graphViewContainer: UIView!
    var viewModel: TimelineGraphViewModel? {
        didSet {
            updateGraphView()
        }
    }
    weak var delegate: GraphViewDelegate?
    private weak var graphView: GraphViewBase!

    override func awakeFromNib() {
        super.awakeFromNib()
        updateGraphView()
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe(_:)))
        leftSwipeGestureRecognizer.direction = .left
        self.addGestureRecognizer(leftSwipeGestureRecognizer)
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(_:)))
        rightSwipeGestureRecognizer.direction = .right
        self.addGestureRecognizer(rightSwipeGestureRecognizer)

    }
    
    @objc private func handleLeftSwipe(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        self.viewModel?.showNextGraphData()
    }

    @objc private func handleRightSwipe(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        self.viewModel?.showPreviousGraphData()
    }

    private func updateGraphView() {
        if let viewModel = self.viewModel {
            let graphView: GraphViewBase
            switch viewModel.type {
                case .line:
                    graphView = LineGraphView(viewModel: viewModel)
                case .bar:
                    graphView = BarGraphView(viewModel: viewModel)
            }
            graphViewContainer.embedSubview(graphView)
            graphView.delegate = self
            self.graphView = graphView

            viewModel.graphViewModelDidUpdate = { [weak self] in
                self?.updateContent()
            }

            updateContent()
        } else {
            graphViewContainer.removeSubviews()
            updateTitle()
        }
    }

    private func updateContent() {
        self.updateTitle()
        self.graphView.setupData()
    }

    private func updateTitle() {
        if let viewModel = self.viewModel {
            self.titleView.attributedText = viewModel.title.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).buildWithArgs(viewModel.description.dkAttributedString().font(dkFont: .primary, style: DKStyle(size: DKStyles.headLine2.style.size, traits: .traitBold)).color(.primaryColor).build())
        } else {
            self.titleView.attributedText = nil
        }
    }
}

extension TimelineGraphView: GraphViewDelegate {
    func graphDidSelectPoint(_ point: GraphPoint) {
        self.delegate?.graphDidSelectPoint(point)
    }
}

extension TimelineGraphView {
    static func createTimelineGraphView(
        configuredWith viewModel: TimelineGraphViewModel,
        embededIn containerView: UIView
    ) {
        guard let timelineGraphView = Bundle.driverDataTimelineUIBundle?.loadNibNamed(
            "TimelineGraphView",
            owner: nil,
            options: nil
        )?.first as? TimelineGraphView else {
            preconditionFailure("Can't find bundle or nib for TimelineGraphView")
        }
        
        timelineGraphView.viewModel = viewModel
        timelineGraphView.delegate = viewModel
        
        if let stackView = containerView as? UIStackView {
            timelineGraphView.layer.cornerRadius = TimelineConstants.UIStyle.cornerRadius
            timelineGraphView.clipsToBounds = true
            timelineGraphView.heightAnchor.constraint(equalToConstant: 275).isActive = true
            stackView.addArrangedSubview(timelineGraphView)
        } else {
            containerView.layer.cornerRadius = TimelineConstants.UIStyle.cornerRadius
            containerView.clipsToBounds = true
            containerView.embedSubview(timelineGraphView)
        }
    }
}
