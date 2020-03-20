//
//  VehicleDetailVC.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehicleDetailVC : DKUIViewController {
    @IBOutlet weak var tableView: UITableView!
    let viewModel : VehicleDetailViewModel
    
    public init(viewModel: VehicleDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: VehicleDetailVC.self), bundle: Bundle.vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "VehicleGroupFieldsCell", bundle: Bundle.vehicleUIBundle), forCellReuseIdentifier: "VehicleGroupFieldsCell")
        self.tableView.register(UINib(nibName: "VehicleDetailHeader", bundle: Bundle.vehicleUIBundle), forCellReuseIdentifier: "VehicleDetailHeader")
        self.tableView.backgroundColor = DKUIColors.backgroundView.color
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}
extension VehicleDetailVC: UITableViewDelegate {
    
}

extension VehicleDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.fields.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell : VehicleDetailHeader = self.tableView.dequeueReusableCell(withIdentifier: "VehicleDetailHeader", for: indexPath) as! VehicleDetailHeader
            cell.configure(vehicleName: self.viewModel.vehicleDisplayName, vehicleImage: viewModel.getVehicleImage())
            cell.delegate = self
            cell.clipsToBounds = false
            cell.selectionStyle = .none
            return cell
        } else {
            let cell : VehicleGroupFieldsCell = self.tableView.dequeueReusableCell(withIdentifier: "VehicleGroupFieldsCell", for: indexPath) as! VehicleGroupFieldsCell
            cell.clipsToBounds = false
            cell.selectionStyle = .none
            let groupField = self.viewModel.fields[indexPath.section - 1]
            cell.viewModel = VehicleGroupFieldViewModel(groupField: groupField, vehicleCore: self, vehicle: viewModel.vehicle)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250
        } else {
            let groupFields = self.viewModel.fields[indexPath.section - 1]
            var fieldsNb = 0
            let fields = groupFields.getFields(vehicle: self.viewModel.vehicle)
            for field in fields {
                if field.getValue(vehicle: self.viewModel.vehicle) != nil {
                    fieldsNb += 1
                }
            }
            return CGFloat(fieldsNb * 85)
        }
    }
}

extension VehicleDetailVC: VehicleDetailHeaderDelegate {
    func didSelectAddImage(cell: VehicleDetailHeader) {
        print("ADD")
    }
}
