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

class DKTextFieldViewModel {
    var placeholder: String = ""
    var value: String = ""
    var subtitleText: String? = nil
    var errorText: String? = nil
    var isError: Bool = false
    var keyBoardType: UIKeyboardType = .default
    var isEnabled: Bool = false
    var emptyErrorText: String? = nil
}

public final class DKTextField: UIView, Nibable {
    @IBOutlet var titleTextField: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var underline: UIView!
    @IBOutlet var subtitle: UILabel!
    
    public var delegate: DKTextFieldDelegate? = nil
    
    var viewModel = DKTextFieldViewModel()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        textField.returnKeyType = .done
    }
    
    public func getTextFieldValue() -> String {
        return textField.text ?? ""
    }
    
    public func setValues(placeholder: String, value: String = "", subtitleText: String? = nil, isError: Bool = false, keyBoardType: UIKeyboardType = .default, isEnabled: Bool = false, emptyErrorText: String? = nil) {
        self.viewModel.placeholder = placeholder
        self.viewModel.value = value
        self.viewModel.subtitleText = subtitleText
        self.viewModel.isError = isError
        self.viewModel.keyBoardType = keyBoardType
        self.viewModel.isEnabled = isEnabled
        self.viewModel.emptyErrorText = emptyErrorText
    
        titleTextField.attributedText =  self.viewModel.placeholder.dkAttributedString().font(dkFont: .primary, style: .normalText).color(DKUIColors.primaryColor).build()
        textField.placeholder = self.viewModel.placeholder
        textField.text = self.viewModel.value
        textField.isEnabled = self.viewModel.isEnabled
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = self.viewModel.keyBoardType
        if self.viewModel.isError {
            self.configureError(error: subtitleText)
        } else {
            self.configure()
        }
    }
    
    public func configure() {
        if self.viewModel.isEnabled {
            underline.isHidden = false
            underline.backgroundColor = DKUIColors.secondaryColor.color
        } else {
            underline.isHidden = true
        }
        if let desc = self.viewModel.subtitleText {
            self.viewModel.subtitleText = desc
            subtitle.isHidden = false
            subtitle.attributedText = desc.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        } else {
            subtitle.isHidden = true
        }
    }
    
    public func configureError(error: String?) {
        underline.isHidden = false
        underline.backgroundColor = DKUIColors.warningColor.color
        self.viewModel.errorText = error
        if let textError = self.viewModel.errorText {
            subtitle.isHidden = false
            subtitle.attributedText = textError.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.warningColor).build()
        } else {
            subtitle.isHidden = true
        }
    }
    
    @IBAction func didEndEditing(_ sender: Any) {
        self.viewModel.value = textField.text ?? ""
        if let emptyError = self.viewModel.emptyErrorText , self.viewModel.value == "" {
            self.viewModel.isError = true
            self.configureError(error: emptyError)
        } else {
            self.viewModel.isError = false
            self.configure()
            self.delegate?.userDidEndEditing(textField: self)
        }
    }
}

extension DKTextField : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
