//
//  VehicleListViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 05/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitVehicleModule
import DriveKitDBVehicleAccessModule
import DriveKitCommonUI

public protocol VehiclesListDelegate: AnyObject {
    func onVehiclesAvailable()
    func didUpdateVehicle()
    func didReceiveErrorFromService()
    func showAlert(_ alertController: UIAlertController)
    func showLoader()
    func hideLoader()
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func showVehiclePicker(vehicle: DKVehicle?)
}

public class DKVehiclesListViewModel {
    public private(set) var vehicles: [DKVehicle] = []
    public weak var delegate: VehiclesListDelegate?
    private(set) var updating: Bool = false

    init() {
        self.vehicles = DriveKitDBVehicleAccess.shared.findVehiclesOrderByNameAsc().execute().sortByDisplayNames()
    }
    
    func fetchVehicles() {
        self.updating = true
        DriveKitVehicle.shared.getVehiclesOrderByNameAsc { [weak self] _, vehicles in
            DispatchQueue.main.async {
                if let self = self {
                    self.updating = false
                    self.vehicles = vehicles.sortByDisplayNames()
                    self.delegate?.onVehiclesAvailable()
                }
            }
        }
    }
    
    var vehiclesCount: Int {
        return vehicles.count
    }
    
    func vehicleActions(pos: Int) -> [DKVehicleActionItem] {
        var actions = DriveKitVehicleUI.shared.vehicleActions
        if vehiclesCount <= 1 {
            removeAction(.delete, in: &actions)
        }
        if !DriveKitVehicleUI.shared.hasOdometer {
            removeAction(.odometer, in: &actions)
        }
        actions.removeAll { !$0.isDisplayable(vehicle: vehicles[pos]) }
        return actions
    }

    private func removeAction(_ actionToRemove: DKVehicleAction, in actions: inout [DKVehicleActionItem]) {
        actions.removeAll { actionItem in
            if let action = actionItem as? DKVehicleAction {
                return action == actionToRemove
            } else {
                return false
            }
        }
    }
    
    var detectionModes: [DKDetectionMode] {
        return DriveKitVehicleUI.shared.detectionModes
    }
    
    func vehicleDetectionMode(pos: Int) -> DKDetectionMode {
        return vehicles[pos].detectionMode ?? .disabled
    }
    
    func vehicleHasBeacon(pos: Int) -> Bool {
        return vehicles[pos].beacon != nil
    }
    
    func vehicleHasBluetooth(pos: Int) -> Bool {
        return vehicles[pos].bluetooth != nil
    }
    
    func vehicleName(pos: Int) -> String {
        return vehicles[pos].getDisplayName(position: pos)
    }
    
    func vehicleModel(pos: Int) -> String {
        var model = ""
        let vehicle = vehicles[pos]
        if vehicle.liteConfig {
            if vehicle.name != vehicle.getLiteConfigCategoryName() {
                model = vehicle.getLiteConfigCategoryName()
            }
        } else {
            model = vehicle.getModel()
        }
        return model
    }
    
    func renameVehicle(pos: Int) {
        let alert = UIAlertController(title: "dk_vehicle_rename_title".dkVehicleLocalized(),
                                      message: "dk_vehicle_rename_description".dkVehicleLocalized(),
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = UIKeyboardType.default
            textField.text = self.vehicleName(pos: pos)
        }
        let ok = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default) { [weak alert] _ in
            guard let alert = alert, let textField = alert.textFields?.first, let newValue = textField.text else { return }
            self.renameVehicle(vehicle: self.vehicles[pos], name: newValue)
        }
        alert.addAction(ok)
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(cancelAction)
        self.delegate?.showAlert(alert)
    }
    
    func deleteVehicle(pos: Int) {
        let vehicleName = self.vehicleName(pos: pos)
        let title = String(format: "dk_vehicle_delete_confirm".dkVehicleLocalized(), vehicleName)
        self.deleteAlert(title: title) {  _ in
            self.deleteVehicle(vehicle: self.vehicles[pos])
        }
    }
    
    func deleteBeacon(pos: Int) {
        let vehicleName = self.vehicleName(pos: pos)
        let beaconCode = vehicles[pos].beacon?.uniqueId ?? ""
        let title = String(format: "dk_vehicle_beacon_deactivate_alert".dkVehicleLocalized(), beaconCode, vehicleName)
        self.deleteAlert(title: title) { _ in
            self.deleteBeacon(vehicle: self.vehicles[pos])
        }
    }
    
    func deleteBluetooth(pos: Int) {
        let vehicleName = self.vehicleName(pos: pos)
        let bluetoothName = vehicles[pos].bluetooth?.name ?? ""
        let title = String(format: "dk_vehicle_bluetooth_deactivate_alert".dkVehicleLocalized(), bluetoothName, vehicleName)
        self.deleteAlert(title: title) { _ in
            self.deleteBluetooth(vehicle: self.vehicles[pos])
        }
    }
    
    private func deleteAlert(title: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default, handler: handler)
        alert.addAction(yesAction)
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(cancelAction)
        self.delegate?.showAlert(alert)
    }
    
    func detectionModeTitle(pos: Int) -> String {
        return vehicles[pos].detectionMode?.title ?? ""
    }
    
    func detectionModeDescription(pos: Int) -> NSAttributedString {
        return vehicles[pos].detectionModeDescription
    }
    
    func descriptionImage(pos: Int) -> UIImage? {
        return vehicles[pos].descriptionImage
    }
    
    func detectionModeConfigureButton(pos: Int) -> String? {
        return vehicles[pos].detectionModeConfigurationButton
    }

    private func renameVehicle(vehicle: DKVehicle, name: String) {
        DriveKitVehicle.shared.renameVehicle(name: name, vehicleId: vehicle.vehicleId) { status in
            if status == .success {
                self.delegate?.didUpdateVehicle()
            } else {
                self.delegate?.didReceiveErrorFromService()
            }
        }
    }
    
    private func deleteVehicle(vehicle: DKVehicle) {
        DriveKitVehicle.shared.deleteVehicle(vehicleId: vehicle.vehicleId) { status in
            if status == .success {
                self.delegate?.didUpdateVehicle()
            } else {
                self.delegate?.didReceiveErrorFromService()
            }
        }
    }
    
    func updateDetectionMode(pos: Int, detectionMode: DKDetectionMode, forceGPSUpdate: Bool = false) {
        DriveKitVehicle.shared.updateDetectionMode(vehicleId: vehicles[pos].vehicleId, detectionMode: detectionMode, forceGPSVehicleUpdate: forceGPSUpdate) { status in
            if status == .success {
                self.delegate?.didUpdateVehicle()
            } else {
                self.delegate?.didReceiveErrorFromService()
            }
        }
    }
    
    private func deleteBluetooth(vehicle: DKVehicle) {
        DriveKitVehicle.shared.removeBluetooth(vehicleId: vehicle.vehicleId) { status in
            if status == .success {
                self.delegate?.didUpdateVehicle()
            } else {
                self.delegate?.didReceiveErrorFromService()
            }
        }
    }
    
    private func deleteBeacon(vehicle: DKVehicle) {
        DriveKitVehicle.shared.removeBeacon(vehicleId: vehicle.vehicleId) { status in
            if status == .success {
                self.delegate?.didUpdateVehicle()
            }
        }
    }
    
    func computeDetectionMode() -> DKDetectionMode {
        return DriveKitVehicleUtils.getBestDetectionModeForNewVehicle(vehicleList: self.vehicles)
    }
    
    func gpsVehicle() -> DKVehicle? {
        return vehicles.filter { $0.detectionMode ?? .disabled == DKDetectionMode.gps }.first
    }

    func replaceAvailable() -> Bool {
        for action in DriveKitVehicleUI.shared.vehicleActions where action as? DKVehicleAction == .replace {
            return true
        }
        return false
    }

    func getAddReplaceButtonTitle() -> String {
        if shouldReplaceVehicle() {
            return "dk_vehicle_replace_button".dkVehicleLocalized()
        } else {
            return "dk_vehicle_add".dkVehicleLocalized()
        }
    }

    func maxVehiclesReached() -> Bool {
        guard let maxVehicles = DriveKitVehicleUI.shared.maxVehicles else { return false }
        return maxVehicles <= self.vehiclesCount
    }

    func shouldReplaceVehicle() -> Bool {
        return maxVehiclesReached() && replaceAvailable() && self.vehiclesCount == 1
    }
}
