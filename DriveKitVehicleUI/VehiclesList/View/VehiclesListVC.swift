//
//  VehicleListVC.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 05/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBVehicleAccess
import DriveKitCommonUI

public class VehiclesListVC: DKUIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addVehicleButton: UIButton!
    
    var viewModel : VehiclesListViewModel = VehiclesListViewModel()
    
    private let refreshControl = UIRefreshControl()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "VehiclesListCell", bundle: nil), forCellReuseIdentifier: "VehiclesListCell")
        self.configure()
    }
    
    func configure() {
        addVehicleButton.backgroundColor = DKUIColors.secondaryColor.color
        let addTitle = "dk_vehicle_add".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).build()
        addVehicleButton.setAttributedTitle(addTitle, for: .normal)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func confirmDeleteAlert(type: DeleteAlertType, vehicle: DKVehicle){
        var title = ""
        let vehicleName = vehicle.getDisplayNameInList(vehiclesList: self.viewModel.vehicles)
        
        switch type {
        case .vehicle:
            title = String(format: "dk_vehicle_delete_confirm".dkVehicleLocalized(), vehicleName)
        case .beacon:
            title = String(format: "dk_vehicle_beacon_deactivate_alert".dkVehicleLocalized(), vehicle.beacon?.code ?? "", vehicleName)
        case .bluetooth:
            title = String(format: "dk_vehicle_bluetooth_deactivate_alert".dkVehicleLocalized(), vehicle.bluetooth?.name ?? "", vehicleName)
        }
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "button_ok".dkVehicleLocalized(), style: .default , handler: {  _ in
            switch type {
            case .vehicle:
                self.viewModel.deleteVehicle(vehicle: vehicle)
            case .beacon:
                self.viewModel.deleteBeacon(vehicle: vehicle)
            case .bluetooth:
                self.viewModel.deleteBluetooth(vehicle: vehicle)
            }
        })
        alert.addAction(yesAction)
        let cancelAction = UIAlertAction(title: "dk_cancel".dkVehicleLocalized(), style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func editVehicleNameAlert(vehicle: DKVehicle){
        let alert = UIAlertController(title: "dk_vehicle_rename_title".dkVehicleLocalized(),
                                      message: "dk_vehicle_rename_description".dkVehicleLocalized(),
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.keyboardType = UIKeyboardType.default
            
            textField.text = vehicle.getDisplayNameInList(vehiclesList: self.viewModel.vehicles)
        }
        
        let ok = UIAlertAction(title: DKCommonLocalizable.ok.text(),
                               style: .default) { [weak alert] _ in
                                
                                guard let alert = alert, let textField = alert.textFields?.first, let newValue = textField.text else { return }
                                self.viewModel.renameVehicle(vehicle: vehicle, name: newValue)
        }
        alert.addAction(ok)
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @IBAction func goToVehiclePicker(_ sender: Any) {
        let vehiclePicker = VehiclePickerCoordinator(parentView: self, detectionMode: self.viewModel.computeDetectionMode())
    }
}

extension VehiclesListVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 8))
        return headerView
    }
}

extension VehiclesListVC: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.vehicles.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vehicle = viewModel.vehicles[indexPath.section]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "VehiclesListCell", for: indexPath) as! VehiclesListCell
        cell.selectionStyle = .none
        let cellViewModel = VehiclesListCellViewModel(listView: self, vehicle: vehicle, vehicles: viewModel.vehicles)
        cellViewModel.delegate = self
        cell.configure(viewModel: cellViewModel)
        return cell
    }
}


extension VehiclesListVC: VehiclesListDelegate {
    func onVehiclesAvailable() {
        DispatchQueue.main.async {
            self.hideLoader()
            self.tableView.reloadData()
        }
    }
    
    func didUpdateVehicle() {
        DispatchQueue.main.async {
            self.showLoader()
            self.viewModel.fetchVehicles()
        }
    }
    
    func didReceiveErrorFromService() {
        DispatchQueue.main.async {
            self.hideLoader()
            let alert = UIAlertController(title: nil, message: "dk_vehicle_error_message".dkVehicleLocalized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
