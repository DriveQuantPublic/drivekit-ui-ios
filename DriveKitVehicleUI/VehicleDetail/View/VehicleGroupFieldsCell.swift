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

    private var viewModel: VehicleDetailViewModel?
    private var groupField: DKVehicleGroupField?

    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        tableView.register(UINib(nibName: "VehicleFieldCell", bundle: Bundle.vehicleUIBundle), forCellReuseIdentifier: "VehicleFieldCell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
    }

    func configure(viewModel : VehicleDetailViewModel, groupField: DKVehicleGroupField) {
        self.viewModel = viewModel
        self.groupField  = groupField
        self.tableView.reloadData()
    }
}

extension VehicleGroupFieldsCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let viewModel = self.viewModel, let groupField = self.groupField {
            let field = viewModel.getField(groupField: groupField)[indexPath.row]
            return field.cellHeightForWidth(tableView.bounds.size.width)
        } else {
            return 0
        }
    }
}

extension VehicleGroupFieldsCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = self.viewModel, let groupField = self.groupField {
            return viewModel.getField(groupField: groupField).count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VehicleFieldCell = self.tableView.dequeueReusableCell(withIdentifier: "VehicleFieldCell", for: indexPath) as! VehicleFieldCell
        if let viewModel = self.viewModel, let groupField = self.groupField {
            let field = viewModel.getField(groupField: groupField)[indexPath.row]
            cell.configure(field: field, value: viewModel.getFieldValue(field: field), delegate: self, hasError: viewModel.hasError(field: field))
            cell.selectionStyle = .none
        }
        return cell
    }
}

extension VehicleGroupFieldsCell: VehicleFieldCellDelegate {
    func didEndEditing(cell: VehicleFieldCell, value: String) {
        if let indexPath = tableView.indexPath(for: cell), let viewModel = self.viewModel, let groupField = self.groupField {
            if let field = self.viewModel?.getField(groupField: groupField)[indexPath.row] {
                if field.isValid(value: value, vehicle: viewModel.vehicle) {
                    viewModel.addUpdatedField(field: field, value: value)
                    cell.configureError(error: nil)
                } else {
                    cell.configureError(error: field.getErrorDescription() ?? "")
                }
            }
        }
    }
}

extension DKVehicleField {
    func cellHeightForWidth(_ width: CGFloat) -> CGFloat {
        var height: CGFloat = 58
        if self.isEditable {
            height += 20
        }
        if let description = self.description {
            let attributedString = description.dkAttributedString().font(dkFont: .primary, style: .smallText).build()
            let boundingRect = attributedString.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
            let descriptionHeight = boundingRect.height
            height += descriptionHeight
        }
        return height
    }
}
