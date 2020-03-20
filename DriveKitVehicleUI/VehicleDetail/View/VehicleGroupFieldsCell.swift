//
//  VehicleFieldsCell.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehicleGroupFieldsCell: UITableViewCell {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cardView: CardView!
    
    var viewModel: VehicleGroupFieldViewModel? = nil {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        tableView.layer.cornerRadius = 5
        tableView.register(UINib(nibName: "VehicleFieldCell", bundle: Bundle.vehicleUIBundle), forCellReuseIdentifier: "VehicleFieldCell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension VehicleGroupFieldsCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension VehicleGroupFieldsCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.fields.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VehicleFieldCell = self.tableView.dequeueReusableCell(withIdentifier: "VehicleFieldCell", for: indexPath) as! VehicleFieldCell
        if let vehicleItem = self.viewModel?.fields[indexPath.row] {
            cell.configure(field: vehicleItem, vehicle: viewModel!.vehicle)
            cell.delegate = self
            cell.selectionStyle = .none
        }
        return cell
    }
}

extension VehicleGroupFieldsCell: VehicleFieldCellDelegate {
    func didEndEditing(cell: VehicleFieldCell, value: String) {
        cell.textFieldView.configure()
        if let indexPath = tableView.indexPath(for: cell) {
            if let field = self.viewModel?.fields[indexPath.row] as? GeneralField, field == .name {
                if value != viewModel?.vehicle.name {
                    viewModel?.delegate?.didUpdateField()
                }
            }
        }
    }
}
