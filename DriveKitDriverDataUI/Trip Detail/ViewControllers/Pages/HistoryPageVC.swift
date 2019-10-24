//
//  HistoryPageVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

class HistoryPageVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var viewModel: HistoryPageViewModel
    var detailConfig: TripDetailViewConfig
    var config: TripListViewConfig
    
    init(viewModel: HistoryPageViewModel, detailConfig: TripDetailViewConfig, config: TripListViewConfig) {
        self.viewModel = viewModel
        self.detailConfig =  detailConfig
        self.config = config
        super.init(nibName: String(describing: HistoryPageVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(HistoryPageView.nib, forCellReuseIdentifier: "HistoryPageView")
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 50
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setToPosition(position: Int) {
        self.tableView.selectRow(at: IndexPath(row: position, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.middle)
    }
}

extension HistoryPageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell : HistoryPageView = tableView.dequeueReusableCell(withIdentifier: "HistoryPageView") as? HistoryPageView {
            let event = self.viewModel.events[indexPath.row]
            cell.configure(event: event, detailConfig: self.detailConfig)
            cell.selectedBackgroundView?.backgroundColor = config.secondaryColor.withAlphaComponent(0.5)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension HistoryPageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tripDetailViewModel.setSelectedEvent(position: indexPath.row)
    }
}
