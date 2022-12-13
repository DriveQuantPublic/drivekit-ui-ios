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
