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

protocol VehicleFieldCellDelegate : AnyObject {
    func didEndEditing(cell: VehicleFieldCell, value: String)
}

class VehicleFieldCell: UITableViewCell {
    @IBOutlet weak var textField: UIView!
    
    weak var delegate : VehicleFieldCellDelegate? = nil
    var textFieldView: DKTextField = DKTextField.viewFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(field: DKVehicleField, value: String, delegate: VehicleFieldCellDelegate, hasError: Bool) {
        textFieldView.delegate = self
        textFieldView.placeholder = field.title
        textFieldView.title = field.title
        textFieldView.value = value
        textFieldView.enable = field.isEditable
        textFieldView.keyBoardType = field.keyBoardType
        if hasError {
            configureError(error: field.getErrorDescription() ?? "")
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
