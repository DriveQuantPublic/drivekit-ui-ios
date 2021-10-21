////
////  OdometerVC.swift
////  DriveKitVehicleUI
////
////  Created by Meryl Barantal on 08/08/2019.
////  Copyright © 2019 DriveQuant. All rights reserved.
////
//
//import UIKit
//import DriveKitCommonUI
//import DriveKitVehicleModule
//
//class OdometerVC: DKUIViewController {
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    let viewModel: OdometerViewModel
//    
//    init(viewModel: OdometerViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: String(describing: OdometerVC.self), bundle: nil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.configure()
//    }
//
//    func configure() {
//        title = "odometer_vehicle_title".keyLocalized()
//        tableView.separatorStyle = .none
//        tableView.registerReusable(MaintenanceVehicleTableViewCell.self)
//        tableView.registerReusable(OdometerCell.self)
//        tableView.registerReusable(OdometerButtonsTableViewCell.self)
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 100
//        tableView.delegate = self
//        tableView.dataSource = self
//        if #available(iOS 15, *) {
//            self.tableView.sectionHeaderTopPadding = 0
//        }
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        track(page: "maintenance-vehicles-detail")
//        viewModel.configureVehicle(vehicle: DriveKitVehicle.shared.vehiclesQuery().whereEqualTo(field: "vehicleId", value: viewModel.vehicle.vehicleId).queryOne().execute() ?? viewModel.vehicle)
//        tableView.reloadData()
//    }
//
//}
//
//extension OdometerVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 8
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 8))
//        Styles.app_background_color.apply(to: headerView)
//        return headerView
//    }
//}
//
//extension OdometerVC: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 5
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell : MaintenanceVehicleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//            cell.configure(vehicle: self.viewModel.vehicle)
//            cell.pickerImage.isHidden = true
//            cell.selectionStyle = .none
//            return cell
//        } else if indexPath.section == 4 {
//            let cell : OdometerButtonsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//            if let histories = self.viewModel.vehicle.odometerHistories, histories.count > 0 {
//                cell.referenceLink.isHidden = false
//            } else {
//                cell.referenceLink.isHidden = true
//            }
//            cell.delegate = self
//            cell.selectionStyle = .none
//            return cell
//        } else {
//            let cell : MaintenanceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//            if self.viewModel.vehicle.odometer != nil {
//                let cellViewModel = OdometerCellViewModel(vehicle: self.viewModel.vehicle, index: indexPath, type: self.viewModel.cells[indexPath.section - 1], optionButton: false, alertButton: true)
//                cell.configure(viewModel: cellViewModel)
//                cell.selectionStyle = .none
//            }
//            return cell
//            
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 80
//        } else {
//            return UITableView.automaticDimension
//        }
//    }
//}
//
//extension OdometerVC: OdometerButtonsTableViewCellDelegate {
//    func didSelectUpdateButton(sender: OdometerButtonsTableViewCell) {
//        let referenceViewModel = ReferenceViewModel(vehicle: self.viewModel.vehicle)
//        referenceViewModel.odometer = self.viewModel.vehicle.odometer
//        referenceViewModel.isWritable = true
//        let referencesVC = ReferenceDetailVC(viewModel: referenceViewModel)
//        self.navigationController?.pushViewController(referencesVC, animated: true)
//    }
//    
//    func didSelectReferenceLink(sender: OdometerButtonsTableViewCell) {
//        let referenceViewModel = ReferenceViewModel(vehicle: self.viewModel.vehicle)
//        referenceViewModel.odometer = self.viewModel.vehicle.odometer
//        let referencesVC = ReferencesVC(viewModel: referenceViewModel)
//        self.navigationController?.pushViewController(referencesVC, animated: true)
//    }
//}
