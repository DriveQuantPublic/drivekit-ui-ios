//
//  OdometerVehicleDetailVC.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 08/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitVehicleModule

class OdometerVehicleDetailVC: DKUIViewController {
    @IBOutlet private weak var tableView: UITableView!

    let viewModel: OdometerVehicleDetailViewModel

    init(viewModel: OdometerVehicleDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: OdometerVehicleDetailVC.self), bundle: Bundle.vehicleUIBundle)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    func configure() {
        #warning("Manage new string")
        self.title = "TODO-odometer_vehicle_title".dkVehicleLocalized()
        self.tableView.separatorStyle = .none
        self.tableView.register(OdometerVehicleCell.nib, forCellReuseIdentifier: "OdometerVehicleCell")
        self.tableView.register(OdometerCell.nib, forCellReuseIdentifier: "OdometerCell")
        self.tableView.register(OdometerVehicleDetailButtonsCell.nib, forCellReuseIdentifier: "OdometerVehicleDetailButtonsCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if #available(iOS 15, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.configureVehicle(vehicle: DriveKitVehicle.shared.vehiclesQuery().whereEqualTo(field: "vehicleId", value: self.viewModel.vehicle.vehicleId).queryOne().execute() ?? self.viewModel.vehicle)
        self.tableView.reloadData()
    }

}

extension OdometerVehicleDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 8))
        headerView.backgroundColor = DKUIColors.backgroundView.color
        return headerView
    }
}

extension OdometerVehicleDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OdometerVehicleCell", for: indexPath) as! OdometerVehicleCell
            cell.configure(vehicle: self.viewModel.vehicle)
            cell.pickerImage.isHidden = true
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OdometerVehicleDetailButtonsCell", for: indexPath) as! OdometerVehicleDetailButtonsCell
            if let histories = self.viewModel.vehicle.odometerHistories, histories.count > 0 {
                cell.showReferenceLink(true)
            } else {
                cell.showReferenceLink(false)
            }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OdometerCell", for: indexPath) as! OdometerCell
            if self.viewModel.vehicle.odometer != nil {
                let cellViewModel = OdometerCellViewModel(vehicle: self.viewModel.vehicle, index: indexPath, type: self.viewModel.cells[indexPath.section - 1], optionButton: false, alertButton: true)
                cell.configure(viewModel: cellViewModel)
                cell.selectionStyle = .none
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension OdometerVehicleDetailVC: OdometerVehicleDetailButtonsCellDelegate {
    func didSelectUpdateButton(sender: OdometerVehicleDetailButtonsCell) {
        let historiesViewModel = OdometerHistoriesViewModel(vehicle: self.viewModel.vehicle)
        historiesViewModel.odometer = self.viewModel.vehicle.odometer
        historiesViewModel.isWritable = true
        let historyDetailVC = OdometerHistoryDetailVC(viewModel: historiesViewModel)
        self.navigationController?.pushViewController(historyDetailVC, animated: true)
    }

    func didSelectReferenceLink(sender: OdometerVehicleDetailButtonsCell) {
        let historiesViewModel = OdometerHistoriesViewModel(vehicle: self.viewModel.vehicle)
        historiesViewModel.odometer = self.viewModel.vehicle.odometer
        let historiesVC = OdometerHistoriesVC(viewModel: historiesViewModel)
        self.navigationController?.pushViewController(historiesVC, animated: true)
    }
}
