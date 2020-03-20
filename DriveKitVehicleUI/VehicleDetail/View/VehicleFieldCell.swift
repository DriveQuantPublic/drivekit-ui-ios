//
//  VehicleFieldCell.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 19/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBVehicleAccess

protocol VehicleFieldCellDelegate {
    func didEndEditing(cell: VehicleFieldCell, value: String?)
}

class VehicleFieldCell: UITableViewCell {
    @IBOutlet weak var textField: UIView!
    
    var delegate : VehicleFieldCellDelegate? = nil
    var textFieldView: DKTextField = DKTextField.viewFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(field: VehicleField, vehicle: DKVehicle) {
        textFieldView.delegate = self
        textFieldView.placeholder = field.title
        textFieldView.title = field.title
        textFieldView.value = field.getValue(vehicle: vehicle) ?? ""
        textFieldView.enable = field.isEditable
        textFieldView.keyBoardType = field.keyBoardType
        
        textField.embedSubview(textFieldView)

    }
    
    func configureError(error: String) {
        textFieldView.errorMessage = error
    }
}

extension VehicleFieldCell : DKTextFieldDelegate {
    func userDidEndEditing(textField: DKTextField) {
        self.delegate?.didEndEditing(cell: self, value: textField.getTextFieldValue())
    }
}
