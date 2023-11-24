// swiftlint:disable no_magic_numbers
//
//  NotificationSettingsViewController.swift
//  DriveKitApp
//
//  Created by David Bauduin on 28/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class NotificationSettingsViewController: UITableViewController {
    private var viewModel: NotificationSettingsViewModel = NotificationSettingsViewModel()

    init() {
        super.init(nibName: String(describing: NotificationSettingsViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        setupView()
    }

    private func setupView() {
        self.title = "notifications_header".keyLocalized()
        configureBackButton()
        self.tableView.register(NotificationSettingsTextCell.nib, forCellReuseIdentifier: "NotificationSettingsTextCell")
        self.tableView.register(NotificationSettingsConfigurationCell.nib, forCellReuseIdentifier: "NotificationSettingsConfigurationCell")
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.viewModel.itemsNumber
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationSettingsTextCell", for: indexPath) as? NotificationSettingsTextCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard let configurationCell = tableView.dequeueReusableCell(
                withIdentifier: "NotificationSettingsConfigurationCell",
                for: indexPath
            ) as? NotificationSettingsConfigurationCell else {
                return UITableViewCell()
            }
            configurationCell.updateWith(self.viewModel.viewModels[indexPath.row])
            return configurationCell
        }
    }

    private func configureBackButton() {
        DKUIViewController.configureBackButton(viewController: self, selector: #selector(onBack))
    }

    @objc private func onBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NotificationSettingsViewController: NotificationSettingsDelegate {
    func settingsDidUpdate() {
        self.tableView.reloadData()
    }
}
