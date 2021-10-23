//
//  OdometerHistoryDetailVC.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 09/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBVehicleAccessModule

class OdometerHistoryDetailVC: DKUIViewController {
    @IBOutlet private weak var panelView: UIView!
    @IBOutlet private weak var panelTitle: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var validateButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!

    @IBOutlet private weak var validateView: UIView!
    @IBOutlet private weak var cancelView: UIView!
    @IBOutlet private weak var deleteView: UIView!

    let viewModel: OdometerHistoriesViewModel

    init(viewModel: OdometerHistoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: OdometerHistoryDetailVC.self), bundle: Bundle.vehicleUIBundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    func configure() {
        if self.viewModel.selectedRef != nil, self.viewModel.histories.count > 1 {
            self.deleteView.isHidden = false
        } else {
            self.deleteView.isHidden = true
        }

        #warning("Manage new string")
        self.panelTitle.attributedText = "TODO-odometer_history_detail_title".dkVehicleLocalized().uppercased().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.secondaryColor).build()
        self.validateButton.configure(text: DKCommonLocalizable.validate.text(), style: .full)
        self.cancelButton.configure(text: DKCommonLocalizable.cancel.text(), style: .empty)
        self.deleteButton.configure(text: DKCommonLocalizable.delete.text(), style: .empty)

        #warning("Manage new string")
        self.title = "update_odometer_title".dkVehicleLocalized()
        self.tableView.separatorStyle = .none
        self.tableView.sectionIndexBackgroundColor = .white
        self.tableView.register(OdometerHistoryDetailCell.nib, forCellReuseIdentifier: "OdometerHistoryDetailCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.delegate = self
        self.tableView.dataSource = self

        if #available(iOS 15, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
    }

    @IBAction func validateReference(_ sender: Any) {
        if let reference = self.viewModel.selectedRef {
            #warning("TODO: tracking")
//            track(page: "maintenance-histories-edit")
            self.updateReference(reference: reference)
        } else {
            #warning("TODO: tracking")
//            track(page: "maintenance-histories-add")
            self.createReference()
        }
    }

    func createReference() {
        #warning("TODO")
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
    }

    func updateReference(reference: DKVehicleOdometerHistory) {
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
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteReference(_ sender: Any) {
        if let reference = self.viewModel.selectedRef {
            self.deleteOdometerReference(reference: reference)
        }
    }

    func deleteOdometerReference(reference: DKVehicleOdometerHistory) {
        self.showLoader()
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
    }
}

extension OdometerHistoryDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 8))
        headerView.backgroundColor = .clear
        return headerView
    }
}

extension OdometerHistoryDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OdometerHistoryDetailCell", for: indexPath) as! OdometerHistoryDetailCell
        let type = self.viewModel.cellsReferences[indexPath.section]
        var value = ""
        cell.backgroundColor = DKUIColors.backgroundView.color
        switch type {
            case .distance:
                if let history = self.viewModel.selectedRef {
                    value = history.distance.formatKilometerDistance(minDistanceToRemoveFractions: 0)
                }
                if self.viewModel.isWritable {
                    cell.enableTextField(true)
                    cell.selectionStyle = .default
                    self.cancelView.isHidden = false
                    self.validateView.isHidden = false
                } else {
                    cell.enableTextField(false)
                    cell.selectionStyle = .none
                    self.cancelView.isHidden = true
                    self.validateView.isHidden = true
                }
                cell.delegate = self
            case .date:
                let refDate: Date
                if let date = self.viewModel.updatedRefDate {
                    refDate = date
                } else if let history = self.viewModel.selectedRef {
                    refDate = history.updateDate ?? Date()
                } else {
                    refDate = Date()
                }
                value = DateUtils.convertDateToString(date: refDate)
                cell.selectionStyle = .none
            case .vehicle(_):
                value = self.viewModel.vehicle.computeName()
                cell.selectionStyle = .none
        }
        cell.configure(type: type, value: value, vehicle: self.viewModel.vehicle, history: self.viewModel.selectedRef)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension OdometerHistoryDetailVC: OdometerHistoryDelegate {
    func didUpdateDistanceField(distance: Double, sender: OdometerHistoryDetailCell) {
        self.viewModel.updatedValue = distance
    }
}
