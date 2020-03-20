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
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}
extension VehicleDetailVC: UITableViewDelegate {
    
}

extension VehicleDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.fields.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : VehicleGroupFieldsCell = self.tableView.dequeueReusableCell(withIdentifier: "VehicleGroupFieldsCell", for: indexPath) as! VehicleGroupFieldsCell
        cell.clipsToBounds = false
        cell.selectionStyle = .none
        let groupField = self.viewModel.fields[indexPath.section]
        cell.viewModel = VehicleGroupFieldViewModel(groupField: groupField, vehicleCore: self, vehicle: viewModel.vehicle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let groupFields = self.viewModel.fields[indexPath.section]
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
