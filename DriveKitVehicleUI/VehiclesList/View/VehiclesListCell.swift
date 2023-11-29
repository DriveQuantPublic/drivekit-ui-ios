// swiftlint:disable no_magic_numbers
//
//  VehiclesListCell.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBVehicleAccessModule
import DriveKitTripAnalysisModule
import DriveKitCommonUI

class VehiclesListCell: UITableViewCell {
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var vehicleTitle: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var vehicleSubtitle: UILabel!
    
    @IBOutlet weak var autoStartDelimiter: UIView!
    @IBOutlet weak var autoStartView: UIView!
    @IBOutlet weak var autoStartLabel: UILabel!
    @IBOutlet weak var autoStartSelectView: UIView!
    @IBOutlet weak var autoStartSelection: UILabel!
    @IBOutlet weak var autoStartSelectImage: UIImageView!
    
    @IBOutlet weak var descriptionImageView: UIView!
    @IBOutlet weak var descriptionImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var configureButton: UIButton!
    
    private var viewModel: DKVehiclesListViewModel!
    private var pos: Int!
    private weak var vehicleListDelegate: VehiclesListDelegate?
    private weak var parentView: UIViewController?
    
    func configure(viewModel: DKVehiclesListViewModel, pos: Int, parentView: UIViewController) {
        self.viewModel = viewModel
        self.pos = pos
        self.parentView = parentView
        self.vehicleListDelegate = self.viewModel.delegate
        vehicleTitle.attributedText = viewModel.vehicleName(pos: pos).dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).build()
        vehicleSubtitle.attributedText = viewModel.vehicleModel(pos: pos).dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        let editImage = DKImages.dots.image
        editButton.setImage(editImage, for: .normal)
        editButton.tintColor = DKUIColors.secondaryColor.color
        self.configureAutoStart()
        self.configureAutoStartSelection()
    }
    
    private func configureAutoStart() {
        autoStartLabel.attributedText = "dk_vehicle_detection_mode_title"
            .dkVehicleLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: DKStyle(size: 14, traits: .traitBold))
            .color(.mainFontColor)
            .build()
        autoStartSelectView.backgroundColor = DKUIColors.neutralColor.color
        autoStartDelimiter.backgroundColor = DKUIColors.neutralColor.color
        autoStartSelectImage.image = DKImages.arrowDown.image
        autoStartSelectImage.tintColor = DKUIColors.complementaryFontColor.color
        if DriveKitVehicleUI.shared.detectionModes.count <= 1 {
            autoStartView.isHidden = true
        }
        autoStartSelection.attributedText = viewModel
            .detectionModeTitle(pos: pos)
            .dkAttributedString()
            .font(dkFont: .primary, style: DKStyle(size: 13, traits: .traitBold))
            .color(.mainFontColor)
            .build()
        descriptionLabel.attributedText = viewModel.detectionModeDescription(pos: pos)
        if let buttonText = viewModel.detectionModeConfigureButton(pos: pos) {
            configureButton.isHidden = false
            let buttonTitle = buttonText.dkAttributedString().font(dkFont: .primary, style: .button).color(.secondaryColor).build()
            configureButton.setAttributedTitle(buttonTitle, for: .normal)
        } else {
            configureButton.isHidden = true
        }
        if let descImage = viewModel.descriptionImage(pos: pos) {
            descriptionImageView.isHidden = false
            descriptionImage.image = descImage
            descriptionImage.tintColor = DKUIColors.criticalColor.color
        } else {
            descriptionImageView.isHidden = true
        }
    }
    
    private func configureAutoStartSelection() {
        if !autoStartView.isHidden {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(autoStartAlert(_:)))
            autoStartSelectView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBAction func didSelectEditButton(_ sender: Any) {
        let vehicleActions: [DKVehicleActionItem] = viewModel.vehicleActions(pos: pos)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for vehicleAction in vehicleActions {
            alert.addAction(vehicleAction.alertAction(pos: pos, viewModel: self.viewModel))
        }
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(cancelAction)
        viewModel.delegate?.showAlert(alert)
    }

    @objc private func autoStartAlert(_ sender: UITapGestureRecognizer) {
        let detectionModes: [DKDetectionMode] = DriveKitVehicleUI.shared.detectionModes
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for detectionMode in detectionModes {
            alert.addAction(detectionMode.detectionModeSelected(pos: pos, viewModel: viewModel))
        }
        alert.addAction(UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel))
        viewModel.delegate?.showAlert(alert)
    }
    
    @IBAction func didSelectConfigureButton(_ sender: Any) {
        if let parent = parentView {
             viewModel.vehicleDetectionMode(pos: pos).detectionModeConfigureClicked(pos: pos, viewModel: viewModel, parentView: parent)
        }
    }
}
