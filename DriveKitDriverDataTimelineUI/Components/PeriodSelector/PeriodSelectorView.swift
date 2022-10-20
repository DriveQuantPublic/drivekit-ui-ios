//
//  PeriodSelectorView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

class PeriodSelectorView: UIView {
    @IBOutlet private weak var weekButton: UIButton!
    @IBOutlet private weak var monthButton: UIButton!
    var viewModel: PeriodSelectorViewModel? {
        didSet {
            self.viewModel?.viewDelegate = self
            periodSelectorViewModelDidUpdate()
        }
    }
    private var selectedButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()

        configureButton(self.weekButton, title: "dk_timeline_per_week".dkDriverDataTimelineLocalized())
        configureButton(self.monthButton, title: "dk_timeline_per_month".dkDriverDataTimelineLocalized())
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.weekButton.layer.cornerRadius = self.weekButton.bounds.size.height / 2
        self.monthButton.layer.cornerRadius = self.monthButton.bounds.size.height / 2
    }

    private func configureButton(_ button: UIButton, title: String) {
        button.setBackgroundImage(UIImage(color: DKUIColors.neutralColor.color), for: .normal)
        button.setBackgroundImage(UIImage(color: DKUIColors.secondaryColor.color), for: .selected)
        button.setAttributedTitle(title.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build(), for: .normal)
        button.setAttributedTitle(title.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.fontColorOnSecondaryColor).build(), for: .selected)
        button.layer.masksToBounds = true
    }

    @IBAction private func didSelectButton(_ button: UIButton) {
        if self.selectedButton != button {
            self.selectedButton?.isSelected = false
            self.selectedButton = button
            button.isSelected = true
            if let viewModel = self.viewModel {
                let period: DKTimelinePeriod?
                if button == self.weekButton {
                    period = .week
                } else if button == self.monthButton {
                    period = .month
                } else {
                    period = nil
                }
                if let period {
                    viewModel.didSelectPeriod(period)
                }
            }
        }
    }
}

extension PeriodSelectorView: PeriodSelectorViewModelDelegate {
    func periodSelectorViewModelDidUpdate() {
        if let selectedPeriod = self.viewModel?.selectedPeriod {
            let buttonToSelect: UIButton
            switch selectedPeriod {
                case .week:
                    buttonToSelect = self.weekButton
                case .month:
                    buttonToSelect = self.monthButton
                @unknown default:
                    buttonToSelect = self.weekButton
            }
            if buttonToSelect != self.selectedButton {
                didSelectButton(buttonToSelect)
            }
        }
    }
}
