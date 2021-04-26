//
//  DKDriverRankingCollectionViewController.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 22/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

public class DKDriverRankingCollectionVC: UICollectionViewController {

    var viewModel: DKDriverRankingViewModel?

    public init(viewModel: DKDriverRankingViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionHeadersPinToVisibleBounds = true
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView.backgroundColor = DKUIColors.backgroundView.color
        self.collectionView.register(UINib(nibName: "RankingCell", bundle: .driveKitCommonUIBundle), forCellWithReuseIdentifier: "RankingCell")
        self.collectionView.register(UINib(nibName: "RankingJumpCell", bundle: .driveKitCommonUIBundle), forCellWithReuseIdentifier: "RankingJumpCell")
        self.collectionView.register(UINib(nibName: "RankingHeaderReusableView", bundle: Bundle.driveKitCommonUIBundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RankingHeaderReusableViewIdentifier")

    }

    // MARK: UICollectionViewDataSource
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.ranking?.getDriverRankingItems().count ?? 0
    }

    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        if let rankingItems = self.viewModel?.ranking?.getDriverRankingItems(), indexPath.item < rankingItems.count, !rankingItems[indexPath.item].isJumpRank()  {
                let driverRank = rankingItems[indexPath.item]
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingCell", for: indexPath)
                if let rankingCell = cell as? RankingCell {
                    rankingCell.update(driverRank: driverRank)
                }
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingJumpCell", for: indexPath)
            }
        return cell
    }

    public override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader, let ranking = self.viewModel?.ranking, let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RankingHeaderReusableViewIdentifier", for: indexPath) as? RankingHeaderReusableView {
            // cleanup code
            let rankingScoreView: RankingScoreView?
            if ranking.getHeaderDisplayType() == .compact {
                rankingScoreView = Bundle.driveKitCommonUIBundle?.loadNibNamed("RankingScoreSmall", owner: nil, options: nil)?.first as? RankingScoreSmall
            } else {
                rankingScoreView = Bundle.driveKitCommonUIBundle?.loadNibNamed("RankingScoreBig", owner: nil, options: nil)?.first as? RankingScoreBig
            }

            if let rankingScoreView = rankingScoreView {
                rankingScoreView.translatesAutoresizingMaskIntoConstraints = false
                headerView.updateScoreTitle(title: ranking.getScoreTitle())
                headerView.embedSummaryView(summaryView: rankingScoreView)
            }

            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
}


extension DKDriverRankingCollectionVC: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let rankingItems = self.viewModel?.ranking?.getDriverRankingItems(), indexPath.item < rankingItems.count else {
            return CGSize()
        }
        let height = CGFloat(rankingItems[indexPath.item].isJumpRank() ? 50 : 60)
        return CGSize(width: collectionView.bounds.width, height: height)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var expectedHeight: CGFloat = 106.0
        if self.viewModel?.ranking?.getHeaderDisplayType() == .full {
            expectedHeight += 90.0
        }
        return CGSize(width: collectionView.frame.width, height: expectedHeight)
    }
}
