////
////  ReferencesVC.swift
////  DriveKitVehicleUI
////
////  Created by Meryl Barantal on 09/08/2019.
////  Copyright © 2019 DriveQuant. All rights reserved.
////
//
//import UIKit
//import DriveKitCommonUI
//import DriveKitDBVehicleAccessModule
//import DriveKitVehicleModule
//
//class ReferencesVC: DKUIViewController {
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var addButton: CustomButton!
//    
//    let viewModel : ReferenceViewModel
//    
//    init(viewModel: ReferenceViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: String(describing: ReferencesVC.self), bundle: nil)
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
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        track(page: "maintenance-histories-list")
//        self.reloadReferences()
//    }
//    
//    func configure(){
//        title = "odometer_references_title".keyLocalized()
//        addButton.customize(title: "odometer_add_reference".keyLocalized().uppercased(), style: .full)
//        tableView.separatorStyle = .none
//        tableView.registerReusable(ReferenceTableViewCell.self)
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 50
//        tableView.delegate = self
//        tableView.dataSource = self
//        if #available(iOS 15, *) {
//            self.tableView.sectionHeaderTopPadding = 0
//        }
//    }
//    
//    func reloadReferences(){
//        viewModel.configureOdometer(vehicle: DriveKitVehicle.shared.vehiclesQuery().whereEqualTo(field: "vehicleId", value: viewModel.vehicle.vehicleId).queryOne().execute() ?? viewModel.vehicle)
//        tableView.reloadData()
//    }
//    
//    @IBAction func addReference(_ sender: Any) {
//        let referenceViewModel = ReferenceViewModel(vehicle: self.viewModel.vehicle)
//        referenceViewModel.odometer = self.viewModel.vehicle.odometer
//        referenceViewModel.isWritable = true
//        let referencesVC = ReferenceDetailVC(viewModel: referenceViewModel)
//        self.navigationController?.pushViewController(referencesVC, animated: true)
//    }
//    
//    func deleteOdometerReference(reference: DKVehicleOdometerHistory) {
//        self.showLoader()
//        VehicleManager().deleteOdometer(token: Constants.getToken()!, vehicleId: self.viewModel.vehicle.vehicleId, historyId: reference.historyId, completionHandler: { status, error in
//            self.hideLoader()
//            if status {
//                self.showAlertMessage(message: "odometer_reference_delete_success".keyLocalized(), back: false)
//                self.reloadReferences()
//            } else {
//                self.showAlertMessage(message: error?.errorDescription.errorLocalized() ?? "network_unavailable".keyLocalized(), back: false)
//            }
//        })
//    }
//    
//}
//
//extension ReferencesVC: UITableViewDelegate {
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
//extension ReferencesVC: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.viewModel.histories.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell : ReferenceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//        let history = self.viewModel.histories[indexPath.section]
//        let date = history.updateDate ?? Date()
//        cell.referenceLabel.text = String(format: "%.0f", history.distance) + " " + "distance_unit".keyLocalized()
//        cell.referenceDate.text = date.dayWithYear
//        cell.selectionStyle = .none
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        if self.viewModel.histories.count > 1 {
//            return true
//        } else {
//            return false 
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == .delete) {
//            if self.viewModel.histories.count > 1 {
//                let selectedRef = self.viewModel.histories[indexPath.section]
//                self.deleteOdometerReference(reference: selectedRef)
//            }
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
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
//        let referencesVC = ReferenceDetailVC(viewModel: self.viewModel)
//        self.navigationController?.pushViewController(referencesVC, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
//}
