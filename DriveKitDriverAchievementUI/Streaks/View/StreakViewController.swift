//
//  StreakVCViewController.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 07/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDriverAchievementModule

public class StreakViewController: DKUIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private let viewModel: StreakViewModel
    
    public init() {
        self.viewModel = StreakViewModel()
        super.init(nibName: String(describing: StreakViewController.self), bundle: Bundle.driverAchievementUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "dk_achievements_menu_streaks".dkAchievementLocalized()
        self.viewModel.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(update), for: .valueChanged)
        self.refreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPoint(x: 0, y: -self.refreshControl.bounds.size.height), animated: true)
        let nib = UINib(nibName: "StreakTableViewCell", bundle: Bundle.driverAchievementUIBundle)
        self.tableView.register(nib, forCellReuseIdentifier: "StreakTableViewCell")
        update()
    }

    @objc private func update() {
        self.viewModel.getStreakData()
    }
}

extension StreakViewController: StreakVMDelegate {
    func failedToUpdateStreak(status: StreakSyncStatus) {
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.showAlertMessage(title: nil, message: "dk_achievements_failed_to_sync_streaks".dkAchievementLocalized(), back: false, cancel: false)
        }
    }
    
    func streaksUpdated(status: StreakSyncStatus) {
        DispatchQueue.main.async{
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.tableView.reloadData()
            if status == .failedToSyncStreakCacheOnly {
                self.showAlertMessage(title: nil, message: "dk_achievements_failed_to_sync_streaks".dkAchievementLocalized(), back: false, cancel: false)
            }
        }
    }
}

extension StreakViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.streakData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: StreakTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StreakTableViewCell", for: indexPath) as? StreakTableViewCell {
            cell.configure(streakData: self.viewModel.streakData[indexPath.row], viewController: self)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension StreakViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
