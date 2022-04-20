//
//  FeaturesViewController.swift
//  DriveKitApp
//
//  Created by David Bauduin on 18/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

class FeaturesViewController: UITableViewController {
    private var viewModel: FeaturesViewModel = FeaturesViewModel()

    init() {
        super.init(nibName: String(describing: FeaturesViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(FeatureViewCell.nib, forCellReuseIdentifier: "FeatureViewCell")
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.featureViewViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.viewModel.featureViewViewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureViewCell", for: indexPath) as! FeatureViewCell
        cell.update(with: viewModel, parentViewController: self)
        return cell
    }
}
