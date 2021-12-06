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

    private let viewModel: OdometerVehicleDetailViewModel

    init(viewModel: OdometerVehicleDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: OdometerVehicleDetailVC.self), bundle: Bundle.vehicleUIBundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    private func configure() {
        self.view.backgroundColor = .white
        self.title = "dk_vehicle_odometer_vehicle_title".dkVehicleLocalized()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.update()
        self.tableView.reloadData()
    }
}

extension OdometerVehicleDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 8))
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
            if let viewModel = self.viewModel.getOdometerVehicleCellViewModel() {
                cell.configure(viewModel: viewModel, showPickerImage: false)
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OdometerVehicleDetailButtonsCell", for: indexPath) as! OdometerVehicleDetailButtonsCell
            cell.showReferenceLink(self.viewModel.showReferenceLink())
            cell.delegate = self
            return cell
        } else {
            let type = self.viewModel.cells[indexPath.section - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "OdometerCell", for: indexPath) as! OdometerCell
            cell.configure(viewModel: self.viewModel.getOdometerCellViewModel(), type: type, actionType: .info)
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
        if let navigationController = self.navigationController, let viewModel = self.viewModel.getNewOdometerHistoryDetailViewModel() {
            let historyDetailVC = OdometerHistoryDetailVC(viewModel: viewModel)
            navigationController.pushViewController(historyDetailVC, animated: true)
        }
    }

    func didSelectReferenceLink(sender: OdometerVehicleDetailButtonsCell) {
        if let navigationController = self.navigationController, let viewModel = self.viewModel.getOdometerHistoriesViewModel() {
            let historiesVC = OdometerHistoriesVC(viewModel: viewModel)
            navigationController.pushViewController(historiesVC, animated: true)
        }
    }
}
