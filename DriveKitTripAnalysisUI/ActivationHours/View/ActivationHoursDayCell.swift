//
//  ActivationHoursDayCell.swift
//  DriveKitTripAnalysisUI
//
//  Created by David Bauduin on 31/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import WARangeSlider

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
    }

    private func setupView() {

    }

    @IBAction private func switchDidUpdate() {
        self.viewModel?.isSelected = self.optionSwitch.isOn
    }

    @IBAction private func sliderDidUpdate() {
        if let viewModel = self.viewModel {
            viewModel.min = self.slider.lowerValue
            viewModel.max = self.slider.upperValue
            self.minLabel.text = viewModel.minFormattedValue
            self.maxLabel.text = viewModel.maxFormattedValue
        }
    }
}
