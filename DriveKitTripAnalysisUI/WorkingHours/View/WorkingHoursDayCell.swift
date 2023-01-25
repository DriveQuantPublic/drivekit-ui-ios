// swiftlint:disable all
//
//  WorkingHoursDayCell.swift
//  DriveKitTripAnalysisUI
//
//  Created by David Bauduin on 31/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import WARangeSlider
import DriveKitCommonUI

class WorkingHoursDayCell: UITableViewCell {
    @IBOutlet private weak var optionSwitch: UISwitch!
    @IBOutlet private weak var slider: RangeSlider!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var minLabel: UILabel!
    @IBOutlet private weak var maxLabel: UILabel!
    private var viewModel: WorkingHoursDayCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func configure(viewModel: WorkingHoursDayCellViewModel) {
        self.viewModel = viewModel

        self.optionSwitch.isOn = viewModel.isSelected
        self.dayLabel.text = viewModel.text
        self.slider.lowerValue = viewModel.min
        self.slider.upperValue = viewModel.max
        self.slider.trackTintColor = DKUIColors.neutralColor.color

        switchDidUpdate()
    }

    private func setupView() {
        let font = DKStyles.smallText.style.applyTo(font: .primary)
        self.dayLabel.font = font
        self.minLabel.font = font
        self.minLabel.textColor = DKUIColors.primaryColor.color
        self.maxLabel.font = font
        self.maxLabel.textColor = DKUIColors.primaryColor.color
        self.optionSwitch.onTintColor = DKUIColors.secondaryColor.color
    }

    private func updateLabels(viewModel: WorkingHoursDayCellViewModel) {
        self.minLabel.text = viewModel.minFormattedValue
        self.maxLabel.text = viewModel.maxFormattedValue
    }

    @IBAction private func switchDidUpdate() {
        let enabled = self.optionSwitch.isOn
        self.viewModel?.isSelected = enabled
        self.slider.isUserInteractionEnabled = enabled
        self.dayLabel.textColor = enabled ? DKUIColors.secondaryColor.color : DKUIColors.neutralColor.color

        if enabled {
            self.slider.thumbTintColor = DKUIColors.primaryColor.color
            self.slider.thumbBorderColor = .gray
            self.slider.trackHighlightTintColor = DKUIColors.secondaryColor.color
        } else {
            let thumbColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
            self.slider.thumbTintColor = thumbColor
            self.slider.thumbBorderColor = thumbColor
            self.slider.trackHighlightTintColor = DKUIColors.neutralColor.color
        }

        if let viewModel = self.viewModel {
            updateLabels(viewModel: viewModel)
        }
    }

    @IBAction private func sliderDidUpdate() {
        if let viewModel = self.viewModel {
            viewModel.min = self.slider.lowerValue
            viewModel.max = self.slider.upperValue
            updateLabels(viewModel: viewModel)
        }
    }
}
