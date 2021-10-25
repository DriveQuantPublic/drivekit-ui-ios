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
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addButton: UIButton!

    private let viewModel: OdometerHistoriesViewModel

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
        title = "dk_vehicle_odometer_references_title".dkVehicleLocalized()
        self.addButton.configure(text: "dk_vehicle_odometer_add_reference".dkVehicleLocalized(), style: .full)
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
        self.viewModel.update()
        self.tableView.reloadData()
    }

    @IBAction func addReference(_ sender: Any) {
        let historyDetailVC = OdometerHistoryDetailVC(viewModel: self.viewModel.getNewOdometerHistoryDetailViewModel())
        self.navigationController?.pushViewController(historyDetailVC, animated: true)
    }

    func deleteHistory(atIndex index: Int) {
        self.showLoader()
        self.viewModel.deleteHistory(atIndex: index) { success in
            self.hideLoader()
            if success {
                #warning("TODO")
//                self.showAlertMessage(message: "dk_vehicle_odometer_reference_delete_success".dkVehicleLocalized()(), back: false)
                self.reloadReferences()
            } else {
                #warning("TODO")
//                self.showAlertMessage(message: error?.errorDescription.errorLocalized() ?? "network_unavailable".keyLocalized(), back: false)
            }
        }
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
        return self.viewModel.getNumberOfHistories()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OdometerHistoriesCell", for: indexPath) as! OdometerHistoriesCell
        if let viewModel = self.viewModel.getOdometerHistoriesCellViewModel(atIndex: indexPath.section) {
            cell.update(odometerHistoriesCellViewModel: viewModel)
        }
//        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.viewModel.canDeleteHistory()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if self.viewModel.canDeleteHistory() {
                self.deleteHistory(atIndex: indexPath.section)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let history = self.viewModel.histories[indexPath.section]
//        self.viewModel.selectedRef = history
//        if indexPath.section > 0 {
//            self.viewModel.prevRef = self.viewModel.histories[indexPath.section - 1]
//        }
//        if indexPath.section == 0 {
//            self.viewModel.isWritable = true
//        } else {
//            self.viewModel.isWritable = false
//        }
        let historyDetailVC = OdometerHistoryDetailVC(viewModel: self.viewModel.getOdometerHistoryDetailViewModel(atIndex: indexPath.section))
        self.navigationController?.pushViewController(historyDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
