// swiftlint:disable no_magic_numbers
//
//  VehicleDetailHeader.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 20/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

protocol VehicleDetailHeaderDelegate: AnyObject {
    func didSelectAddImage(cell: VehicleDetailHeader)
}

class VehicleDetailHeader: UITableViewCell {
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var vehicleName: UILabel!
    @IBOutlet weak var addVehicleImageButton: UIButton!

    weak var delegate: VehicleDetailHeaderDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = DKUIColors.backgroundView.color
        configureHeaderButton()
    }

    func configure(vehicleName: String, vehicleImage: UIImage?) {
        self.vehicleImage.image = vehicleImage
        self.vehicleName.attributedText = vehicleName.dkAttributedString().font(dkFont: .primary, style: .headLine1).color(DKUIColors.fontColorOnPrimaryColor).build()
    }

    func configureHeaderButton() {
        if let rawImage = DKVehicleImages.galleryImage.image {
            let imageWidth = addVehicleImageButton.frame.size.width
            let margin = 15.0
            let targetWdith = imageWidth - 2*margin
            let targetSize = CGSize(width: targetWdith, height: targetWdith)
            var config = UIButton.Configuration.plain()
            config.image = UIGraphicsImageRenderer(size: targetSize).image { _ in
                rawImage.draw(in: CGRect(origin: .zero, size: targetSize))
            }.withRenderingMode(.alwaysTemplate)
            config.background.backgroundColor = DKUIColors.secondaryColor.color
            config.background.cornerRadius = imageWidth/2
            config.baseForegroundColor = DKUIColors.fontColorOnSecondaryColor.color
            addVehicleImageButton.configuration = config
        } else {
            addVehicleImageButton.isHidden = true
        }
    }

    @IBAction func didSelectAddVehicleImage(_ sender: Any) {
        self.delegate?.didSelectAddImage(cell: self)
    }
}
