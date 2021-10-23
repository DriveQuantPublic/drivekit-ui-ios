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
    private var distanceUpdated: Double = 0
    private var defaultDistance: Double = 0

    func configure(type: ReferenceCellType, value: String?, vehicle: DKVehicle, history: DKVehicleOdometerHistory?) {
        self.defaultDistance = history?.distance ?? 0
        self.textField.isHidden = true
        self.textField.font = DKStyles.smallText.style.applyTo(font: DKUIFonts.primary)
        self.textField.textColor = DKUIColors.complementaryFontColor.color
        self.label.isHidden = true
        self.label.font = DKStyles.smallText.style.applyTo(font: DKUIFonts.primary)
        self.label.textColor = DKUIColors.complementaryFontColor.color
        self.textFieldSubtitle.isHidden = true
        switch type {
            case .distance:
                self.textField.keyboardType = .numberPad
                self.textField.isHidden = false
                self.textField.placeholder = type.placeholder
                if let text = value {
                    if text.isEmpty {
                        self.defaultDistance = 0
                    }
                    self.textField.text = text
                }
                self.cellImage.image = type.image?.withRenderingMode(.alwaysTemplate)
                self.cellImage.tintColor = .black
            case .date:
                self.label.isHidden = false
                if let date = DateFormatter.dateFormatter.date(from: value ?? "") {
                    self.label.text = date.format(pattern: .fullDate)
                } else {
                    self.label.text = Date().format(pattern: .fullDate)
                }
                self.cellImage.image = type.image?.withRenderingMode(.alwaysTemplate)
                self.cellImage.tintColor = .black
            case .vehicle(_):
                self.label.isHidden = false
                self.cellImage.layer.cornerRadius = self.cellImage.frame.height/2
                self.label.text = value
                self.cellImage.image = type.image
                self.cellImage.tintColor = .none
        }
    }

    @IBAction func didEndEditing(_ sender: Any) {
        editingChanged(sender)
        if let text = textField.text {
            textField.text = text + " " + DKCommonLocalizable.unitKilometer.text()
        }
    }

    @IBAction func editingChanged(_ sender: Any) {
        if let text = self.textField.text, let value = Double(text) {
            self.distanceUpdated = value
            if value >= 0 && value <= 1000000 {
                self.textFieldSubtitle.isHidden = true
                self.didUpdateDistanceField(distance: value)
            } else {
                #warning("Manage new string")
                subtitleError(text: "TODO-error_odometer".dkVehicleLocalized())
            }
        } else {
            #warning("Manage new string")
            subtitleError(text: "TODO-error_numeric".dkVehicleLocalized())
        }
    }

    func subtitleError(text: String) {
        self.textFieldSubtitle.isHidden = false
        self.textFieldSubtitle.attributedText = text.dkAttributedString().font(dkFont: .primary, style: DKStyles.smallText.withSizeDelta(-3)).color(.warningColor).build()
    }

    func didUpdateDistanceField(distance: Double) {
        self.delegate?.didUpdateDistanceField(distance: distance, sender: self)
    }

    func enableTextField(_ enable: Bool) {
        self.textField.isEnabled = enable
    }

    @IBAction func didEnterDistanceField(_ sender: Any) {
        if self.distanceUpdated > 0 {
            self.textField.text = self.distanceUpdated.formatKilometerDistance(minDistanceToRemoveFractions: 0)
        } else {
            if self.defaultDistance == 0 {
                self.textField.text = ""
            } else {
                self.textField.text = self.defaultDistance.formatKilometerDistance(minDistanceToRemoveFractions: 0)
            }
        }
    }
}
