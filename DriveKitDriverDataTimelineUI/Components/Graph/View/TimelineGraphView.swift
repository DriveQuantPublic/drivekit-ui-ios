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
            update()
        }
    }
    weak var delegate: GraphViewDelegate?
    private weak var graphView: GraphViewBase!

    override func awakeFromNib() {
        super.awakeFromNib()
        update()
    }

    private func update() {
        if let graphViewContainer = self.graphViewContainer {
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
                    self?.updateTitle()
                    graphView.setupData()
                }

                updateTitle()
            } else {
                graphViewContainer.removeSubviews()
                self.titleView.attributedText = nil
            }
        }
    }

    private func updateTitle() {
        if let viewModel = self.viewModel {
            self.titleView.attributedText = viewModel.title.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).buildWithArgs(viewModel.description.dkAttributedString().font(dkFont: .primary, style: DKStyle(size: DKStyles.smallText.style.size, traits: .traitBold)).color(.primaryColor).build())
        }
    }
}

extension TimelineGraphView: GraphViewDelegate {
    func graphDidSelectPoint(_ point: GraphPoint) {
        self.delegate?.graphDidSelectPoint(point)
    }
}
