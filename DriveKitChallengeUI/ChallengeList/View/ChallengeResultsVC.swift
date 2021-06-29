//
//  ChallengeResultsVC.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 28/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ChallengeResultsVC: DKUIViewController {
    private let viewModel: ChallengeResultsViewModel?
    @IBOutlet private weak var tableView: UITableView?

    public init(viewModel: ChallengeResultsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ChallengeResultsVC.self), bundle: Bundle.challengeUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func refreshUI() {
        tableView?.reloadData()
    }

    func setupTableView() {
        if let tableView = tableView {
            let backView = UIView(frame: tableView.bounds)
                backView.backgroundColor = DKDefaultColors.driveKitBackgroundColor
            tableView.backgroundView = backView
            tableView.register(ChallengeStatCell.nib, forCellReuseIdentifier: "ChallengeStatCellIdentifier")
            tableView.register(ChallengeResultOverviewCell.nib, forCellReuseIdentifier: "ChallengeResultOverviewCellIdentifier")
        }
    }
}

extension ChallengeResultsVC: UITableViewDelegate {
    
}

extension ChallengeResultsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return viewModel?.challengeStats.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            if let cell: ChallengeResultOverviewCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeResultOverviewCellIdentifier", for: indexPath) as? ChallengeResultOverviewCell, let viewModel = viewModel {
                cell.clipsToBounds = false
                cell.selectionStyle = .none
                cell.configureCell(viewModel: viewModel)
            return cell
            }
        } else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeStatCellIdentifier"),
               let statCell: ChallengeStatCell = cell as? ChallengeStatCell,
               let viewModel = viewModel,
               indexPath.row < viewModel.challengeStats.count {
                let type = viewModel.challengeStats[indexPath.row]
                statCell.configure(viewModel: viewModel, type: type)
                return statCell
            }
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ChallengeResultHeaderCell")
        cell.clipsToBounds = false
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = DKDefaultColors.driveKitBackgroundColor
        cell.textLabel?.attributedText = self.viewModel?.getHeaderCellAttributedString()
        return cell
    }
}
