//
//  BeaconDetailVC.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 17/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class BeaconDetailVC: DKUIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: BeaconDetailViewModel
    
    init(viewModel: BeaconDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BeaconDetailVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "BeaconDetailTableViewCell", bundle: Bundle.vehicleUIBundle), forCellReuseIdentifier: "BeaconDetailTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.title = "dk_beacon_diagnostic_title".dkVehicleLocalized()
    }
}

extension BeaconDetailVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BeaconDetailTableViewCell", for: indexPath) as! BeaconDetailTableViewCell
        cell.configure(pos: indexPath.row, viewModel: self.viewModel)
        return cell
    }
}

extension BeaconDetailVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
