// swiftlint:disable no_magic_numbers
//
//  VehicleListVC.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 05/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBVehicleAccessModule
import DriveKitCommonUI

public class VehiclesListVC: DKUIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addReplaceVehicleButton: UIButton!
    
    private let viewModel: DKVehiclesListViewModel
    private let refreshControl = UIRefreshControl()

    public init() {
        self.viewModel = DKVehiclesListViewModel()
        super.init(nibName: String(describing: VehiclesListVC.self), bundle: Bundle.vehicleUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        updateTitle()
        self.viewModel.delegate = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(refreshVehiclesList(_ :)), for: .valueChanged)
        self.tableView.register(UINib(nibName: "VehiclesListCell", bundle: Bundle.vehicleUIBundle), forCellReuseIdentifier: "VehiclesListCell")
        self.tableView.register(VehicleListHeaderView.self, forHeaderFooterViewReuseIdentifier: "VehicleListHeaderView")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        updateUI()
    }

    func configure() {
        if (DriveKitVehicleUI.shared.canAddVehicle && !viewModel.maxVehiclesReached()) || viewModel.shouldReplaceVehicle() {
            addReplaceVehicleButton.configure(title: viewModel.getAddReplaceButtonTitle(), style: .full)
            addReplaceVehicleButton.isHidden = false
        } else {
            addReplaceVehicleButton.isHidden = true
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.setContentOffset(CGPoint(x: 0, y: -self.refreshControl.frame.size.height), animated: true)
        self.viewModel.fetchVehicles()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.viewModel.updating {
            self.refreshControl.beginRefreshing()
        } else {
            self.refreshControl.endRefreshing()
        }
    }

    @IBAction func addOrReplaceVehicleAction(_ sender: Any) {
        if viewModel.shouldReplaceVehicle() {
            self.showVehiclePicker(vehicle: viewModel.vehicles.first)
        } else if viewModel.maxVehiclesReached() {
            self.showAlertMessage(title: "", message: "dk_too_many_vehicles_alert".dkVehicleLocalized(), back: false, cancel: false)
        } else {
            self.showVehiclePicker()
        }
    }

    @objc func refreshVehiclesList(_ sender: Any) {
        self.viewModel.fetchVehicles()
    }

    private func updateTitle() {
        if self.viewModel.vehiclesCount == 1 {
            self.title = "dk_vehicle_my_vehicle".dkVehicleLocalized()
        } else {
            self.title = "dk_vehicle_my_vehicles".dkVehicleLocalized()
        }
    }
}

extension VehiclesListVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.viewModel.vehiclesCount == 0 {
            let headerView: VehicleListHeaderView = self.tableView.dequeueHeaderFooterView(withIdentifier: "VehicleListHeaderView" )
            headerView.image.image = DKImages.warning.image
            headerView.image.tintColor = DKUIColors.warningColor.color
            headerView.title.attributedText = "dk_vehicle_list_empty".dkVehicleLocalized().dkAttributedString().primaryFontNormalTextMainFontColor()
            return headerView
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.viewModel.vehiclesCount == 0 {
            return 80
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension VehiclesListVC: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.vehiclesCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VehiclesListCell = self.tableView.dequeue(withIdentifier: "VehiclesListCell", for: indexPath)
        cell.configure(viewModel: viewModel, pos: indexPath.row, parentView: self)
        return cell
    }
}

extension VehiclesListVC: VehiclesListDelegate {
    public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }

    public func showAlert(_ alertController: UIAlertController) {
        self.present(alertController, animated: true)
    }

    public func onVehiclesAvailable() {
        DispatchQueue.main.async {
            self.hideLoader()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.updateUI()
        }
    }

    private func updateUI() {
        self.configure()
        self.tableView.reloadData()
        self.updateTitle()
    }

    public func didUpdateVehicle() {
        DispatchQueue.main.async {
            self.showLoader()
            self.viewModel.fetchVehicles()
        }
    }

    public func didReceiveErrorFromService() {
        DispatchQueue.main.async {
            self.hideLoader()
            let alert = UIAlertController(title: nil, message: "dk_vehicle_error_message".dkVehicleLocalized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }

    public func showVehiclePicker(vehicle: DKVehicle? = nil) {
        _ = DKVehiclePickerNavigationController(parentView: self, detectionMode: self.viewModel.computeDetectionMode(), vehicle: vehicle, completion: {
            self.viewModel.fetchVehicles()
        })
    }
}
