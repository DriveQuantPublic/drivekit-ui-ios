//
//  RankingViewController.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 30/06/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class RankingViewController : DKUIViewController {

    @IBOutlet private weak var headerContainer: UIStackView!
    @IBOutlet private weak var collectionViewHeader_rankLabel: UILabel!
    @IBOutlet private weak var collectionViewHeader_driverLabel: UILabel!
    @IBOutlet private weak var collectionViewHeader_scoreLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    private var rankingScoreView: RankingScoreView? = nil
    private var rankingSelectors: RankingSelectorsView? = nil
    private let viewModel = RankingViewModel()
    private var ranks: [AnyDriverRank?] = []

    public init() {
        super.init(nibName: String(describing: RankingViewController.self), bundle: .driverAchievementUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionViewHeader_rankLabel.attributedText = "dk_achievements_ranking_rank".dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        self.collectionViewHeader_driverLabel.attributedText = "dk_achievements_ranking_driver".dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        self.collectionViewHeader_scoreLabel.attributedText = "dk_achievements_ranking_score".dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()

        updateHeader()
        updateData()

        self.viewModel.delegate = self
        self.viewModel.update()

        self.collectionView.backgroundColor = DKUIColors.backgroundView.color
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "RankingCell", bundle: .driverAchievementUIBundle), forCellWithReuseIdentifier: "RankingCell")
        self.collectionView.register(UINib(nibName: "RankingJumpCell", bundle: .driverAchievementUIBundle), forCellWithReuseIdentifier: "RankingJumpCell")
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
            rankingScoreView = Bundle.driverAchievementUIBundle?.loadNibNamed("RankingScoreSmall", owner: nil, options: nil)?.first as? RankingScoreSmall
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
        self.rankingScoreView?.update(currentDriverRank: self.viewModel.driverRank, rankingType: self.viewModel.selectedRankingType, nbDrivers: self.viewModel.nbDrivers)

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
        let cell: UICollectionViewCell
        if let driverRank = self.ranks[indexPath.item] {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingCell", for: indexPath)
            if let rankingCell = cell as? RankingCell {
                rankingCell.update(driverRank: driverRank)
            }
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingJumpCell", for: indexPath)
        }
        return cell
    }
}

extension RankingViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat(self.ranks[indexPath.item] != nil ? 60 : 50)
        return CGSize(width: collectionView.bounds.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension RankingViewController : RankingViewModelDelegate {
    func rankingDidUpdate() {
        if self.viewModel.status == .updating {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                if self.viewModel.status == .updating {
                    self.loadingView.startAnimating()
                    self.collectionView.isHidden = true
                }
            }
        } else {
            self.collectionView.isHidden = false
            self.loadingView.stopAnimating()
            if (self.viewModel.driverRank != nil && self.rankingScoreView == nil) || (self.viewModel.driverRank == nil && self.rankingScoreView != nil) {
                updateHeader()
            }
            updateData()
        }
    }
}
