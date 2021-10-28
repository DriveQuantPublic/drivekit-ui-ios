//
//  OdometerVehicleListVC.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 05/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitVehicleModule
import DriveKitDBVehicleAccessModule

class OdometerVehicleListVC: DKUIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel: OdometerVehicleListViewModel

    init(viewModel: OdometerVehicleListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: OdometerVehicleListVC.self), bundle: Bundle.vehicleUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    func configure() {
        self.title = "dk_vehicle_odometer_menu".dkVehicleLocalized()
        self.tableView.separatorStyle = .none
        self.tableView.register(OdometerVehicleCell.nib, forCellReuseIdentifier: "OdometerVehicleCell")
        self.tableView.register(OdometerCell.nib, forCellReuseIdentifier: "OdometerCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if #available(iOS 15, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(update), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        self.update()
    }

    @objc private func update() {
        if let refreshControl = self.tableView?.refreshControl {
            refreshControl.beginRefreshing()
        }
        self.viewModel.update { success in
            if let refreshControl = self.tableView?.refreshControl, refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            if !success {
                self.showAlertMessage(title: Bundle.main.appName ?? "", message: DKCommonLocalizable.error.text(), back: true, cancel: false)
            }
            self.tableView.reloadData()
        }
    }
}

extension OdometerVehicleListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 8))
        headerView.backgroundColor = DKUIColors.backgroundView.color
        return headerView
    }
}

extension OdometerVehicleListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OdometerVehicleCell", for: indexPath) as! OdometerVehicleCell
            cell.configure(viewModel: self.viewModel.getOdometerVehicleCellViewModel(), showPickerImage: true)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OdometerCell", for: indexPath) as! OdometerCell
            cell.delegate = self
            cell.configure(viewModel: self.viewModel.getOdometerCellViewModel(), type: .odometer, actionType: .option)
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            #warning("TODO")
            let vehiclePicker = OdometerVehicleSelectionVC()
//            vehiclePicker.delegate = self
            vehiclePicker.modalPresentationStyle = .overCurrentContext
//            self.tableView.cellForRow(at: indexPath)?.isSelected = false
            self.present(vehiclePicker, animated: true, completion: nil)
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

//extension OdometerVehicleListVC: VehiclePickerDelegate {
//    func didSelectVehicle(vehicle: DKVehicle?, index: Int, sender: VehiclePickerVC) {
//        self.viewModel.vehicleIndex = index
//        self.fetchOdometer()
//    }
//}

extension OdometerVehicleListVC: OdometerCellDelegate {
    func didTouchActionButton(sender: OdometerCell) {
        let odometerActionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let showAction = UIAlertAction(title: "dk_vehicle_show".dkVehicleLocalized(), style: .default, handler: { _ in
            let vehicleDetailVC = OdometerVehicleDetailVC(viewModel: self.viewModel.getOdometerVehicleDetailViewModel())
            self.navigationController?.pushViewController(vehicleDetailVC, animated: true)
        })
        odometerActionAlert.addAction(showAction)
        let addReferenceAction = UIAlertAction(title: "dk_vehicle_odometer_add_reference".dkVehicleLocalized(), style: .default, handler: { _ in
            let historyDetailVC = OdometerHistoryDetailVC(viewModel: self.viewModel.getNewOdometerHistoryDetailViewModel())
            self.navigationController?.pushViewController(historyDetailVC, animated: true)
        })
        odometerActionAlert.addAction(addReferenceAction)
        odometerActionAlert.addAction(UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel))
        self.present(odometerActionAlert, animated: true)
    }
}
