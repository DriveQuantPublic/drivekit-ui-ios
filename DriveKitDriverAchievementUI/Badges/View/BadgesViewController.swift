//
//  BadgesViewController.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/12/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDriverAchievement
import DriveKitDBAchievementAccess

public class BadgesViewController : DKUIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel : BadgeViewModel

    public init() {
        self.viewModel = BadgeViewModel()
        super.init(nibName: String(describing: BadgesViewController.self), bundle: Bundle.driverAchievementUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goToBadgeLevelDetailView(_ notification: Notification) {
        let vc = BadgeLevelDetailViewController(level: (notification.userInfo!["badgeCharacteristics"] as? DKBadgeCharacteristics)!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "menu_mybadges".dkAchievementLocalized()
        self.viewModel.delegate = self
        self.viewModel.updateBadges()
        self.showLoader()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let nib = UINib(nibName: "BadgeTableViewCell", bundle: Bundle.driverAchievementUIBundle)
        tableView.register(nib, forCellReuseIdentifier: "BadgeTableViewCell")
        NotificationCenter.default.addObserver(self, selector: #selector(goToBadgeLevelDetailView),
                                               name: Notification.Name("goToDetailView"),
                                               object: nil)
    }
}

extension BadgesViewController : UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.badgesCount
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BadgeTableViewCell", for: indexPath) as? BadgeTableViewCell else {
            fatalError("The dequeued cell is not an instance of BadgeCell.")
        }
        cell.configure(levels: viewModel.badgeLevels(pos: indexPath.section))
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = BadgeSectionHeaderView.viewFromNib
        sectionView.configure(theme: viewModel.badgeTitle(pos: section))
        return sectionView
    }
}

extension BadgesViewController : BadgeDelegate {
    func badgesUpdated() {
        tableView.reloadData()
        self.hideLoader()
    }
}
