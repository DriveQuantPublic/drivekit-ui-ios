//
//  ActivationHoursViewController.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 16/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ActivationHoursViewController: DKUIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel: ActivationHoursViewModel

    public init() {
        self.viewModel = ActivationHoursViewModel()
        super.init(nibName: String(describing: ActivationHoursViewController.self), bundle: Bundle.tripAnalysisUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ActivationHoursSlotCell", bundle: Bundle.tripAnalysisUIBundle), forCellReuseIdentifier: "ActivationHoursSlotCell")
        self.tableView.register(UINib(nibName: "ActivationHoursSeparatorCell", bundle: Bundle.tripAnalysisUIBundle), forCellReuseIdentifier: "ActivationHoursSeparatorCell")
        self.tableView.register(UINib(nibName: "ActivationHoursDayCell", bundle: Bundle.tripAnalysisUIBundle), forCellReuseIdentifier: "ActivationHoursDayCell")
    }
}

extension ActivationHoursViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.viewModel.sections[indexPath.row] {
            case .slot:
                return 70
            case .separator:
                return 1
            case .day:
                return 80
        }
    }
}

extension ActivationHoursViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.sections[indexPath.row] {
            case .slot:
                return tableView.dequeueReusableCell(withIdentifier: "ActivationHoursSlotCell", for: indexPath)
            case .separator:
                return tableView.dequeueReusableCell(withIdentifier: "ActivationHoursSeparatorCell", for: indexPath)
            case .day:
                return tableView.dequeueReusableCell(withIdentifier: "ActivationHoursDayCell", for: indexPath)
        }
    }
}

extension ActivationHoursViewController: DKActivationHoursConfigDelegate {
    func onActivationHoursAvaiblale() {
        
    }
    
    func onActivationHoursUpdated() {
        
    }
    
    func didReceiveErrorFromService() {
        
    }
}
