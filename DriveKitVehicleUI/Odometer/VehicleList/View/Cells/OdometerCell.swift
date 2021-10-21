//
//  OdometerCell.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 05/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBVehicleAccessModule

protocol OdometerCellDelegate: AnyObject {
    func didTouchActionButton(vehicle: DKVehicle, index: IndexPath, sender: OdometerCell)
}

final class OdometerCell: UITableViewCell, Nibable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var subtitleValue: UILabel!
    @IBOutlet private weak var actionButton: UIButton!

    weak var delegate: OdometerCellDelegate?
    private var viewModel: OdometerCellViewModel?

    func configure(viewModel: OdometerCellViewModel) {
        self.viewModel = viewModel
        self.configureTitle()
        self.configureOptionButton()
        self.configureContent()
    }

    func configureTitle() {
        self.titleLabel.attributedText = self.viewModel?.type.title.dkAttributedString().color(.mainFontColor).font(dkFont: .primary, style: .normalText).build()
    }

    func configureOptionButton() {
        if self.viewModel?.optionButton ?? true {
            self.actionButton.isHidden = false
            self.actionButton.setImage(DKImages.dots.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.actionButton.tintColor = DKUIColors.secondaryColor.color
        } else if self.viewModel?.alertButton ?? false {
            self.actionButton.isHidden = false
            self.actionButton.setImage(DKImages.info.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.actionButton.tintColor = DKUIColors.secondaryColor.color
        } else {
            self.actionButton.isHidden = true
        }
    }

    func configureContent() {
        self.valueLabel.attributedText = self.viewModel?.value.dkAttributedString().color(.complementaryFontColor).font(dkFont: .primary, style: DKStyle(size: 34, traits: .traitBold)).build()
        self.subtitleValue.attributedText = self.viewModel?.subtitle.dkAttributedString().color(.complementaryFontColor).font(dkFont: .primary, style: .smallText).build()
    }
    
    @IBAction func touchActionButton(_ sender: Any) {
        if let vehicle = self.viewModel?.vehicle {
            if self.viewModel?.optionButton ?? true {
                self.delegate?.didTouchActionButton(vehicle: vehicle, index: self.viewModel?.index ?? IndexPath(row: 0, section: 0), sender: self)
            } else if self.viewModel?.alertButton ?? false {
                let alert = UIAlertController(title: self.viewModel?.alertTitle, message: self.viewModel?.alertMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel))
                self.window?.rootViewController?.present(alert, animated: true)
            }
        }
    }
}
