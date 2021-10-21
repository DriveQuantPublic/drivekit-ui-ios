////
////  ReferenceDetailVC.swift
////  DriveKitVehicleUI
////
////  Created by Meryl Barantal on 09/08/2019.
////  Copyright © 2019 DriveQuant. All rights reserved.
////
//
//import UIKit
//import DriveKitCommonUI
//import DriveKitDBVehicleAccessModule
//
//class ReferenceDetailVC: DKUIViewController {
//    @IBOutlet weak var panelView: UIView!
//    @IBOutlet weak var panelTitle: UILabel!
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var validateButton: CustomButton!
//    @IBOutlet weak var cancelButton: CustomButton!
//    @IBOutlet weak var deleteButton: CustomButton!
//    
//    @IBOutlet weak var validateView: UIView!
//    @IBOutlet weak var cancelView: UIView!
//    @IBOutlet weak var deleteView: UIView!
//    
//    let viewModel : ReferenceViewModel
//    var manager = VehicleManager()
//    
//    init(viewModel: ReferenceViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: String(describing: ReferenceDetailVC.self), bundle: nil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        configure()
//    }
//    
//    func configure(){
//        deleteView.isHidden = true
//        
//        if let _ = self.viewModel.selectedRef {
//            if self.viewModel.histories.count > 1 {
//                deleteView.isHidden = false
//            }
//        }
//        
//        self.panelTitle.text = "odometer_history_detail_title".keyLocalized().uppercased()
//        self.panelTitle.font = DQConfiguration.primaryFont(16)
//        self.panelTitle.textColor = UIColor.secondary
//        self.validateButton.customize(title: "validate".keyLocalized().uppercased(), style: .full)
//        self.validateButton.titleLabel?.font = DQConfiguration.primaryBoldFont(14)
//        self.cancelButton.customize(title: "button_cancel".keyLocalized().uppercased(), style: .empty)
//        self.cancelButton.titleLabel?.font = DQConfiguration.primaryBoldFont(14)
//        self.deleteButton.customize(title: "delete".keyLocalized().uppercased(), style: .link)
//        self.deleteButton.titleLabel?.font = DQConfiguration.primaryFont(14)
//        
//        title = "update_odometer_title".keyLocalized()
//        tableView.separatorStyle = .none
//        tableView.sectionIndexBackgroundColor = .white
//        tableView.registerReusable(ReferenceDetailTableViewCell.self)
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 50
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        if #available(iOS 15, *) {
//            self.tableView.sectionHeaderTopPadding = 0
//        }
//    }
//    
//    @IBAction func validateReference(_ sender: Any) {
//        if let reference = self.viewModel.selectedRef {
//            track(page: "maintenance-histories-edit")
//            self.updateReference(reference: reference)
//        } else {
//            track(page: "maintenance-histories-add")
//            self.createReference()
//        }
//    }
//    
//    func createReference(){
//        if let value = self.viewModel.updatedValue {
//            if value >= self.viewModel.vehicle.odometer?.distance ?? 0 {
//                self.showLoader()
//                manager.createOdometer(token: Constants.getToken()!, vehicleId: self.viewModel.vehicle.vehicleId, distance: value, completionHandler: { status, error in
//                    DispatchQueue.main.async {
//                        self.hideLoader()
//                        if status {
//                            self.track(page: "maintenance_new_reference")
//                            let alert = UIAlertController(title: DQConfiguration.shared.appDisplayName,
//                                                          message: "odometer_reference_add_success".keyLocalized(),
//                                                          preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "ok".keyLocalized(), style: .cancel, handler: {action in
//                                self.navigationController?.popViewController(animated: true)
//                            })
//                            alert.addAction(okAction)
//                            self.present(alert, animated: true)
//                            
//                        } else {
//                            self.showAlertMessage(message: error?.errorKey.errorLocalized() ?? "network_unavailable".keyLocalized(), back: false)
//                        }
//                    }
//                })
//            } else {
//                self.showAlertMessage(message: "error_odometer_reference".keyLocalized(), back: false)
//            }
//        }
//    }
//    
//    func updateReference(reference: DKVehicleOdometerHistory) {
//        if let value = self.viewModel.updatedValue {
//            if value >= self.viewModel.prevRef?.distance ?? 0 {
//                self.showLoader()
//                manager.updateOdometer(token: Constants.getToken()!, vehicleId: self.viewModel.vehicle.vehicleId, historyId: reference.historyId, distance: value, completionHandler: { status, error in
//                    DispatchQueue.main.async {
//                        self.hideLoader()
//                        if status {
//                            let alert = UIAlertController(title: DQConfiguration.shared.appDisplayName,
//                                                          message: "odometer_reference_update_success".keyLocalized(),
//                                                          preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "ok".keyLocalized(), style: .cancel, handler: {action in
//                                self.navigationController?.popViewController(animated: true)
//                                
//                            })
//                            alert.addAction(okAction)
//                            self.present(alert, animated: true)
//                        } else {
//                            self.showAlertMessage(message: error?.errorKey.errorLocalized() ?? "network_unavailable".keyLocalized(), back: false)
//                        }
//                    }
//                })
//            } else {
//                self.showAlertMessage(message: "error_odometer_reference".keyLocalized(), back: false)
//            }
//        }
//    }
//    
//    @IBAction func cancelAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func deleteReference(_ sender: Any) {
//        if let reference = self.viewModel.selectedRef {
//            self.deleteOdometerReference(reference: reference)
//        }
//    }
//    
//    func deleteOdometerReference(reference: DKVehicleOdometerHistory) {
//        self.showLoader()
//        manager.deleteOdometer(token: Constants.getToken()!, vehicleId: self.viewModel.vehicle.vehicleId, historyId: reference.historyId, completionHandler: { status, error in
//            DispatchQueue.main.async {
//                self.hideLoader()
//                if status {
//                    let alert = UIAlertController(title: DQConfiguration.shared.appDisplayName,
//                                                  message: "odometer_reference_delete_success".keyLocalized(),
//                                                  preferredStyle: .alert)
//                    let okAction = UIAlertAction(title: "ok".keyLocalized(), style: .cancel, handler: {action in
//                        self.navigationController?.popViewController(animated: true)
//                        
//                    })
//                    alert.addAction(okAction)
//                    self.present(alert, animated: true)
//                } else {
//                    self.showAlertMessage(message: error?.errorDescription.errorLocalized() ?? "network_unavailable".keyLocalized(), back: false)
//                }
//            }
//        })
//    }
//}
//
//extension ReferenceDetailVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 8
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 8))
//        headerView.backgroundColor = .clear
//        return headerView
//    }
//}
//
//extension ReferenceDetailVC: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: ReferenceDetailTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//        let type = self.viewModel.cellsReferences[indexPath.section]
//        var value = ""
//        cell.backgroundColor = DQConfiguration.shared.appBackgroundColor
//        switch type {
//        case .distance:
//            if let history = self.viewModel.selectedRef {
//                value = String(format: "%.0f", history.distance)
//            }
//            if self.viewModel.isWritable {
//                cell.textField.isEnabled = true
//                self.cancelView.isHidden = false
//                self.validateView.isHidden = false
//            } else {
//                cell.textField.isEnabled = false
//                cell.selectionStyle = .none
//                self.cancelView.isHidden = true
//                self.validateView.isHidden = true
//            }
//            cell.delegate = self
//        case .date:
//            let dateFormatter = DateFormatter.isoDate
//            if let date = self.viewModel.updatedRefDate {
//                value = dateFormatter.string(from: date)
//            } else if let history = self.viewModel.selectedRef {
//                value = dateFormatter.string(from: history.updateDate ?? Date())
//            } else {
//                value = dateFormatter.string(from: Date())
//            }
//            
//            cell.selectionStyle = .none
//        case .vehicle(_):
//            value = self.viewModel.vehicle.computeName()
//            cell.selectionStyle = .none
//        }
//        cell.configure(type: type, value: value, vehicle: self.viewModel.vehicle, history: self.viewModel.selectedRef)
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//}
//
//extension ReferenceDetailVC: ReferenceDelegate {
//    func didUpdateDistanceField(distance: Double, sender: ReferenceDetailTableViewCell) {
//        self.viewModel.updatedValue = distance
//    }
//}
