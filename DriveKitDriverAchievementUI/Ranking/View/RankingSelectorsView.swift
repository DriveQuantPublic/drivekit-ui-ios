//
//  RankingSelectorsView.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 02/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI
import DriveKitDBAchievementAccess

class RankingSelectorsView : UIStackView {

    @IBOutlet private weak var rankingTypesContainer: UIStackView!
    @IBOutlet private weak var rankingSelectorsContainer: UIView!
    @IBOutlet private weak var rankingSelectorsStackView: UIStackView!
    private(set) var rankingTypes = [RankingType]()
    private(set) var rankingSelectors = [RankingSelector]()
    private var viewModel: RankingViewModel? = nil
    private var selectedRankingTypeView: RankingSelectorTypeView? = nil
    private var selectedRankingSelectorView: RankingSelectorButton? = nil

    func update(viewModel: RankingViewModel) {
        self.rankingTypes = viewModel.rankingTypes
        self.rankingSelectors = viewModel.rankingSelectors
        self.viewModel = viewModel

        if self.rankingTypes.count < 2 {
            self.rankingTypesContainer.isHidden = true
        } else {
            let selectedRankingType = viewModel.selectedRankingType ?? self.rankingTypes.first!
            self.rankingTypesContainer.isHidden = false
            self.rankingTypesContainer.removeAllSubviews()
            for rankingType in self.rankingTypes {
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

        if self.rankingSelectors.count < 2 {
            self.rankingSelectorsContainer.isHidden = true
        } else {
            let selectedRankingSelector = viewModel.selectedRankingSelector ?? self.rankingSelectors.first!
            self.rankingSelectorsContainer.isHidden = false
            self.rankingSelectorsStackView.removeAllSubviews()
            for rankingSelector in self.rankingSelectors {
                let selectorView = RankingSelectorButton(type: .system)
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
        self.viewModel?.selectedRankingType = sender.rankingType
    }

    @objc private func onRankingSelectorButtonSelected(sender: RankingSelectorButton) {
        self.selectedRankingSelectorView?.setSelected(false)
        self.selectedRankingSelectorView = sender
        sender.setSelected(true)
        self.viewModel?.selectedRankingSelector = sender.rankingSelector
    }

}
