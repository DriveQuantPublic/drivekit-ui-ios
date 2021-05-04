//
//  ChallengeListVC.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 29/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class ChallengeListVC: DKUIViewController {
    @IBOutlet private weak var headerContainer: UIView?
    @IBOutlet private weak var currentChallengesCollectionView: UICollectionView?
    @IBOutlet private weak var pastChallengesCollectionView: UICollectionView?
    private let viewModel: ChallengeListViewModel

    public init() {
        self.viewModel = ChallengeListViewModel()
        super.init(nibName: String(describing: ChallengeListVC.self), bundle: Bundle.challengeUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "dk_challenge_menu".dkChallengeLocalized()
        self.viewModel.delegate = self
        self.currentChallengesCollectionView?.register(UINib(nibName: "NoChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "NoChallengeCellIdentifier")
        self.currentChallengesCollectionView?.register(UINib(nibName: "ChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "ChallengeCellIdentifier")
        self.pastChallengesCollectionView?.register(UINib(nibName: "NoChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "NoChallengeCellIdentifier")
        self.pastChallengesCollectionView?.register(UINib(nibName: "ChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "ChallengeCellIdentifier")

        setupHeaders()
    }

    func setupHeaders() {
        
    }
}

extension ChallengeListVC: ChallengeListDelegate {
    func onChallengesAvailable() {
    }

    func didReceiveErrorFromService() {
    }

    func showAlert(_ alertController: UIAlertController) {
    }

    func showViewController(_ viewController: UIViewController, animated: Bool) {
    }
}

extension ChallengeListVC: UICollectionViewDelegate {
    
}

extension ChallengeListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoChallengeCellIdentifier", for: indexPath)
        return cell
    }
}
