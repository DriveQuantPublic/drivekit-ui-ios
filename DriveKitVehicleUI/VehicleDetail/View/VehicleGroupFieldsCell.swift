// swiftlint:disable no_magic_numbers
//
//  VehicleFieldsCell.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBVehicleAccessModule

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

    func configure(viewModel: VehicleDetailViewModel, groupField: DKVehicleGroupField) {
        self.viewModel = viewModel
        self.groupField = groupField
        self.tableView.reloadData()
    }
}

extension VehicleGroupFieldsCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let viewModel = self.viewModel, let groupField = self.groupField {
            let field = viewModel.getField(groupField: groupField)[indexPath.row]
            let width = tableView.bounds.size.width - viewModel.textFieldTotalHorizontalPadding * 2
            return field.cellHeightForWidth(width, vehicle: viewModel.vehicle)
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
        let cell: VehicleFieldCell = self.tableView.dequeue(withIdentifier: "VehicleFieldCell", for: indexPath)
        if let viewModel = self.viewModel, let groupField = self.groupField {
            let field = viewModel.getField(groupField: groupField)[indexPath.row]
            cell.configure(vehicle: viewModel.vehicle, field: field, value: viewModel.getFieldValue(field: field), delegate: self, hasError: viewModel.hasError(field: field))
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
                    cell.configureError(error: field.getErrorDescription(value: value, vehicle: viewModel.vehicle) ?? "")
                }
            }
        }
    }
}

extension DKVehicleField {
    func cellHeightForWidth(_ width: CGFloat, vehicle: DKVehicle) -> CGFloat {
        var height: CGFloat = 44
        let titleHeight = getCellHeightForText(self.getTitle(vehicle: vehicle), width: width, style: .normalText)
        height += titleHeight
        if let description = self.getDescription(vehicle: vehicle) {
            let descriptionHeight = getCellHeightForText(description, width: width, style: .smallText)
            height += descriptionHeight
        } else if self.isEditable {
            height += 12
        }
        return height
    }

    private func getCellHeightForText(_ text: String, width: CGFloat, style: DKStyles) -> CGFloat {
        let textAttributedString = text.dkAttributedString().font(dkFont: .primary, style: style).build()
        let boundingRect = textAttributedString.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        let textHeight = boundingRect.height
        return ceil(textHeight)
    }
}
