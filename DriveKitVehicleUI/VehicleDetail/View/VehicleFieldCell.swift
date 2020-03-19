//
//  VehicleFieldCell.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 19/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

protocol VehicleFieldCellDelegate {
    func didEndEditing(cell: VehicleFieldCell, value: String)
}

class VehicleFieldCell: UITableViewCell {
    @IBOutlet weak var textField: DKTextField!
    
    var delegate : VehicleFieldCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.delegate = self
    }
}

extension VehicleFieldCell : DKTextFieldDelegate {
    func userDidEndEditing(textField: DKTextField) {
        self.delegate?.didEndEditing(cell: self, value: textField.getTextFieldValue())
    }
}
