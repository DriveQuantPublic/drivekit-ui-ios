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
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var vehicleName: UILabel!
    @IBOutlet weak var pickerImage: UIImageView!

    func configure(vehicle: DKVehicle) {
        configureVehicleImage(vehicle: vehicle)
        self.vehicleName.attributedText = vehicle.computeName().dkAttributedString().color(.complementaryFontColor).font(dkFont: .primary, style: .normalText).build()
        self.pickerImage.image = DKImages.arrowDown.image?.withRenderingMode(.alwaysTemplate)
        self.pickerImage.tintColor = UIColor(red: 119, green: 119, blue: 119)
    }

    func configureVehicleImage(vehicle: DKVehicle) {
        self.vehicleImage.image = vehicle.getVehicleImage()
        self.vehicleImage.layer.cornerRadius = self.vehicleImage.frame.height / 2
        self.vehicleImage.clipsToBounds = true
    }
}
