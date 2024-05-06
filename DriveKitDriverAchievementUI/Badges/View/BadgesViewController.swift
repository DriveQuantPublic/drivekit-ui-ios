//
//  BadgesViewController.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/12/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDriverAchievementModule
import DriveKitDBAchievementAccessModule

public class BadgesViewController: DKUIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var bronzeCountLabel: UILabel!
    @IBOutlet weak var silverCountLabel: UILabel!
    @IBOutlet weak var goldCountLabel: UILabel!
    
    private let refreshControl = UIRefreshControl()
    
    private let viewModel: BadgeViewModel

    public init() {
        self.viewModel = BadgeViewModel()
        super.init(nibName: String(describing: BadgesViewController.self), bundle: Bundle.driverAchievementUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goToBadgeLevelDetailView(_ notification: Notification) {
        if let navigationController = self.navigationController {
            let vc = BadgeLevelDetailViewController(level: (notification.userInfo!["badgeCharacteristics"] as? DKBadgeCharacteristics)!)
            navigationController.pushViewController(vc, animated: true)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DKShowBadgeLevelDetail"), object: nil, userInfo: notification.userInfo!)
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "menu_mybadges".dkAchievementLocalized()
        self.viewModel.delegate = self
        self.tableView.backgroundColor = DKUIColors.backgroundView.color
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(update), for: .valueChanged)
        self.tableView.setContentOffset(CGPoint(x: 0, y: -self.refreshControl.bounds.size.height), animated: true)
        if #available(iOS 15, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
        let nib = UINib(nibName: "BadgeTableViewCell", bundle: Bundle.driverAchievementUIBundle)
        self.tableView.register(nib, forCellReuseIdentifier: "BadgeTableViewCell")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(goToBadgeLevelDetailView),
                                               name: Notification.Name("goToDetailView"),
                                               object: nil)
        setupCountHeader()
        fillCountHeader()
        update()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.viewModel.updating {
            self.refreshControl.beginRefreshing()
        } else {
            self.refreshControl.endRefreshing()
        }
    }

    private func setupCountHeader() {
        let cornerRadius: CGFloat = 4
        let borderWidth: CGFloat = 1.5
        self.bronzeCountLabel.layer.borderColor = self.viewModel.darkColorForLevel(.bronze).cgColor
        self.bronzeCountLabel.layer.borderWidth = borderWidth
        self.bronzeCountLabel.layer.cornerRadius = cornerRadius
        self.silverCountLabel.layer.borderColor = self.viewModel.darkColorForLevel(.silver).cgColor
        self.silverCountLabel.layer.borderWidth = borderWidth
        self.silverCountLabel.layer.cornerRadius = cornerRadius
        self.goldCountLabel.layer.borderColor = self.viewModel.darkColorForLevel(.gold).cgColor
        self.goldCountLabel.layer.borderWidth = borderWidth
        self.goldCountLabel.layer.cornerRadius = cornerRadius
    }

    private func fillCountHeader() {
        self.bronzeCountLabel.attributedText = self.viewModel.attributedTextForLevel(.bronze)
        self.silverCountLabel.attributedText = self.viewModel.attributedTextForLevel(.silver)
        self.goldCountLabel.attributedText = self.viewModel.attributedTextForLevel(.gold)
        self.totalCountLabel.attributedText = self.viewModel.attributedTextForTotalCount()
    }

    @objc private func update() {
        self.viewModel.updateBadges()
    }
}

extension BadgesViewController: UITableViewDataSource {
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

extension BadgesViewController: BadgeDelegate {
    func badgesUpdated() {
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        self.tableView.reloadData()
        self.fillCountHeader()
    }
}
