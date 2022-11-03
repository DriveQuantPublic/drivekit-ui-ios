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
        self.viewModel?.dateSelectorViewModelDidUpdate = { [weak self] in
            self?.setupView()
        }
    }

    func setupView() {
        self.dateIntervalLabel.attributedText = self.viewModel?.getDateIntervalAttributedText()
        if self.viewModel?.hasNextDate == true {
            self.nextButton.isEnabled = true
            self.nextButton.imageView?.image = UIImage(named: "dk_timeline_next_arrow",in: Bundle.driverDataTimelineUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate).tintedImage(withColor: DKUIColors.secondaryColor.color)
        } else {
            self.nextButton.imageView?.image = UIImage(named: "dk_timeline_next_arrow",in: Bundle.driverDataTimelineUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate).tintedImage(withColor: .gray)
            self.nextButton.isEnabled = false
        }
        if self.viewModel?.hasPreviousDate == true {
            self.previousButton.isEnabled = true
            self.previousButton.imageView?.image = UIImage(named: "dk_timeline_prev_arrow",in: Bundle.driverDataTimelineUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate).tintedImage(withColor: DKUIColors.secondaryColor.color)
        } else {
            self.previousButton.imageView?.image = UIImage(named: "dk_timeline_prev_arrow",in: Bundle.driverDataTimelineUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate).tintedImage(withColor: .gray)
            self.previousButton.isEnabled = false
        }
    }

    @IBAction func showNextDate() {
        self.viewModel?.moveToNextDate()
    }

    @IBAction func showPreviousDate() {
        self.viewModel?.moveToPreviousDate()
    }
}
