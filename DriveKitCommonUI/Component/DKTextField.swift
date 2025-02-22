// swiftlint:disable no_magic_numbers
//
//  DKTextField.swift
//  DriveKitCommonUI
//
//  Created by Meryl Barantal on 19/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public protocol DKTextFieldDelegate: AnyObject {
    func userDidEndEditing(textField: DKTextField)
}

public final class DKTextField: UIView, Nibable {
    @IBOutlet private var titleTextField: UILabel!
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var underline: UIView!
    @IBOutlet private var subtitle: UILabel!

    public weak var delegate: DKTextFieldDelegate?

    public weak var target: UIView?

    public private(set) var horizontalPadding: CGFloat = 0

    public var placeholder: String = "" {
        didSet {
            textField.attributedPlaceholder = placeholder.dkAttributedString().font(dkFont: .primary, style: DKStyles.normalText.withSizeDelta(-2)).color(.lightGray).build()
        }
    }

    public var title: String? {
        didSet {
            configureTitle()
        }
    }

    public var errorMessage: String? {
        didSet {
            configureError()
        }
    }

    public var value: String = "" {
        didSet {
            textField.attributedText = value.dkAttributedString().font(dkFont: .primary, style: DKStyles.normalText.withSizeDelta(-2)).color(DKUIColors.mainFontColor).build()
            configureTitle()
        }
    }

    public var enable: Bool = true {
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

    public var subtitleText: String? {
        didSet {
            configureSubtitleLabel()
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
        textField.text = value
        textField.textColor = DKUIColors.mainFontColor.color
        textField.font = DKStyles.normalText.withSizeDelta(-2).applyTo(font: .primary)
        textField.isEnabled = enable
        textField.keyboardType = keyBoardType
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.returnKeyType = .done
        configureSubtitleLabel()

        self.horizontalPadding = self.titleTextField.convert(self.textField.bounds, to: self).origin.x
    }

    private func configureTitle() {
        if let title = self.title {
            if enable {
                // swiftlint:disable:next empty_string
                if placeholder.isEmpty || textField.text != "" {
                    titleTextField.isHidden = false
                    titleTextField.attributedText = title.dkAttributedString().font(dkFont: .primary, style: .normalText).color(DKUIColors.complementaryFontColor).build()
                } else {
                    titleTextField.isHidden = true
                }
            } else {
                titleTextField.isHidden = false
                titleTextField.attributedText = title.dkAttributedString().font(dkFont: .primary, style: .normalText).color(DKUIColors.complementaryFontColor).build()
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
            subtitle.attributedText = nil
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
            self.subtitle.isHidden = false
            self.subtitle.attributedText = textError.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.criticalColor).build()
        } else {
            self.configureUnderline(isError: false)
            self.configureSubtitleLabel()
        }
    }

    @IBAction func didStartEditing(_ sender: Any) {
        configureTitle()
        titleTextField.textColor = DKUIColors.secondaryColor.color
        underline.backgroundColor = DKUIColors.secondaryColor.color
    }

    @IBAction func didEndEditing(_ sender: Any) {
        configureTitle()
        titleTextField.textColor = DKUIColors.complementaryFontColor.color
        underline.backgroundColor = DKUIColors.complementaryFontColor.color
        self.delegate?.userDidEndEditing(textField: self)
    }
}

extension DKTextField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: true)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)

        UIView.animate(withDuration: moveDuration) {
            if let targetView = self.target {
                targetView.frame = targetView.frame.offsetBy(dx: 0, dy: movement)
            }
        }
    }
}
