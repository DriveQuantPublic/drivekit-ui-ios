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
    
    let viewModel : VehiclePickerViewModel
    
    init (viewModel: VehiclePickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: VehiclePickerTableViewVC.self), bundle: .vehicleUIBundle)
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
        viewModel.onTableViewItemSelected(pos: indexPath.row, completion: {status in
            DispatchQueue.main.async {
                self.hideLoader()
                switch status {
                case .noError:
                    self.viewModel.coordinator.showStep(viewController: self.viewModel.getViewController())
                case .noData:
                    self.showAlertMessage(title: nil, message: "No data retrieved for selection", back: false, cancel: false)
                case .failedToRetreiveData:
                    self.showAlertMessage(title: nil, message: "Failed to retreive data", back: false, cancel: false)
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: tableView.frame.width, height: 70))
        if let description = viewModel.currentStep.description() {
            let label = UILabel()
            label.frame = CGRect.init(x: 0.0, y: 0.0, width: headerView.frame.width, height: headerView.frame.height)
            label.textAlignment = .center
            label.text = description
            headerView.addSubview(label)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = viewModel.currentStep.description() {
            return 70
        } else {
            return 0
        }
    }
}
