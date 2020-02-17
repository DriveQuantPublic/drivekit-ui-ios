//
//  StreakVCViewController.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 07/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public class StreakViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel : StreakViewModel
    
    private let config : DriverAchievementConfig
    
    public init(config : DriverAchievementConfig) {
        self.viewModel = StreakViewModel()
        self.config = config
        super.init(nibName: String(describing: StreakViewController.self), bundle: Bundle.driverAchievementUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.viewModel.getStreakData()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let nib = UINib(nibName: "StreakTableViewCell", bundle: Bundle.driverAchievementUIBundle)
        tableView.register(nib, forCellReuseIdentifier: "StreakTableViewCell")
    }
}

extension StreakViewController : StreakVMDelegate {
    func streaksUpdated() {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
}

extension StreakViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.streakData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell : StreakTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StreakTableViewCell", for: indexPath) as? StreakTableViewCell {
            cell.configure(streakData: self.viewModel.streakData[indexPath.row], config: config, viewController: self)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension StreakViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension Bundle {
    static let driverAchievementUIBundle = Bundle(identifier: "com.drivequant.drivekit-driver-achievement-ui")
}
