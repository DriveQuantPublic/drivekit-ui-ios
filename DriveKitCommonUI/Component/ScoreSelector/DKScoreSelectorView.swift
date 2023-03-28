//
//  DKScoreSelectorView.swift
//  DriveKitCommonUI
//
//  Created by Frédéric Ruaudel on 17/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import UIKit

public class DKScoreSelectorView: UIStackView {
    private let selectorViewHeight = 64.0
    public private(set) var viewModel: DKScoreSelectorViewModel
    private var scoreSelectionButtons: [DKScoreType: ScoreSelectionTypeView] = [:]

    public init(viewModel: DKScoreSelectorViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = 0
        let selectedScore = viewModel.selectedScore
        self.removeAllSubviews()
        for score in viewModel.scores {
            let isSelected = score == selectedScore
            guard let scoreSelectionButton = ScoreSelectionTypeView.createScoreSelectionButton(for: score, isSelected: isSelected) else {
                continue
            }
            scoreSelectionButtons[score] = scoreSelectionButton
            scoreSelectionButton.addTarget(
                self,
                action: #selector(onScoreSelectionTypeViewSelected(_:)),
                for: .touchUpInside
            )
            self.addArrangedSubview(scoreSelectionButton)
        }
        self.isHidden = viewModel.shouldHideScoreSelectorView
        self.heightAnchor.constraint(
            equalToConstant: viewModel.shouldHideScoreSelectorView ? 0 : selectorViewHeight
        ).isActive = true
    }
    
    @objc func onScoreSelectionTypeViewSelected(_ sender: ScoreSelectionTypeView) {
        self.viewModel.didSelectScore(sender.scoreType)
        updateScoreSelectionButtonsState()
    }
    
    private func updateScoreSelectionButtonsState() {
        self.scoreSelectionButtons.forEach { score, button in
            button.setSelected(score == viewModel.selectedScore)
        }
    }
}

extension DKScoreSelectorView {
    public static func createScoreSelectorView(
        configuredWith viewModel: DKScoreSelectorViewModel,
        embededIn containerView: UIView
    ) {
        let scoreSelector = DKScoreSelectorView(viewModel: viewModel)
        containerView.embedSubview(scoreSelector)
    }
}
