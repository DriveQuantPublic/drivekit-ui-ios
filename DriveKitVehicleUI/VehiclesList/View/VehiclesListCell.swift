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
    
    var viewModel: VehiclesListCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(viewModel: VehiclesListCellViewModel) {
        self.viewModel = viewModel
        vehicleTitle.attributedText = viewModel.getDisplayName().dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).build()
        vehicleSubtitle.attributedText = viewModel.getSubtitle()?.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        let editImage = DKImages.dots.image
        editButton.setImage(editImage, for: .normal)
        editButton.tintColor = DKUIColors.secondaryColor.color
        self.configureAutoStart()
        self.configureAutoStartSelection()
    }
    
    func configureAutoStart() {
        autoStartLabel.attributedText = "dk_vehicle_detection_mode_title".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        autoStartSelectView.backgroundColor = DKUIColors.neutralColor.color
        autoStartDelimiter.backgroundColor = DKUIColors.neutralColor.color
        autoStartSelectImage.image = DKImages.arrowDown.image
        autoStartSelectImage.tintColor = DKUIColors.complementaryFontColor.color
        if DriveKitVehicleUI.shared.detectionModes.count <= 1 {
            autoStartView.isHidden = true
        }
        autoStartSelection.attributedText = viewModel.autoStart.title.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        descriptionLabel.attributedText = viewModel.autoStart.getDescription(vehicle: self.viewModel.vehicle)
        if let buttonText = viewModel.autoStart.buttonTitle {
            configureButton.isHidden = false
            let buttonTitle = buttonText.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.secondaryColor).build()
            configureButton.setAttributedTitle(buttonTitle, for: .normal)
        } else {
            configureButton.isHidden = true
        }
        
        if let descImage = viewModel.autoStart.descriptionImage {
            descriptionImageView.isHidden = false
            descriptionImage.image = descImage
            descriptionImage.tintColor = DKUIColors.criticalColor.color
        } else {
            descriptionImageView.isHidden = true
        }
    }
    
    func configureAutoStartSelection() {
        if !autoStartView.isHidden {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(autoStartAlert(_:)))
            autoStartSelectView.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func autoStartAlert(_ sender: UITapGestureRecognizer) {
        let detectionModes: [DKDetectionMode] = DriveKitVehicleUI.shared.detectionModes
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for detectionMode in detectionModes {
            let action = detectionMode.alertAction(completionHandler: {  _ in
                self.viewModel.updateDetectionMode(detectionMode: detectionMode)
            })
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel))
        
        viewModel.listView.present(alert, animated: true)
    }
    
    @IBAction func didSelectEditButton(_ sender: Any) {
        editVehicleAlert()
    }
    
    @IBAction func didSelectConfigureButton(_ sender: Any) {
        switch viewModel.autoStart {
        case .beacon:
            self.beaconActionsAlert()
        case .beacon_disabled:
            self.newBeacon()
        case .bluetooth:
            self.bluetoothActionsAlert()
        case .bluetooth_disabled:
            self.newBluetooth()
        default:
            return
        }
    }
    
    func editVehicleAlert(){
        let vehicleOptions: [VehicleAction] = viewModel.computeVehicleOptions()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for vehicleOption in vehicleOptions {
            switch vehicleOption {
            case .delete:
                if viewModel.vehicles.count > 1 {
                    let deleteVehicle = vehicleOption.alertAction(completionHandler: {  _ in
                        self.viewModel.listView.confirmDeleteAlert(type: .vehicle, vehicle: self.viewModel.vehicle)
                    })
                    alert.addAction(deleteVehicle)
                }
            case .replace:
                let replaceVehicle = vehicleOption.alertAction(completionHandler: {  _ in
                    _ = VehiclePickerCoordinator(parentView: self.viewModel.listView, detectionMode: self.viewModel.autoStart.detectionModeValue ?? .disabled, vehicle: self.viewModel.vehicle)
                })
                alert.addAction(replaceVehicle)
            case .show:
                let showVehicle = vehicleOption.alertAction(completionHandler: {  _ in
                    // TODO : VehicleDetail
                    let detailVC = VehicleDetailVC(viewModel: VehicleDetailViewModel(vehicle: self.viewModel.vehicle, vehicleDisplayName: self.viewModel.getDisplayName()))
                    self.viewModel.listView.navigationController?.pushViewController(detailVC, animated: true)
                })
                alert.addAction(showVehicle)
            case .rename:
                let renameVehicle = vehicleOption.alertAction(completionHandler: {  _ in
                    self.viewModel.listView.editVehicleNameAlert(vehicle: self.viewModel.vehicle)
                })
                alert.addAction(renameVehicle)
            }
        }
        
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(cancelAction)

        viewModel.listView.present(alert, animated: true)
    }
    
    func beaconActionsAlert() {
        let alert = UIAlertController(title: "dk_vehicle_configure_beacon_title".dkVehicleLocalized(), message: nil, preferredStyle: .actionSheet)
        let checkAction = UIAlertAction(title: "verify".dkVehicleLocalized(), style: .default , handler: {  _ in
            if let beacon = self.viewModel.vehicle.beacon {
                let beaconViewModel = BeaconViewModel(vehicle: self.viewModel.vehicle ,scanType: .verify, beacon: beacon)
                let beaconScannerVC = BeaconScannerVC(viewModel: beaconViewModel, step: .initial, parentView: self.viewModel.listView)
                self.viewModel.listView.navigationController?.pushViewController(beaconScannerVC, animated: true)
            }
        })
        alert.addAction(checkAction)

        let replaceAction = UIAlertAction(title: "replace".dkVehicleLocalized(), style: .default , handler: {  _ in
            let viewController = ConnectBeaconVC(vehicle: self.viewModel.vehicle, parentView: self.viewModel.listView)
            self.viewModel.listView.navigationController?.pushViewController(viewController, animated: true)
        })
        alert.addAction(replaceAction)

        let deleteAction = UIAlertAction(title: DKCommonLocalizable.delete.text(), style: .default , handler: {  _ in
            self.viewModel.listView.confirmDeleteAlert(type: .beacon, vehicle: self.viewModel.vehicle)
        })
        alert.addAction(deleteAction)

        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(cancelAction)

        viewModel.listView.present(alert, animated: true)
        
    }
    
    func newBeacon() {
        let viewController = ConnectBeaconVC(vehicle: self.viewModel.vehicle, parentView: self.viewModel.listView)
        self.viewModel.listView.navigationController?.pushViewController(viewController, animated: true)
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
    
    func newBluetooth(){
        let viewController = ConnectBluetoothVC(vehicle: self.viewModel.vehicle, parentView: self.viewModel.listView)
        self.viewModel.listView.navigationController?.pushViewController(viewController, animated: true)
    }
}
