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
    
    var viewModel : VehiclesListViewModel
    
    private let refreshControl = UIRefreshControl()
    
    public init() {
        self.viewModel = VehiclesListViewModel()
        super.init(nibName: String(describing: VehiclesListVC.self), bundle: Bundle.vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "dk_vehicle_my_vehicles".dkVehicleLocalized()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshVehiclesList(_ :)), for: .valueChanged)
        self.tableView.register(UINib(nibName: "VehiclesListCell", bundle: Bundle.vehicleUIBundle), forCellReuseIdentifier: "VehiclesListCell")
        self.tableView.register(VehicleListHeaderView.self, forHeaderFooterViewReuseIdentifier: "VehicleListHeaderView")
        self.configure()
    }
    
    func configure() {
        if DriveKitVehicleUI.shared.canAddVehicle {
            addVehicleButton.backgroundColor = DKUIColors.secondaryColor.color
            let addTitle = "dk_vehicle_add".dkVehicleLocalized().uppercased().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).build()
            addVehicleButton.setAttributedTitle(addTitle, for: .normal)
        } else{
            addVehicleButton.isHidden = true
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        self.viewModel.delegate = nil
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.delegate = self
        self.showLoader()
    }
    
    func confirmDeleteAlert(type: DeleteAlertType, vehicle: DKVehicle){
        var title = ""
        let vehicleName = vehicle.getDisplayNameInList(vehiclesList: self.viewModel.vehicles)
        
        switch type {
        case .vehicle:
            title = String(format: "dk_vehicle_delete_confirm".dkVehicleLocalized(), vehicleName)
        case .beacon:
            title = String(format: "dk_vehicle_beacon_deactivate_alert".dkVehicleLocalized(), vehicle.beacon?.uniqueId ?? "", vehicleName)
        case .bluetooth:
            title = String(format: "dk_vehicle_bluetooth_deactivate_alert".dkVehicleLocalized(), vehicle.bluetooth?.name ?? "", vehicleName)
        }
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default , handler: {  _ in
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
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
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
        if let maxVehicles = DriveKitVehicleUI.shared.maxVehicles, maxVehicles <= self.viewModel.vehicles.count {
            self.showAlertMessage(title: "", message: "dk_too_many_vehicles_alert".dkVehicleLocalized(), back: false, cancel: false)
        }else{
            _ = VehiclePickerCoordinator(parentView: self, detectionMode: self.viewModel.computeDetectionMode())
        }
    }
    
    @objc func refreshVehiclesList(_ sender: Any) {
           self.viewModel.fetchVehicles()
       }
}

extension VehiclesListVC: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.viewModel.vehicles.isEmpty {
            let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "VehicleListHeaderView" ) as! VehicleListHeaderView
            headerView.image.image = DKImages.warning.image
            headerView.image.tintColor = DKUIColors.warningColor.color
            headerView.title.attributedText = "dk_vehicle_list_empty".dkVehicleLocalized().dkAttributedString().primaryFontNormalTextMainFontColor()
            return headerView
        } else{
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.viewModel.vehicles.isEmpty {
            return 80
        }else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
}

extension VehiclesListVC: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.vehicles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vehicle = viewModel.vehicles[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "VehiclesListCell", for: indexPath) as! VehiclesListCell
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
            if let maxVehicle = DriveKitVehicleUI.shared.maxVehicles, self.viewModel.vehicles.count >= maxVehicle {
                self.addVehicleButton.isHidden = true
            }else{
                self.addVehicleButton.isHidden = false
            }
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.tableView.delegate = self
            self.tableView.dataSource = self
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
