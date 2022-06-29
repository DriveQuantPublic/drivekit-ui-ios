//
//  VehicleFieldCell.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 19/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBVehicleAccessModule

protocol VehicleFieldCellDelegate: AnyObject {
    func didEndEditing(cell: VehicleFieldCell, value: String)
}

class VehicleFieldCell: UITableViewCell {
    @IBOutlet weak var textField: UIView!

    weak var delegate: VehicleFieldCellDelegate? = nil
    var textFieldView: DKTextField = DKTextField.viewFromNib

    func configure(vehicle: DKVehicle, field: DKVehicleField, value: String, delegate: VehicleFieldCellDelegate, hasError: Bool) {
        textFieldView.delegate = self
        textFieldView.placeholder = field.getTitle(vehicle: vehicle)
        textFieldView.title = field.getTitle(vehicle: vehicle)
        textFieldView.subtitleText = field.getDescription(vehicle: vehicle)
        textFieldView.value = value
        textFieldView.enable = field.isEditable
        textFieldView.keyBoardType = field.keyBoardType
        if hasError {
            configureError(error: field.getErrorDescription(value: value, vehicle: vehicle) ?? "")
        }
        self.delegate = delegate

        textField.embedSubview(textFieldView)
    }

    func configureError(error: String?) {
        textFieldView.errorMessage = error
    }
}

extension VehicleFieldCell : DKTextFieldDelegate {
    func userDidEndEditing(textField: DKTextField) {
        self.delegate?.didEndEditing(cell: self, value: textField.getTextFieldValue() ?? "")
    }
}
