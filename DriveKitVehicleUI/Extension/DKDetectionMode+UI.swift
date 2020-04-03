//
//  DKDetectionMode+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 02/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccess
import DriveKitCommonUI

extension DKDetectionMode {
    
    var title: String {
        switch self {
        case .disabled:
            return "dk_detection_mode_disabled_title".dkVehicleLocalized()
        case .gps :
            return "dk_detection_mode_gps_title".dkVehicleLocalized()
        case .beacon:
            return "dk_detection_mode_beacon_title".dkVehicleLocalized()
        case .bluetooth:
            return "dk_detection_mode_bluetooth_title".dkVehicleLocalized()
        }
    }
    
    func detectionModeSelected(pos: Int, viewModel: VehiclesListViewModel) -> UIAlertAction {
        var completionHandler : ((UIAlertAction) -> Void)? = nil
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
                    }else {
                        viewModel.updateDetectionMode(pos: pos, detectionMode: self)
                    }
                }
            }
        }
        return UIAlertAction(title: self.title, style: .default, handler: completionHandler)
    }
    
    func detectionModeConfigureClicked(pos: Int, viewModel: VehiclesListViewModel, parentView: UIViewController) -> UIAlertController? {
        switch self {
        case .beacon:
            return beaconAlertController(vehicle: viewModel.vehicles[pos], viewModel: viewModel, parentView: parentView)
        case .bluetooth:
            return bluetoothAlertController(vehicle: viewModel.vehicles[pos])
        case .gps, .disabled:
            return nil
        }
    }
    
    private func gpsAlertConfrimation(vehicle: DKVehicle, previousVehicle: DKVehicle, completion : @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: "", message: "dk_vehicle_gps_already_exists_confirm".dkVehicleLocalized(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: DKCommonLocalizable.confirm.text(), style: .default , handler: { _ in
            completion()
        })
        alert.addAction(yesAction)
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(cancelAction)
        return alert
    }
    
    private func beaconAlertController(vehicle: DKVehicle, viewModel: VehiclesListViewModel, parentView: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: "dk_vehicle_configure_beacon_title".dkVehicleLocalized(), message: nil, preferredStyle: .actionSheet)
        let checkAction = UIAlertAction(title: "dk_beacon_verify".dkVehicleLocalized(), style: .default , handler: {  _ in
            if let beacon = vehicle.beacon {
                let beaconViewModel = BeaconViewModel(vehicle: vehicle ,scanType: .verify, beacon: beacon)
                let beaconScannerVC = BeaconScannerVC(viewModel: beaconViewModel, step: .initial, parentView: parentView)
                viewModel.delegate?.pushViewController(beaconScannerVC, animated: true)
            }
        })
        alert.addAction(checkAction)
        
        let replaceAction = UIAlertAction(title: "dk_vehicle_replace".dkVehicleLocalized(), style: .default , handler: {  _ in
            let viewController = ConnectBeaconVC(vehicle: vehicle, parentView: parentView)
            viewModel.delegate?.pushViewController(viewController, animated: true)
        })
        alert.addAction(replaceAction)
        
        if DriveKitVehicleUI.shared.canRemoveBeacon {
            let deleteAction = UIAlertAction(title: DKCommonLocalizable.delete.text(), style: .default , handler: {  _ in
                self.viewModel.listView.confirmDeleteAlert(type: .beacon, vehicle: self.viewModel.vehicle)
            })
            alert.addAction(deleteAction)
        }
        
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(cancelAction)
        return alert
    }
    
    private bluetoothAlertController(vehicle: DKVehicle) -> UIAlertController {
        
    }
}
