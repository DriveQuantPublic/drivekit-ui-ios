// swiftlint:disable all
//
//  SelectBluetoothVC.swift
//  IFPClient
//
//  Created by Meryl Barantal on 03/01/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitVehicleModule

class SelectBluetoothVC: DKUIViewController {
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var deviceList: UITableView!
    @IBOutlet var listHeight: NSLayoutConstraint!
    @IBOutlet var confirmButton: UIButton!
    
    private let viewModel: BluetoothViewModel
    
    public init(viewModel: BluetoothViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SelectBluetoothVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "dk_vehicle_bluetooth_combination_view_title".dkVehicleLocalized()
        self.setup()
        _ = viewModel.getBluetoothDevices()
        deviceList.delegate = self
        deviceList.dataSource = self
        deviceList.reloadData()
    }
    
    func setup() {
        contentLabel.attributedText = "dk_vehicle_select_bluetooth_description".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        confirmButton.configure(text: DKCommonLocalizable.confirm.text(), style: .full)
        confirmButton.isEnabled = false
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        if let selectedRow = deviceList.indexPathForSelectedRow {
            self.showLoader()
            self.viewModel.addBluetoothToVehicle(pos: selectedRow.row, completion: { status in
                DispatchQueue.main.async {
                    self.hideLoader()
                    switch status {
                    case .success:
                        self.redirectToSuccesView(pos: selectedRow.row)
                    case .unavailableBluetooth:
                        self.bluetoothAlreadyPaired()
                    case .unknownVehicle:
                        self.vehicleUnknown()
                    case .error:
                        self.failedToPairedBluetooth()
                    @unknown default:
                        break
                    }
                }
            })
        }
    }
    
    private func bluetoothAlreadyPaired() {
        let message = String(format: "dk_vehicle_bluetooth_already_paired".dkVehicleLocalized(), viewModel.bluetoothName, viewModel.vehicleName)
        self.showAlertMessage(title: "", message: message, back: false, cancel: false)
    }
    
    private func vehicleUnknown() {
        self.showAlertMessage(title: "", message: "dk_vehicle_unknown", back: true, cancel: false, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    private func failedToPairedBluetooth() {
        self.showAlertMessage(title: "", message: "dk_vehicle_failed_to_paired_bluetooth".dkVehicleLocalized(), back: false, cancel: false)
    }
    
    private func redirectToSuccesView(pos: Int) {
        let successVC = SuccessBluetoothVC(viewModel: viewModel)
        self.navigationController?.pushViewController(successVC, animated: true)
    }
}

extension SelectBluetoothVC: UITableViewDelegate {
    
}

extension SelectBluetoothVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.textLabel?.attributedText = viewModel.devices[indexPath.row].name.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.confirmButton.isEnabled = true
        tableView.cellForRow(at: indexPath as IndexPath)?.tintColor = DKUIColors.secondaryColor.color
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.confirmButton.isEnabled = false
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
}
