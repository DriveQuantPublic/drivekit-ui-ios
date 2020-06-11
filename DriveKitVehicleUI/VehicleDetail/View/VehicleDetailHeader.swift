//
//  VehicleDetailHeader.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 20/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

protocol VehicleDetailHeaderDelegate : AnyObject {
    func didSelectAddImage(cell: VehicleDetailHeader)
}

class VehicleDetailHeader : UITableViewCell {
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var vehicleName: UILabel!
    @IBOutlet weak var addVehicleImageButton: UIButton!

    weak var delegate: VehicleDetailHeaderDelegate? = nil

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
        addVehicleImageButton.layer.borderColor = UIColor.black.cgColor
        addVehicleImageButton.layer.cornerRadius = addVehicleImageButton.bounds.size.width / 2
        addVehicleImageButton.layer.masksToBounds = true
        addVehicleImageButton.backgroundColor = DKUIColors.secondaryColor.color
        addVehicleImageButton.titleLabel?.text = ""
        if let headerIcon = UIImage(named: "dk_gallery_image", in: Bundle.vehicleUIBundle, compatibleWith: nil) {
            headerIcon.withRenderingMode(.alwaysTemplate)
            addVehicleImageButton.setImage(headerIcon, for: .normal)
            addVehicleImageButton.tintColor = DKUIColors.fontColorOnSecondaryColor.color
            addVehicleImageButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        } else {
            addVehicleImageButton.isHidden = true
        }
    }

    @IBAction func didSelectAddVehicleImage(_ sender: Any) {
        self.delegate?.didSelectAddImage(cell: self)
    }
}
