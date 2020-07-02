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

    public init() {
        super.init(nibName: String(describing: LeaderboardViewController.self), bundle: .driverAchievementUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateHeader()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "RankingCell", bundle: .driverAchievementUIBundle), forCellWithReuseIdentifier: "RankingCell")
        //        self.collectionView.register(UINib(nibName: "RankingHeaderCell", bundle: .driverAchievementUIBundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RankingHeaderCell")
    }

    private func updateHeader() {
        self.headerContainer.subviews.forEach { $0.removeFromSuperview() }

        let leaderboardSelectors = Bundle.driverAchievementUIBundle?.loadNibNamed("LeaderboardSelectors", owner: nil, options: nil)?.first as? LeaderboardSelectors
        if let leaderboardSelectors = leaderboardSelectors {
            leaderboardSelectors.translatesAutoresizingMaskIntoConstraints = false
            self.headerContainer.addArrangedSubview(leaderboardSelectors)
        }

        let leaderboardScoreSmall = Bundle.driverAchievementUIBundle?.loadNibNamed("LeaderboardScoreSmall", owner: nil, options: nil)?.first as? LeaderboardScoreSmall
        if let leaderboardScoreSmall = leaderboardScoreSmall {
            leaderboardScoreSmall.translatesAutoresizingMaskIntoConstraints = false
            self.headerContainer.addArrangedSubview(leaderboardScoreSmall)
        }
    }

}

extension LeaderboardViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "RankingCell", for: indexPath)
    }

    //    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RankingHeaderCell", for: indexPath)
    //    }
}

extension LeaderboardViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        return CGSize(width: collectionView.bounds.width, height: 70)
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        self.showLoader()
    //        viewModel.onCollectionViewItemSelected(pos: indexPath.row, completion: { status in
    //            if status == .noData {
    //                self.hideLoader()
    //                self.showAlertMessage(title: nil, message: "dk_vehicle_no_data".dkVehicleLocalized(), back: false, cancel: false)
    //            }
    //        })
    //    }

}
