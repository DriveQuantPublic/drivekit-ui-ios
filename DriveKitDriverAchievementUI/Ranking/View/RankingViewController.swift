//
//  RankingViewController.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 30/06/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class RankingViewController : UIViewController {

    @IBOutlet private weak var headerContainer: UIStackView!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var rankingScoreView: RankingScoreView? = nil
    private var rankingSelectors: RankingSelectorsView? = nil
    private let viewModel = RankingViewModel()
    private var ranks: [AnyDriverRank] = []

    public init() {
        super.init(nibName: String(describing: RankingViewController.self), bundle: .driverAchievementUIBundle)
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

        let rankingScoreView: RankingScoreView?
        if self.viewModel.rankingTypes.count > 1 || self.viewModel.rankingSelectors.count > 1 {
            let rankingSelectors = Bundle.driverAchievementUIBundle?.loadNibNamed("RankingSelectorsView", owner: nil, options: nil)?.first as? RankingSelectorsView
            if let rankingSelectors = rankingSelectors {
                rankingSelectors.translatesAutoresizingMaskIntoConstraints = false
                self.headerContainer.addArrangedSubview(rankingSelectors)
                rankingSelectors.update(viewModel: self.viewModel)
            }
            self.rankingSelectors = rankingSelectors
            if self.viewModel.driverRank != nil {
                rankingScoreView = Bundle.driverAchievementUIBundle?.loadNibNamed("RankingScoreSmall", owner: nil, options: nil)?.first as? RankingScoreSmall
            } else {
                rankingScoreView = nil
            }
        } else {
            self.rankingSelectors = nil
            rankingScoreView = Bundle.driverAchievementUIBundle?.loadNibNamed("RankingScoreBig", owner: nil, options: nil)?.first as? RankingScoreBig
        }
        self.rankingScoreView = rankingScoreView
        if let rankingScoreView = rankingScoreView {
            rankingScoreView.translatesAutoresizingMaskIntoConstraints = false
            self.headerContainer.addArrangedSubview(rankingScoreView)
        }
    }

    private func updateData() {
        rankingScoreView?.update(currentDriverRank: self.viewModel.driverRank, rankingType: self.viewModel.selectedRankingType)

        if !self.ranks.isEmpty {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        self.ranks = self.viewModel.ranks
        self.collectionView.reloadData()
    }

}

extension RankingViewController : UICollectionViewDataSource {
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

extension RankingViewController : UICollectionViewDelegateFlowLayout {
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

extension RankingViewController : RankingViewModelDelegate {
    func rankingDidUpdate() {
        if (self.viewModel.driverRank != nil && self.rankingScoreView == nil) || (self.viewModel.driverRank == nil && self.rankingScoreView != nil) {
            updateHeader()
        }
        updateData()
    }
}
