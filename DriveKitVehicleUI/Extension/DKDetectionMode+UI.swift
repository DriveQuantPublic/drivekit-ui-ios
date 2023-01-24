// swiftlint:disable all
//
//  DKDetectionMode+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 02/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitDBVehicleAccessModule
import DriveKitCommonUI

extension DKDetectionMode {
    
    var title: String {
        switch self {
        case .disabled:
            return "dk_detection_mode_disabled_title".dkVehicleLocalized()
        case .gps: 
            return "dk_detection_mode_gps_title".dkVehicleLocalized()
        case .beacon:
            return "dk_detection_mode_beacon_title".dkVehicleLocalized()
        case .bluetooth:
            return "dk_detection_mode_bluetooth_title".dkVehicleLocalized()
        @unknown default:
            return ""
        }
    }
    
    func detectionModeSelected(pos: Int, viewModel: DKVehiclesListViewModel) -> UIAlertAction {
        var completionHandler: ((UIAlertAction) -> Void)?
        if viewModel.vehicleDetectionMode(pos: pos) != self {
            switch self {
            case .disabled, .beacon, .bluetooth:
                completionHandler = { _ in
                    viewModel.updateDetectionMode(pos: pos, detectionMode: self)
                }
            case .gps:
                completionHandler = { _ in
                    if let gpsVehicle = viewModel.gpsVehicle(), gpsVehicle.vehicleId != viewModel.vehicles[pos].vehicleId {
                        viewModel.delegate?.showAlert(self.gpsAlertConfrimation(vehicle: viewModel.vehicles[pos], previousVehicle: gpsVehicle, completion: {
                            viewModel.updateDetectionMode(pos: pos, detectionMode: self, forceGPSUpdate: true)
                        }))
                    } else {
                        viewModel.updateDetectionMode(pos: pos, detectionMode: self)
                    }
                }
            @unknown default:
                break
            }
        }
        return UIAlertAction(title: self.title, style: .default, handler: completionHandler)
    }
    
    func detectionModeConfigureClicked(pos: Int, viewModel: DKVehiclesListViewModel, parentView: UIViewController) {
        switch self {
        case .beacon:
            if viewModel.vehicleHasBeacon(pos: pos) {
                let alert = beaconAlertController(pos: pos, viewModel: viewModel, parentView: parentView)
                viewModel.delegate?.showAlert(alert)
            } else {
                self.newBeacon(pos: pos, viewModel: viewModel, parentView: parentView)
            }
        case .bluetooth:
            if viewModel.vehicleHasBluetooth(pos: pos) {
                let alert = bluetoothAlertController(pos: pos, viewModel: viewModel)
                viewModel.delegate?.showAlert(alert)
            } else {
                self.newBluetooth(pos: pos, viewModel: viewModel, parentView: parentView)
            }
        case .disabled, .gps:
            return
        @unknown default:
            return
        }
    }
    
    private func gpsAlertConfrimation(vehicle: DKVehicle, previousVehicle: DKVehicle, completion: @escaping () -> Void) -> UIAlertController {
        let message = String(format: "dk_vehicle_gps_already_exists_confirm".dkVehicleLocalized(), DKDetectionMode.gps.title, vehicle.computeName(), previousVehicle.computeName(), DKDetectionMode.disabled.title)
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: DKCommonLocalizable.confirm.text(), style: .default, handler: { _ in
            completion()
        })
        alert.addAction(yesAction)
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(cancelAction)
        return alert
    }
    
    private func beaconAlertController(pos: Int, viewModel: DKVehiclesListViewModel, parentView: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: "dk_vehicle_configure_beacon_title".dkVehicleLocalized(), message: nil, preferredStyle: .actionSheet)
        let checkAction = UIAlertAction(title: "dk_beacon_verify".dkVehicleLocalized(), style: .default, handler: {  _ in
            if let beacon = viewModel.vehicles[pos].beacon {
                let beaconViewModel = BeaconViewModel(vehicle: viewModel.vehicles[pos], scanType: .verify, beacon: beacon)
                let beaconScannerVC = BeaconScannerVC(viewModel: beaconViewModel, step: .initial, parentView: parentView)
                viewModel.delegate?.pushViewController(beaconScannerVC, animated: true)
            }
        })
        alert.addAction(checkAction)
        
        let replaceAction = UIAlertAction(title: "dk_vehicle_replace".dkVehicleLocalized(), style: .default, handler: {  _ in
            let viewController = ConnectBeaconVC(vehicle: viewModel.vehicles[pos], parentView: parentView)
            viewModel.delegate?.pushViewController(viewController, animated: true)
        })
        alert.addAction(replaceAction)
        
        if DriveKitVehicleUI.shared.canRemoveBeacon {
            let deleteAction = UIAlertAction(title: DKCommonLocalizable.delete.text(), style: .default, handler: {  _ in
                viewModel.deleteBeacon(pos: pos)
            })
            alert.addAction(deleteAction)
        }
        
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(cancelAction)
        return alert
    }
    
    private func bluetoothAlertController(pos: Int, viewModel: DKVehiclesListViewModel) -> UIAlertController {
        let alert = UIAlertController(title: "dk_vehicle_configure_bluetooth_title".dkVehicleLocalized(), message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: DKCommonLocalizable.delete.text(), style: .default, handler: {  _ in
            viewModel.deleteBluetooth(pos: pos)
        })
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(cancelAction)
        return alert
    }
    
    private func newBeacon(pos: Int, viewModel: DKVehiclesListViewModel, parentView: UIViewController) {
        let viewController = ConnectBeaconVC(vehicle: viewModel.vehicles[pos], parentView: parentView)
        viewModel.delegate?.pushViewController(viewController, animated: true)
    }
    
    private func newBluetooth(pos: Int, viewModel: DKVehiclesListViewModel, parentView: UIViewController) {
        let viewController = ConnectBluetoothVC(vehicle: viewModel.vehicles[pos])
        viewModel.delegate?.pushViewController(viewController, animated: true)
    }
}
