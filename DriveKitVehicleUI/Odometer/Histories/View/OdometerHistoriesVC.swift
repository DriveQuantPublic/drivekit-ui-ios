//
//  OdometerHistoriesVC.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 09/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBVehicleAccessModule
import DriveKitVehicleModule

class OdometerHistoriesVC: DKUIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    let viewModel: OdometerHistoriesViewModel

    init(viewModel: OdometerHistoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: OdometerHistoriesVC.self), bundle: Bundle.vehicleUIBundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadReferences()
    }

    func configure() {
        #warning("Manage new string")
        title = "TODO-odometer_references_title".dkVehicleLocalized()
        #warning("Manage new string")
        self.addButton.configure(text: "TODO-odometer_add_reference", style: .full)
        self.tableView.separatorStyle = .none
        self.tableView.register(OdometerHistoriesCell.nib, forCellReuseIdentifier: "OdometerHistoriesCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if #available(iOS 15, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
    }

    func reloadReferences() {
        self.viewModel.configureOdometer(vehicle: DriveKitVehicle.shared.vehiclesQuery().whereEqualTo(field: "vehicleId", value: self.viewModel.vehicle.vehicleId).queryOne().execute() ?? self.viewModel.vehicle)
        self.tableView.reloadData()
    }

    @IBAction func addReference(_ sender: Any) {
        let historiesViewModel = OdometerHistoriesViewModel(vehicle: self.viewModel.vehicle)
        historiesViewModel.odometer = self.viewModel.vehicle.odometer
        historiesViewModel.isWritable = true
        let historyDetailVC = OdometerHistoryDetailVC(viewModel: historiesViewModel)
        self.navigationController?.pushViewController(historyDetailVC, animated: true)
    }

    func deleteOdometerReference(reference: DKVehicleOdometerHistory) {
        self.showLoader()
        #warning("TODO")
//        VehicleManager().deleteOdometer(token: Constants.getToken()!, vehicleId: self.viewModel.vehicle.vehicleId, historyId: reference.historyId, completionHandler: { status, error in
//            self.hideLoader()
//            if status {
//                self.showAlertMessage(message: "odometer_reference_delete_success".keyLocalized(), back: false)
//                self.reloadReferences()
//            } else {
//                self.showAlertMessage(message: error?.errorDescription.errorLocalized() ?? "network_unavailable".keyLocalized(), back: false)
//            }
//        })
    }

}

extension OdometerHistoriesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 8))
        headerView.backgroundColor = DKUIColors.backgroundView.color
        return headerView
    }
}

extension OdometerHistoriesVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.histories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OdometerHistoriesCell", for: indexPath) as! OdometerHistoriesCell
        let history = self.viewModel.histories[indexPath.section]
        let date = history.updateDate ?? Date()
        cell.update(distance: history.distance, date: date)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.viewModel.histories.count > 1
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if self.viewModel.histories.count > 1 {
                let selectedRef = self.viewModel.histories[indexPath.section]
                self.deleteOdometerReference(reference: selectedRef)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let history = self.viewModel.histories[indexPath.section]
        self.viewModel.selectedRef = history
        if indexPath.section > 0 {
            self.viewModel.prevRef = self.viewModel.histories[indexPath.section - 1]
        }
        if indexPath.section == 0 {
            self.viewModel.isWritable = true
        } else {
            self.viewModel.isWritable = false
        }
        let historyDetailVC = OdometerHistoryDetailVC(viewModel: self.viewModel)
        self.navigationController?.pushViewController(historyDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
