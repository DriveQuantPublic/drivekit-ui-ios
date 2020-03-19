//
//  DKTextFieldCell.swift
//  DriveKitCommonUI
//
//  Created by Meryl Barantal on 19/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public protocol DKTextFieldDelegate: class {
    func userDidEndEditing(textField: DKTextField)
}

public final class DKTextField: UIView, Nibable {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var underline: UIView!
    @IBOutlet weak var subtitle: UILabel!
    
    public var delegate: DKTextFieldDelegate? = nil

    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func getTextFieldValue() -> String {
        return textField.text ?? ""
    }
    
    public func configure(placeholder: String, value: String = "", subtitleText: String? = nil, isError: Bool = false, keyBoardType: UIKeyboardType = .default, isEnabled: Bool = false) {
        textField.placeholder = placeholder
        textField.text = value
        textField.isEnabled = isEnabled
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = keyBoardType
        if isError {
            configureError(error: subtitleText)
        } else {
            if isEnabled {
                underline.isHidden = false
                underline.backgroundColor = DKUIColors.secondaryColor.color
            } else {
                underline.isHidden = true
            }
            if let desc = subtitleText {
                subtitle.isHidden = false
                subtitle.attributedText = desc.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
            } else {
                subtitle.isHidden = true
            }
        }
        
    }
    
    public func configureError(error: String?) {
        underline.isHidden = false
        underline.backgroundColor = DKUIColors.warningColor.color
        if let textError = error {
            subtitle.isHidden = false
            subtitle.attributedText = textError.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.warningColor).build()
        } else {
            subtitle.isHidden = true
        }
    }
    
    @IBAction func didEndEditing(_ sender: Any) {
        if textField.text == nil {
            self.configureError(error: DKCommonLocalizable.errorEmptyField.text())
        }
        self.delegate?.userDidEndEditing(textField: self)
    }
}
