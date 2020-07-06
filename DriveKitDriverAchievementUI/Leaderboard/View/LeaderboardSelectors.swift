//
//  LeaderboardSelectors.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 02/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI
import DriveKitDBAchievementAccess

class LeaderboardSelectors : UIStackView {

    @IBOutlet private weak var rankingTypesContainer: UIView!
    @IBOutlet private weak var safetyContainer: UIView!
    @IBOutlet private weak var safetySelectionIndicator: UIView!
    @IBOutlet private weak var ecoDrivingContainer: UIView!
    @IBOutlet private weak var ecoDrivingSelectionIndicator: UIView!
    @IBOutlet private weak var phoneDistractionContainer: UIView!
    @IBOutlet private weak var phoneDistractionSelectionIndicator: UIView!
    @IBOutlet private weak var speedingContainer: UIView!
    @IBOutlet private weak var speedingSelectionIndicator: UIView!
    @IBOutlet private weak var rankingSelectorsContainer: UIView!
    @IBOutlet private weak var rankingSelector1Button: UIButton!
    @IBOutlet private weak var rankingSelector2Button: UIButton!
    @IBOutlet private weak var rankingSelector3Button: UIButton!
    private var viewModel: LeaderboardViewModel? = nil

    override func awakeFromNib() {
        super.awakeFromNib()

        let indicatorColor = DKUIColors.secondaryColor.color
        self.safetySelectionIndicator.backgroundColor = indicatorColor
        self.ecoDrivingSelectionIndicator.backgroundColor = indicatorColor
        self.phoneDistractionSelectionIndicator.backgroundColor = indicatorColor
        self.speedingSelectionIndicator.backgroundColor = indicatorColor
    }

    func update(viewModel: LeaderboardViewModel) {
        self.viewModel = viewModel

        let rankingTypes = viewModel.rankingTypes
        let rankingSelector = viewModel.rankingSelector

        if rankingTypes.count < 2 {
            self.rankingTypesContainer.isHidden = true
        } else {
            let selectedRankingType = viewModel.selectedRankingType ?? rankingTypes.first!
            self.rankingTypesContainer.isHidden = false
            self.safetyContainer.isHidden = true
            self.ecoDrivingContainer.isHidden = true
            self.phoneDistractionContainer.isHidden = true
            self.speedingContainer.isHidden = true
            for rankingType in rankingTypes {
                switch rankingType {
                    case .distraction:
                        self.phoneDistractionContainer.isHidden = false
                        self.phoneDistractionSelectionIndicator.isHidden = (selectedRankingType != rankingType)
                    case .ecoDriving:
                        self.ecoDrivingContainer.isHidden = false
                        self.ecoDrivingSelectionIndicator.isHidden = (selectedRankingType != rankingType)
                    case .safety:
                        self.safetyContainer.isHidden = false
                        self.safetySelectionIndicator.isHidden = (selectedRankingType != rankingType)
                }
            }
        }

        switch rankingSelector {
            case .none:
                self.rankingSelectorsContainer.isHidden = true
            case let .period(rankingPeriods):
                configureRankingSelectorButtons(viewModel: viewModel, rankingPeriods: rankingPeriods)
        }
    }
    

    @IBAction private func onRankingTypeContainerSelected(sender: UIView) {
        if let viewModel = self.viewModel {
            var rankingType: DKRankingType? = nil
            if sender == self.safetyContainer {
                rankingType = .safety
            } else if sender == self.ecoDrivingContainer {
                rankingType = .ecoDriving
            } else if sender == self.phoneDistractionContainer {
                rankingType = .distraction
            } else if sender == self.speedingContainer {

            }
            if let rankingType = rankingType, viewModel.selectedRankingType != rankingType {
                viewModel.selectedRankingType = rankingType

                self.phoneDistractionSelectionIndicator.isHidden = (rankingType != .distraction)
                self.ecoDrivingSelectionIndicator.isHidden = (rankingType != .ecoDriving)
                self.safetySelectionIndicator.isHidden = (rankingType != .safety)
            }
        }
    }

    @IBAction private func onRankingSelectorButtonSelected(sender: UIButton) {
        if let viewModel = self.viewModel {
            switch viewModel.rankingSelector {
                case .none:
                    // Nothing to do.
                    break
                case let .period(rankingPeriods):
                    var selectedRankingPeriod: DKRankingPeriod? = nil
                    if sender == self.rankingSelector1Button {
                        selectedRankingPeriod = rankingPeriods.first
                    } else if sender == self.rankingSelector2Button {
                        if rankingPeriods.count > 1 {
                            selectedRankingPeriod = rankingPeriods[1]
                        }
                    } else if sender == self.rankingSelector3Button {
                        if rankingPeriods.count > 2 {
                            selectedRankingPeriod = rankingPeriods[2]
                        }
                    }
                    if selectedRankingPeriod != nil {
                        if selectedRankingPeriod != viewModel.selectedRankingPeriod {
                            viewModel.selectedRankingPeriod = selectedRankingPeriod
                            configureRankingSelectorButtons(viewModel: viewModel, rankingPeriods: rankingPeriods)
                        }
                    }
            }
        }
    }


    private func configureRankingSelectorButtons(viewModel: LeaderboardViewModel, rankingPeriods: [DKRankingPeriod]) {
        // First, sanitize `rankingPeriods` array.
        var filteredRankingPeriods = [DKRankingPeriod]()
        var rankingPeriodsSet: Set<DKRankingPeriod> = []
        let managedRankingPeriods: Set<DKRankingPeriod> = [.legacy, .monthly, .weekly]
        for rankingPeriod in rankingPeriods {
            if !rankingPeriodsSet.contains(rankingPeriod) && managedRankingPeriods.contains(rankingPeriod) {
                filteredRankingPeriods.append(rankingPeriod)
                rankingPeriodsSet.insert(rankingPeriod)
            }
        }
        // Manage `filteredRankingPeriods`.
        if filteredRankingPeriods.count < 2 {
            self.rankingSelectorsContainer.isHidden = true
        } else {
            self.rankingSelectorsContainer.isHidden = false
            var buttons: [UIButton] = [self.rankingSelector1Button, self.rankingSelector2Button, self.rankingSelector3Button]
            var iterator = filteredRankingPeriods.makeIterator()
            let selectedRankingPeriod = viewModel.selectedRankingPeriod ?? filteredRankingPeriods.first!
            while let rankingPeriod = iterator.next() {
                let button = buttons.removeFirst()
                button.isHidden = false
                let buttonTitleKey: String
                let isSelected = (selectedRankingPeriod == rankingPeriod)
                switch rankingPeriod {
                    case .legacy:
                        buttonTitleKey = "TODO"
                    case .monthly:
                        buttonTitleKey = "TODO"
                    case .weekly:
                        buttonTitleKey = "TODO"
                }
                let fontColor: DKUIColors = isSelected ? .fontColorOnSecondaryColor : .mainFontColor
                button.setAttributedTitle(buttonTitleKey.dkAttributedString().font(dkFont: .primary, style: .button).color(fontColor).build(), for: .normal)
                button.backgroundColor = isSelected ? DKUIColors.secondaryColor.color : .leaderboard_grayColor
            }
            for button in buttons {
                button.isHidden = true
            }
        }
    }

}
