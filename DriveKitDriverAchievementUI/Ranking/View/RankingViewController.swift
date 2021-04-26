//
//  RankingViewController.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 30/06/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class RankingViewController: DKUIViewController {

    @IBOutlet private weak var headerContainer: UIStackView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var viewContainer: UIView!
    // TODO: cleanup code
    //private var rankingScoreView: RankingScoreView? = nil
    private var rankingSelectors: RankingSelectorsView? = nil
    private let viewModel = RankingViewModel()
    private var ranks: [DKDriverRankingItem] = []

    public init() {
        super.init(nibName: String(describing: RankingViewController.self), bundle: .driverAchievementUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "dk_achievements_ranking_menu_ranking".dkAchievementLocalized()

        let driverRankingViewModel = DKDriverRankingViewModel(ranking: self.viewModel)
        let driverRankingCollectionVC = DKDriverRankingCollectionVC(viewModel: driverRankingViewModel)
        self.addChild(driverRankingCollectionVC)
        if let collectionView = driverRankingCollectionVC.collectionView {
            self.collectionView = collectionView
            self.viewContainer.embedSubview(collectionView)
        }

        updateHeader()
        updateData()

        self.viewModel.delegate = self
        self.viewModel.update()

    }

    private func updateHeader() {
        self.headerContainer.removeAllSubviews()

        if self.viewModel.rankingTypes.count > 1 || self.viewModel.rankingSelectors.count > 1 {
            let rankingSelectors = Bundle.driverAchievementUIBundle?.loadNibNamed("RankingSelectorsView", owner: nil, options: nil)?.first as? RankingSelectorsView
            if let rankingSelectors = rankingSelectors {
                rankingSelectors.translatesAutoresizingMaskIntoConstraints = false
                self.headerContainer.addArrangedSubview(rankingSelectors)
                rankingSelectors.update(viewModel: self.viewModel)
            }
            self.rankingSelectors = rankingSelectors
        } else {
            self.rankingSelectors = nil
        }
        // TODO: move the header related code inside DriveKitCommonUI
//        let rankingScoreView: RankingScoreView?
//        if self.viewModel.getHeaderDisplayType() == .compact {
//            rankingScoreView = Bundle.driverAchievementUIBundle?.loadNibNamed("RankingScoreSmall", owner: nil, options: nil)?.first as? RankingScoreSmall
//        } else {
//            rankingScoreView = Bundle.driverAchievementUIBundle?.loadNibNamed("RankingScoreBig", owner: nil, options: nil)?.first as? RankingScoreBig
//        }
//        self.rankingScoreView = rankingScoreView
//        if let rankingScoreView = rankingScoreView {
//            rankingScoreView.translatesAutoresizingMaskIntoConstraints = false
//            self.headerContainer.addArrangedSubview(rankingScoreView)
//        }
    }

    private func updateData() {
        // TODO: move rankingScoreView code into CommonUI
//        self.rankingScoreView?.update(currentDriverRank: self.viewModel.driverRank, rankingType: self.viewModel.selectedRankingType, nbDrivers: self.viewModel.nbDrivers)

        if !self.ranks.isEmpty {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        self.ranks = self.viewModel.ranks
        self.collectionView.reloadData()
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
            // TODO: clean up commented code
//            if (self.viewModel.driverRank != nil && self.rankingScoreView == nil) || (self.viewModel.driverRank == nil && self.rankingScoreView != nil) {
                updateHeader()
//            }
            updateData()
        }
    }
}
