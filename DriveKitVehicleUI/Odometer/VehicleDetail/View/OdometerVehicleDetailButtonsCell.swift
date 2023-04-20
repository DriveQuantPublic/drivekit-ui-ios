// swiftlint:disable all
//
//  OdometerVehicleDetailButtonsCell.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 08/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

protocol OdometerVehicleDetailButtonsCellDelegate: AnyObject {
    func didSelectUpdateButton(sender: OdometerVehicleDetailButtonsCell)
    func didSelectReferenceLink(sender: OdometerVehicleDetailButtonsCell)
}

final class OdometerVehicleDetailButtonsCell: UITableViewCell, Nibable {
    @IBOutlet private weak var updateButton: UIButton!
    @IBOutlet private weak var referenceLink: UIButton!

    weak var delegate: OdometerVehicleDetailButtonsCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateButton.configure(title: "dk_vehicle_odometer_history_update".dkVehicleLocalized(), style: .full)
        self.referenceLink.configure(title: "dk_vehicle_odometer_histories_link".dkVehicleLocalized(), style: .empty)
    }

    @IBAction private func selectUpdate(_ sender: Any) {
        delegate?.didSelectUpdateButton(sender: self)
    }

    @IBAction private func selectReference(_ sender: Any) {
        delegate?.didSelectReferenceLink(sender: self)
    }

    func showReferenceLink(_ show: Bool) {
        self.referenceLink.isHidden = !show
    }
}
