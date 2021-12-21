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

}
