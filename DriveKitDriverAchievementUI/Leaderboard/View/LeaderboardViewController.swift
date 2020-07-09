//
//  LeaderboardViewController.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 30/06/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class LeaderboardViewController : UIViewController {

    @IBOutlet private weak var headerContainer: UIStackView!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var leaderboardScoreView: LeaderboardScoreView? = nil
    private var leaderboardSelectors: LeaderboardSelectorsView? = nil
    private let viewModel = LeaderboardViewModel()
    private var ranks: [AnyDriverRank] = []

    public init() {
        super.init(nibName: String(describing: LeaderboardViewController.self), bundle: .driverAchievementUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateHeader()
        updateData()

        self.viewModel.delegate = self
        self.viewModel.update()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "RankingCell", bundle: .driverAchievementUIBundle), forCellWithReuseIdentifier: "RankingCell")
        self.collectionView.register(UINib(nibName: "RankingHeaderCell", bundle: .driverAchievementUIBundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RankingHeaderCell")
    }

    private func updateHeader() {
        self.headerContainer.removeAllSubviews()

        let leaderboardScoreView: LeaderboardScoreView?
        if self.viewModel.rankingTypes.count > 1 || self.viewModel.rankingSelectors.count > 1 {
            let leaderboardSelectors = Bundle.driverAchievementUIBundle?.loadNibNamed("LeaderboardSelectorsView", owner: nil, options: nil)?.first as? LeaderboardSelectorsView
            if let leaderboardSelectors = leaderboardSelectors {
                leaderboardSelectors.translatesAutoresizingMaskIntoConstraints = false
                self.headerContainer.addArrangedSubview(leaderboardSelectors)
                leaderboardSelectors.update(viewModel: self.viewModel)
            }
            self.leaderboardSelectors = leaderboardSelectors
            leaderboardScoreView = Bundle.driverAchievementUIBundle?.loadNibNamed("LeaderboardScoreSmall", owner: nil, options: nil)?.first as? LeaderboardScoreSmall
        } else {
            self.leaderboardSelectors = nil
            leaderboardScoreView = Bundle.driverAchievementUIBundle?.loadNibNamed("LeaderboardScoreBig", owner: nil, options: nil)?.first as? LeaderboardScoreBig
        }
        self.leaderboardScoreView = leaderboardScoreView
        if let leaderboardScoreView = leaderboardScoreView {
            leaderboardScoreView.translatesAutoresizingMaskIntoConstraints = false
            self.headerContainer.addArrangedSubview(leaderboardScoreView)
        }
    }

    private func updateData() {
        leaderboardScoreView?.update(currentDriverRank: self.viewModel.driverRank, rankingType: self.viewModel.selectedRankingType)

        if !self.ranks.isEmpty {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        self.ranks = self.viewModel.ranks
        self.collectionView.reloadData()
    }

}

extension LeaderboardViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ranks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingCell", for: indexPath)
        if let rankingCell = cell as? RankingCell {
            let driverRank = self.ranks[indexPath.item]
            rankingCell.update(driverRank: driverRank)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RankingHeaderCell", for: indexPath)
    }
}

extension LeaderboardViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 36)
    }

}

extension LeaderboardViewController : LeaderboardViewModelDelegate {
    func leaderboardDidUpdate() {
        updateData()
    }
}
