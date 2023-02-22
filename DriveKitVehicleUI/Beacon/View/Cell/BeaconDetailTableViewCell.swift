// swiftlint:disable all
//
//  BeaconDetailTableViewCell.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 17/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class BeaconDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!

    func configure(pos: Int, viewModel: BeaconDetailViewModel) {
        keyLabel.attributedText = viewModel.data[pos].keys.first?.dkVehicleLocalized().dkAttributedString().primaryFontNormalTextMainFontColor()
        valueLabel.attributedText = viewModel.data[pos][viewModel.data[pos].keys.first ?? ""]
        separatorView.backgroundColor = DKUIColors.neutralColor.color
    }
}
