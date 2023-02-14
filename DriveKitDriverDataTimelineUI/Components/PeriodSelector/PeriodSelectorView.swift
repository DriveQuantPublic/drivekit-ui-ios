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
    @IBOutlet private weak var yearButton: UIButton!
    var viewModel: PeriodSelectorViewModel? {
        didSet {
            if let viewModel {
                self.weekButton.isHidden = viewModel.shouldHideButton(for: .week)
                self.monthButton.isHidden = viewModel.shouldHideButton(for: .month)
                self.yearButton.isHidden = viewModel.shouldHideButton(for: .year)
            }
            
            self.viewModel?.periodDidChange = { [weak self] in
                self?.periodSelectorViewModelDidUpdate()
            }
            periodSelectorViewModelDidUpdate()
        }
    }
    private var selectedButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()

        configureButton(self.weekButton, title: "dk_timeline_per_week".dkDriverDataTimelineLocalized())
        configureButton(self.monthButton, title: "dk_timeline_per_month".dkDriverDataTimelineLocalized())
        configureButton(self.yearButton, title: "dk_driverdata_synthesis_year".dkDriverDataTimelineLocalized())
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // swiftlint:disable no_magic_numbers
        self.weekButton.layer.cornerRadius = self.weekButton.bounds.size.height / 2
        self.monthButton.layer.cornerRadius = self.monthButton.bounds.size.height / 2
        self.yearButton.layer.cornerRadius = self.yearButton.bounds.size.height / 2
        // swiftlint:enable no_magic_numbers
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

    private func periodSelectorViewModelDidUpdate() {
        if let selectedPeriod = self.viewModel?.selectedPeriod {
            let buttonToSelect: UIButton
            switch selectedPeriod {
                case .week:
                    buttonToSelect = self.weekButton
                case .month:
                    buttonToSelect = self.monthButton
                case .year:
                    buttonToSelect = self.yearButton
                @unknown default:
                    buttonToSelect = self.weekButton
            }
            if buttonToSelect != self.selectedButton {
                didSelectButton(buttonToSelect)
            }
        }
    }
}

extension PeriodSelectorView {
    static func createPeriodSelectorView(
        configuredWith viewModel: PeriodSelectorViewModel,
        embededIn containerView: UIView
    ) {
        guard let periodSelector = Bundle.driverDataTimelineUIBundle?.loadNibNamed(
            "PeriodSelectorView",
            owner: nil,
            options: nil
        )?.first as? PeriodSelectorView else {
            preconditionFailure("Can't find bundle or nib for PeriodSelectorView")
        }
        
        containerView.embedSubview(periodSelector)
        periodSelector.viewModel = viewModel
    }
}
