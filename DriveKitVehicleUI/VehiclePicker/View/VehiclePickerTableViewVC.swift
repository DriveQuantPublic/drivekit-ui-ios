//
//  VehiclePickerTableViewVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 20/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehiclePickerTableViewVC: VehiclePickerStepView {
    @IBOutlet weak var tableView: UITableView!
    
    init (viewModel: VehiclePickerViewModel) {
        super.init(nibName: String(describing: VehiclePickerTableViewVC.self), bundle: .vehicleUIBundle)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "VehiclePickerTableViewCell", bundle: .vehicleUIBundle), forCellReuseIdentifier: "VehiclePickerTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.viewModel.vehicleDataDelegate = self
    }
}


extension VehiclePickerTableViewVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
}

extension VehiclePickerTableViewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTableViewItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let value : String = viewModel.getTableViewItems()[indexPath.row].text()
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "VehiclePickerTableViewCell", for: indexPath) as! VehiclePickerTableViewCell
        cell.configure(text: value)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showLoader()
        viewModel.onTableViewItemSelected(pos: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: tableView.frame.width, height: 70))
        if let description = viewModel.getStepDescription() {
            let label = UILabel()
            label.frame = CGRect.init(x: 0.0, y: 0.0, width: headerView.frame.width, height: headerView.frame.height)
            label.textAlignment = .center
            label.attributedText = description.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
            headerView.addSubview(label)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = viewModel.getStepDescription() {
            return 70
        } else {
            return 0
        }
    }
}

extension VehiclePickerTableViewVC : VehicleDataDelegate {
    func onDataRetrieved(status: StepStatus) {
        self.executeOnMainThread {
            self.hideLoader()
            switch status {
                case .noError:
                    self.viewModel.showStep()
                case .noData:
                    self.showAlertMessage(title: nil, message: "dk_vehicle_no_data".dkVehicleLocalized(), back: false, cancel: false)
                case .failedToRetreiveData:
                    self.showAlertMessage(title: nil, message: "dk_vehicle_failed_to_retrieve_vehicle_data".dkVehicleLocalized(), back: false, cancel: false)
            }
        }
    }

    private func executeOnMainThread(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
