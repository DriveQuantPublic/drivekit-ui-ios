// swiftlint:disable no_magic_numbers
//
//  OdometerVehicleCell.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 05/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitVehicleModule
import DriveKitDBVehicleAccessModule

final class OdometerVehicleCell: UITableViewCell, Nibable {
    @IBOutlet private weak var vehicleImage: UIImageView!
    @IBOutlet private weak var vehicleName: UILabel!
    @IBOutlet private weak var pickerImage: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        self.vehicleImage.layer.cornerRadius = self.vehicleImage.frame.height / 2
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.vehicleImage.clipsToBounds = true
        self.pickerImage.image = DKImages.arrowDown.image?.withRenderingMode(.alwaysTemplate)
        self.pickerImage.tintColor = UIColor(red: 119, green: 119, blue: 119)
    }

    func configure(viewModel: OdometerVehicleCellViewModel, showPickerImage: Bool) {
        self.vehicleName.attributedText = viewModel.getVehicleName().dkAttributedString().color(.complementaryFontColor).font(dkFont: .primary, style: .normalText).build()
        self.vehicleImage.image = viewModel.getVehicleImage()
        self.pickerImage.isHidden = !showPickerImage
    }
}
