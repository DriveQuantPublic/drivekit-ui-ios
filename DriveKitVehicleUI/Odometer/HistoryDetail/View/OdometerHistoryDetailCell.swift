// swiftlint:disable no_magic_numbers
//
//  OdometerHistoryDetailCell.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 09/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBVehicleAccessModule

protocol OdometerHistoryDelegate: AnyObject {
    func didUpdateDistanceField(distance: Double, sender: OdometerHistoryDetailCell)
}

final class OdometerHistoryDetailCell: UITableViewCell, Nibable {
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var textFieldSubtitle: UILabel!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var cellImage: UIImageView!

    weak var delegate: OdometerHistoryDelegate?
    private var viewModel: OdometerHistoryDetailCellViewModel?
    private let textColor = UIColor(hex: 0x616161)

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hex: 0xfafafa)
        self.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        self.clipsToBounds = true

        self.textField.font = DKStyles.smallText.style.applyTo(font: DKUIFonts.primary)
        self.textField.textColor = self.textColor
        self.textField.keyboardType = .numberPad
        self.textFieldSubtitle.isHidden = true
        self.label.font = DKStyles.smallText.style.applyTo(font: DKUIFonts.primary)
        self.label.textColor = self.textColor
    }

    func configure(viewModel: OdometerHistoryDetailCellViewModel) {
        self.viewModel = viewModel

        let value = viewModel.getValue()
        self.selectionStyle = viewModel.getSelectionStyle()
        if viewModel.showTextField() {
            self.textField.isEnabled = viewModel.isEditable
            self.textField.isHidden = false
            self.textField.placeholder = viewModel.getPlaceHolder()
            self.textField.text = value
            if viewModel.isEditable {
                self.textField.textColor = DKUIColors.complementaryFontColor.color
            }
        } else {
            self.textField.isHidden = true
        }
        if viewModel.showLabel() {
            self.label.isHidden = false
            self.label.text = value
        } else {
            self.label.isHidden = true
        }
        self.cellImage.image = viewModel.getImage()
        self.cellImage.tintColor = viewModel.getImageTintColor()
        self.cellImage.layer.cornerRadius = viewModel.hasCornerRadius() ? self.cellImage.frame.height / 2 : 0
    }

    @IBAction private func didEndEditing(_ sender: Any) {
        editingChanged(sender)
        if let text = textField.text {
            textField.text = text + " " + DKCommonLocalizable.unitKilometer.text()
        }
    }

    @IBAction private func editingChanged(_ sender: Any) {
        if let text = self.textField.text, let value = Double(text) {
            self.viewModel?.newDistance = value
            self.didUpdateDistanceField(distance: value)
            if value >= 0 && value < 1_000_000 {
                self.textFieldSubtitle.isHidden = true
            } else {
                subtitleError(text: "dk_vehicle_odometer_history_error".dkVehicleLocalized())
            }
        } else {
            subtitleError(text: "dk_vehicle_odometer_error_numeric".dkVehicleLocalized())
        }
    }

    private func subtitleError(text: String) {
        self.textFieldSubtitle.isHidden = false
        self.textFieldSubtitle.attributedText = text.dkAttributedString().font(dkFont: .primary, style: DKStyles.smallText.withSizeDelta(-3)).color(.warningColor).build()
    }

    private func didUpdateDistanceField(distance: Double) {
        self.textField.textColor = self.textColor
        self.delegate?.didUpdateDistanceField(distance: distance, sender: self)
    }

    @IBAction private func didEnterDistanceField(_ sender: Any) {
        if let newDistance = self.viewModel?.newDistance, newDistance > 0 {
            self.textField.text = newDistance.formatKilometerDistance(appendingUnit: false, minDistanceToRemoveFractions: 0)
        } else {
            if let initialDistance = self.viewModel?.initialDistance, initialDistance > 0 {
                self.textField.text = initialDistance.formatKilometerDistance(appendingUnit: false, minDistanceToRemoveFractions: 0)
            } else {
                self.textField.text = ""
            }
        }
    }
}
