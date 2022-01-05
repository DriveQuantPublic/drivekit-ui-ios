//
//  ActivationHoursDayCell.swift
//  DriveKitTripAnalysisUI
//
//  Created by David Bauduin on 31/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import WARangeSlider
import DriveKitCommonUI

class ActivationHoursDayCell: UITableViewCell {
    @IBOutlet private weak var optionSwitch: UISwitch!
    @IBOutlet private weak var slider: RangeSlider!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var minLabel: UILabel!
    @IBOutlet private weak var maxLabel: UILabel!
    private var viewModel: ActivationHoursDayCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func configure(viewModel: ActivationHoursDayCellViewModel) {
        self.viewModel = viewModel

        self.optionSwitch.isOn = viewModel.isSelected
        self.dayLabel.text = viewModel.text
        self.slider.lowerValue = viewModel.min
        self.slider.upperValue = viewModel.max
        updateLabels(viewModel: viewModel)
        switchDidUpdate()
    }

    private func setupView() {
        let font = DKStyles.smallText.style.applyTo(font: .primary)
        self.dayLabel.font = font
        self.dayLabel.textColor = DKUIColors.neutralColor.color
        self.minLabel.font = font
        self.dayLabel.textColor = DKUIColors.primaryColor.color
        self.maxLabel.font = font
        self.dayLabel.textColor = DKUIColors.primaryColor.color
        self.optionSwitch.onTintColor = DKUIColors.secondaryColor.color
    }

    private func updateLabels(viewModel: ActivationHoursDayCellViewModel) {
        self.minLabel.text = viewModel.minFormattedValue
        self.maxLabel.text = viewModel.maxFormattedValue
    }

    @IBAction private func switchDidUpdate() {
        self.viewModel?.isSelected = self.optionSwitch.isOn
        self.slider.setEnabled(self.optionSwitch.isOn)
    }

    @IBAction private func sliderDidUpdate() {
        if let viewModel = self.viewModel {
            viewModel.min = self.slider.lowerValue
            viewModel.max = self.slider.upperValue
            updateLabels(viewModel: viewModel)
        }
    }
}

extension RangeSlider {
    func setEnabled(_ enabled: Bool) {
        if enabled {
            thumbTintColor = DKUIColors.primaryColor.color
            trackTintColor = DKUIColors.neutralColor.color
            trackHighlightTintColor = DKUIColors.secondaryColor.color
            isUserInteractionEnabled = true
        } else {
            thumbTintColor = DKUIColors.neutralColor.color
            trackTintColor = DKUIColors.neutralColor.color
            trackHighlightTintColor = DKUIColors.neutralColor.color
            isUserInteractionEnabled = false
        }
    }
}
