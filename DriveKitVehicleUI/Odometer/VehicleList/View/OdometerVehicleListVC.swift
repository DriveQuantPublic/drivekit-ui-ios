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
    @IBOutlet private weak var noVehicleLabel: UILabel!
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

    private func configure() {
        self.view.backgroundColor = .white
        self.title = "dk_vehicle_odometer".dkVehicleLocalized()
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
        refreshControl.addTarget(self, action: #selector(synchronize), for: .valueChanged)
        self.tableView.refreshControl = refreshControl

        self.noVehicleLabel.attributedText = "dk_vehicle_list_empty".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.mainFontColor).build()
        update()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.synchronize()
    }

    @objc private func synchronize() {
        if let refreshControl = self.tableView?.refreshControl {
            refreshControl.beginRefreshing()
        }
        self.viewModel.synchronize { [weak self] success in
            if let self = self {
                if let refreshControl = self.tableView?.refreshControl, refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
                if !success {
                    self.showAlertMessage(title: Bundle.main.appName ?? "", message: "dk_vehicle_odometer_failed_to_sync".dkVehicleLocalized(), back: true, cancel: false)
                }
                self.update()
            }
        }
    }

    private func update() {
        if self.viewModel.hasVehicles() {
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.noVehicleLabel.isHidden = true
        } else {
            self.tableView.isHidden = true
            self.noVehicleLabel.isHidden = false
        }
    }
}

extension OdometerVehicleListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 8))
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
            if let cellViewModel = self.viewModel.getOdometerVehicleCellViewModel() {
                cell.configure(viewModel: cellViewModel, showPickerImage: true)
            }
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
            if let vehicleFilterViewModel = self.viewModel.getVehicleFilterViewModel(delegate: self) {
                let vehiclePicker = DKFilterPickerVC(viewModel: vehicleFilterViewModel)
                self.present(vehiclePicker, animated: true)
            }
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

extension OdometerVehicleListVC: DKFilterItemDelegate {
    func onFilterItemSelected(filterItem: DKFilterItem) {
        if let vehicleId = filterItem.getId() as? String {
            self.viewModel.updateVehicle(vehicleId: vehicleId)
            self.tableView.reloadData()
            self.synchronize()
        }
    }
}

extension OdometerVehicleListVC: OdometerCellDelegate {
    func didTouchActionButton(sender: OdometerCell) {
        let odometerActionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let showAction = UIAlertAction(title: "dk_vehicle_show".dkVehicleLocalized(), style: .default, handler: { _ in
            if let viewModel = self.viewModel.getOdometerVehicleDetailViewModel() {
                let vehicleDetailVC = OdometerVehicleDetailVC(viewModel: viewModel)
                self.navigationController?.pushViewController(vehicleDetailVC, animated: true)
            }
        })
        odometerActionAlert.addAction(showAction)
        let addReferenceAction = UIAlertAction(title: "dk_vehicle_odometer_add_history".dkVehicleLocalized(), style: .default, handler: { _ in
            if let viewModel = self.viewModel.getNewOdometerHistoryDetailViewModel() {
                let historyDetailVC = OdometerHistoryDetailVC(viewModel: viewModel)
                self.navigationController?.pushViewController(historyDetailVC, animated: true)
            }
        })
        odometerActionAlert.addAction(addReferenceAction)
        odometerActionAlert.addAction(UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel))
        self.present(odometerActionAlert, animated: true)
    }
}
