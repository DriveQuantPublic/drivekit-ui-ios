// swiftlint:disable no_magic_numbers
//
//  RankingSelectorsView.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 02/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI
import DriveKitDBAchievementAccessModule

class RankingSelectorsView: UIStackView {

    @IBOutlet private weak var rankingTypesContainer: UIStackView!
    @IBOutlet private weak var rankingSelectorsContainer: UIView!
    @IBOutlet private weak var rankingSelectorsStackView: UIStackView!
    private var viewModel: RankingViewModel?
    private var selectedRankingTypeView: RankingSelectorTypeView?
    private var selectedRankingSelectorView: RankingSelectorButton?

    func update(viewModel: RankingViewModel) {
        self.viewModel = viewModel

        let rankingTypes = viewModel.rankingTypes
        if rankingTypes.count < 2 {
            self.rankingTypesContainer.isHidden = true
        } else {
            let selectedRankingType = viewModel.selectedRankingType ?? rankingTypes.first!
            self.rankingTypesContainer.isHidden = false
            self.rankingTypesContainer.removeAllSubviews()
            for rankingType in rankingTypes {
                if let selectorView = Bundle.driverAchievementUIBundle?.loadNibNamed("RankingSelectorTypeView", owner: nil, options: nil)?.first as? RankingSelectorTypeView {
                    selectorView.update(rankingType: rankingType)
                    let selected = selectedRankingType.index == rankingType.index
                    selectorView.setSelected(selected)
                    if selected {
                        self.selectedRankingTypeView = selectorView
                    }
                    selectorView.addTarget(self, action: #selector(onRankingTypeContainerSelected(sender:)), for: .touchUpInside)
                    self.rankingTypesContainer.addArrangedSubview(selectorView)
                }
            }
        }

        let rankingSelectors = viewModel.rankingSelectors
        if rankingSelectors.count < 2 {
            rankingSelectorsContainer.isHidden = true
        } else {
            let selectedRankingSelector = viewModel.selectedRankingSelector ?? rankingSelectors.first!
            self.rankingSelectorsContainer.isHidden = false
            self.rankingSelectorsStackView.removeAllSubviews()
            for rankingSelector in rankingSelectors {
                let selectorView = RankingSelectorButton()
                selectorView.update(rankingSelector: rankingSelector)
                let selected = selectedRankingSelector.index == rankingSelector.index
                selectorView.setSelected(selected)
                if selected {
                    self.selectedRankingSelectorView = selectorView
                }
                selectorView.addTarget(self, action: #selector(onRankingSelectorButtonSelected(sender:)), for: .touchUpInside)
                self.rankingSelectorsStackView.addArrangedSubview(selectorView)
                self.rankingSelectorsStackView.addConstraints([
                    selectorView.topAnchor.constraint(equalTo: self.rankingSelectorsStackView.topAnchor),
                    selectorView.bottomAnchor.constraint(equalTo: self.rankingSelectorsStackView.bottomAnchor)
                ])
            }
        }
    }

    @objc private func onRankingTypeContainerSelected(sender: RankingSelectorTypeView) {
        self.selectedRankingTypeView?.setSelected(false)
        self.selectedRankingTypeView = sender
        sender.setSelected(true)
        if let viewModel = self.viewModel, viewModel.selectedRankingType?.index != sender.rankingType?.index {
            viewModel.selectedRankingType = sender.rankingType
        }
    }

    @objc private func onRankingSelectorButtonSelected(sender: RankingSelectorButton) {
        self.selectedRankingSelectorView?.setSelected(false)
        self.selectedRankingSelectorView = sender
        sender.setSelected(true)
        if let viewModel = self.viewModel, viewModel.selectedRankingSelector?.index != sender.rankingSelector?.index {
            viewModel.selectedRankingSelector = sender.rankingSelector
        }
    }

}
