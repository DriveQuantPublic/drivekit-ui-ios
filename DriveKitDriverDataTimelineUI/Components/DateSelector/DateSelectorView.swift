//
//  DateSelectorView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class DateSelectorView: UIView {
    @IBOutlet private weak var dateIntervalLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var previousButton: UIButton!

    private var viewModel: DateSelectorViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func configure(viewModel: DateSelectorViewModel?) {
        self.viewModel = viewModel
        self.setupView()
    }

    func setupView() {
        self.dateIntervalLabel.attributedText = self.viewModel?.getDateIntervalAttributedText()
        self.nextButton.isEnabled = self.viewModel?.hasNextDate ?? false
        self.previousButton.isEnabled = self.viewModel?.hasPerviousDate ?? false
    }

    @IBAction func showNextDate() {
        self.viewModel?.moveToNextDate()
    }

    @IBAction func showPreviousDate() {
        self.viewModel?.moveToPreviousDate()
    }
}

extension DateSelectorView: DateSelectorDelegate {
    func dateSelectorDidSelectDate(_ date: Date) {
        self.setupView()
    }
}
