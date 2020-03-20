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
    @IBOutlet var titleTextField: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var underline: UIView!
    @IBOutlet var subtitle: UILabel!
    
    public var delegate: DKTextFieldDelegate? = nil
    
    public var placeholder: String = "" {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    public var title: String? = nil {
        didSet {
            configureTitle()
        }
    }
    
    public var errorMessage: String? = nil {
        didSet {
            configureError()
        }
    }
    
    public var value: String = "" {
        didSet {
            textField.text = value
        }
    }
    
    public var enable : Bool = true {
        didSet {
            textField.isEnabled = enable
            configureUnderline()
        }
    }
    
    public var keyBoardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyBoardType
        }
    }
    
    public var subtitleText: String? = nil {
        didSet {
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    public func getTextFieldValue() -> String? {
        return textField.text
    }
    
    
    private func setup() {
        textField.placeholder = placeholder
        titleTextField.attributedText = placeholder.dkAttributedString().font(dkFont: .primary, style: .normalText).color(DKUIColors.complementaryFontColor).build()
        textField.text = value
        textField.textColor = DKUIColors.mainFontColor.color
        textField.isEnabled = enable
        textField.keyboardType = keyBoardType
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.returnKeyType = .done
        configureSubtitleLabel()
    }
    
    private func configureTitle() {
        if let title = self.title {
            if placeholder == "" || value != "" || textField.text != "" {
                titleTextField.isHidden = false
                titleTextField.attributedText = title.dkAttributedString().font(dkFont: .primary, style: .normalText).color(DKUIColors.complementaryFontColor).build()
            } else {
                titleTextField.isHidden = true
            }
        } else {
            titleTextField.isHidden = true
        }
    }
    
    private func configureSubtitleLabel() {
        if let desc = subtitleText {
            subtitle.isHidden = false
            subtitle.attributedText = desc.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        } else {
            subtitle.isHidden = true
        }
    }
    
    private func configureUnderline(isError: Bool = false) {
        if enable {
            underline.isHidden = false
            if isError {
                 underline.backgroundColor = DKUIColors.criticalColor.color
            } else {
                underline.backgroundColor = DKUIColors.complementaryFontColor.color
            }
        } else {
            underline.isHidden = true
        }
    }
    
    private func configureError() {
        if let textError = errorMessage {
            self.configureUnderline(isError: true)
            subtitle.isHidden = false
            subtitle.attributedText = textError.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.criticalColor).build()
        } else {
            self.configureUnderline(isError: false)
            subtitle.isHidden = true
        }
    }
    
    @IBAction func didStartEditing(_ sender: Any) {
        configureTitle()
        underline.backgroundColor = DKUIColors.secondaryColor.color
    }
    
    @IBAction func didEndEditing(_ sender: Any) {
        configureTitle()
        underline.backgroundColor = DKUIColors.complementaryFontColor.color
        self.delegate?.userDidEndEditing(textField: self)
    }
}

extension DKTextField : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
