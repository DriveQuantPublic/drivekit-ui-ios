// swiftlint:disable no_magic_numbers
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
    private let viewModel: RankingViewModel
    private var ranks: [DKDriverRankingItem] = []

    public init(groupName: String?) {
        self.viewModel = RankingViewModel(groupName: groupName)
        super.init(nibName: String(describing: RankingViewController.self), bundle: .driverAchievementUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "dk_achievements_ranking_menu_ranking".dkAchievementLocalized()
        let defaultBackgroundColor = DKDefaultColors.driveKitBackgroundColor
        self.view.backgroundColor = defaultBackgroundColor
        self.viewContainer.backgroundColor = defaultBackgroundColor

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
        self.viewModel.update(allowEmptyPseudo: false)
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
        } else {
            self.headerContainer.addArrangedSubview(UIView(frame: CGRect.zero))
        }
    }

    private func updateData() {
        if !self.ranks.isEmpty {
            self.collectionView.setContentOffset(CGPoint.zero, animated: false)
        }
        self.ranks = self.viewModel.ranks
        self.collectionView.reloadData()
    }

}

extension RankingViewController: RankingViewModelDelegate {
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
            updateHeader()
            updateData()
        }
    }

    func updateUserPseudo() {
        let userPseudoViewController = UserPseudoViewController { success in
            if success {
                self.viewModel.clearCache()
            }
            self.viewModel.update(allowEmptyPseudo: true)
            self.dismiss(animated: true, completion: nil)
        }
        self.present(userPseudoViewController, animated: true, completion: nil)
    }
}
