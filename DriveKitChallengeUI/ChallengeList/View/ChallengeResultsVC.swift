//
//  ChallengeResultsVC.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 28/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

class ChallengeResultsVC: UIViewController {
    private let viewModel: ChallengeResultsViewModel?

    public init(viewModel: ChallengeResultsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ChallengeResultsVC.self), bundle: Bundle.challengeUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ChallengeResultsVC: UITableViewDelegate {
    
}

extension ChallengeResultsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
