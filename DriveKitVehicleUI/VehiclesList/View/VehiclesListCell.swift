//
//  VehiclesListCell.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBVehicleAccess
import DriveKitTripAnalysis
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
    
    private var viewModel: VehiclesListViewModel!
    private var pos: Int!
    private weak var vehicleListDelegate : VehiclesListDelegate?
    private weak var parentView: UIViewController? = nil
    
    func configure(viewModel: VehiclesListViewModel, pos: Int, parentView: UIViewController) {
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
        autoStartLabel.attributedText = "dk_vehicle_detection_mode_title".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        autoStartSelectView.backgroundColor = DKUIColors.neutralColor.color
        autoStartDelimiter.backgroundColor = DKUIColors.neutralColor.color
        autoStartSelectImage.image = DKImages.arrowDown.image
        autoStartSelectImage.tintColor = DKUIColors.complementaryFontColor.color
        if DriveKitVehicleUI.shared.detectionModes.count <= 1 {
            autoStartView.isHidden = true
        }
        autoStartSelection.attributedText = viewModel.detectionModeTitle(pos: pos).dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        descriptionLabel.attributedText = viewModel.detectionModeDescription(pos: pos)
        if let buttonText = viewModel.detectionModeConfigureButton(pos: pos){
            configureButton.isHidden = false
            let buttonTitle = buttonText.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.secondaryColor).build()
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
        let vehicleActions : [VehicleAction] = viewModel.vehicleActions
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
        switch viewModel.vehicleDetectionMode(pos: pos) {
        case .beacon:
            if let parent = parentView, viewModel.vehicleHasBeacon(pos: pos) {
                if let alert = DKDetectionMode.beacon.detectionModeConfigureClicked(pos: pos, viewModel: viewModel, parentView: parent) {
                    viewModel.delegate?.showAlert(alert)
                }
            }else{
                self.newBeacon()
            }
        case .bluetooth:
            if let parent = parentView, viewModel.vehicleHasBluetooth(pos: pos) {
                if let alert = DKDetectionMode.bluetooth.detectionModeConfigureClicked(pos: pos, viewModel: viewModel, parentView: parent) {
                    viewModel.delegate?.showAlert(alert)
                }
            } else {
                self.newBluetooth()
            }
            self.bluetoothActionsAlert()
        case .disabled, .gps:
            return
        }
    }
    
    private func newBeacon() {
        if let parent = parentView {
            let viewController = ConnectBeaconVC(vehicle: self.viewModel.vehicles[pos], parentView: parent)
            self.viewModel.delegate?.pushViewController(viewController, animated: true)
        }
    }
    
    private func newBluetooth(){
        if let parent = parentView {
            let viewController = ConnectBluetoothVC(vehicle: self.viewModel.vehicles[pos], parentView: parent)
             self.viewModel.delegate?.pushViewController(viewController, animated: true)
        }
    }
    
    func bluetoothActionsAlert() {
        let alert = UIAlertController(title: "dk_vehicle_configure_bluetooth_title".dkVehicleLocalized(), message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: DKCommonLocalizable.delete.text(), style: .default , handler: {  _ in
            self.viewModel.listView.confirmDeleteAlert(type: .bluetooth, vehicle: self.viewModel.vehicle)
        })
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(cancelAction)
        viewModel.listView.present(alert, animated: true)
    }
    
    
}
