//
//  ChallengeListVC.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 29/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

public enum ChallengeListTab {
    case current, past
}

class ChallengeListVC: DKUIViewController {
    @IBOutlet private weak var headerContainer: UIView?
    @IBOutlet private weak var selectorHighlightView: UIView?
    @IBOutlet private weak var highlightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var currentTabButton: UIButton?
    @IBOutlet private weak var pastTabButton: UIButton?
    @IBOutlet private weak var currentChallengesCollectionView: UICollectionView?
    @IBOutlet private weak var pastChallengesCollectionView: UICollectionView?
    @IBOutlet private weak var parentScrollView: UIScrollView?
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
        setupCollectionViews()
        setupHeaders()
        self.viewModel.fetchChallenges()
    }

    func setupCollectionViews() {
        self.currentChallengesCollectionView?.register(UINib(nibName: "NoChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "NoChallengeCellIdentifier")
        self.currentChallengesCollectionView?.register(UINib(nibName: "ChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "ChallengeCellIdentifier")
        self.pastChallengesCollectionView?.register(UINib(nibName: "NoChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "NoChallengeCellIdentifier")
        self.pastChallengesCollectionView?.register(UINib(nibName: "ChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "ChallengeCellIdentifier")
        self.currentChallengesCollectionView?.backgroundColor = DKUIColors.backgroundView.color
        self.pastChallengesCollectionView?.backgroundColor = DKUIColors.backgroundView.color
    }

    func setupHeaders() {
        self.currentTabButton?.setTitle("dk_challenge_active".dkChallengeLocalized().uppercased(), for: .normal)
        self.pastTabButton?.setTitle("dk_challenge_finished".dkChallengeLocalized().uppercased(), for: .normal)
        self.currentTabButton?.setTitleColor(DKUIColors.mainFontColor.color, for: .normal)
        self.pastTabButton?.setTitleColor(DKUIColors.mainFontColor.color, for: .normal)
        self.selectorHighlightView?.backgroundColor = DKUIColors.secondaryColor.color
    }

    func updateSelectedTab() {
        switch self.viewModel.selectedTab {
        case .current:
            if let currentChallengesCollectionView = self.currentChallengesCollectionView {
                self.parentScrollView?.scrollRectToVisible(currentChallengesCollectionView.frame, animated: true)
            }
        case .past:
            if let pastChallengesCollectionView = self.pastChallengesCollectionView {
                self.parentScrollView?.scrollRectToVisible(pastChallengesCollectionView.frame, animated: true)
            }
        }
    }

    @IBAction func selectCurrentTab() {
        viewModel.updateSelectedTab(challengeTab: .current)
        updateSelectedTab()
    }

    @IBAction func selectPastTab() {
        viewModel.updateSelectedTab(challengeTab: .past)
        updateSelectedTab()
    }
}

extension ChallengeListVC: ChallengeListDelegate {
    func onChallengesAvailable() {
        currentChallengesCollectionView?.reloadData()
        pastChallengesCollectionView?.reloadData()
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
        if collectionView == currentChallengesCollectionView {
            let count = self.viewModel.currentChallenges.count
            return max(count, 1)
        } else if collectionView == pastChallengesCollectionView {
            let count = self.viewModel.pastChallenges.count
            return max(count, 1)
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        if collectionView == currentChallengesCollectionView {
            let count = self.viewModel.currentChallenges.count
            if count > 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeCellIdentifier", for: indexPath)
                if let challengeCell = cell as? ChallengeCell, indexPath.row < count {
                    challengeCell.configure(challenge: ChallengeItemViewModel(challenge: self.viewModel.currentChallenges[indexPath.row]))
                }
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoChallengeCellIdentifier", for: indexPath)
                if let noChallengeCell = cell as? NoChallengeCell {
                    noChallengeCell.configure(viewModel: NoChallengeViewModel(text: "dk_challenge_no_active_challenge".dkChallengeLocalized(), image: UIImage(named: "waiting", in: .challengeUIBundle, compatibleWith: nil)))
                }
            }
        } else if collectionView == pastChallengesCollectionView {
            let count = self.viewModel.pastChallenges.count
            if count > 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeCellIdentifier", for: indexPath)
                if let challengeCell = cell as? ChallengeCell, indexPath.row < count {
                    challengeCell.configure(challenge: ChallengeItemViewModel(challenge: self.viewModel.pastChallenges[indexPath.row]))
                }
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoChallengeCellIdentifier", for: indexPath)
                if let noChallengeCell = cell as? NoChallengeCell {
                    noChallengeCell.configure(viewModel: NoChallengeViewModel(text: "dk_challenge_no_finished_challenge".dkChallengeLocalized(), image: UIImage(named: "finish_flag", in: .challengeUIBundle, compatibleWith: nil)))
                }
            }
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoChallengeCellIdentifier", for: indexPath)
        }
        return cell
    }
}

extension ChallengeListVC: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat
        if collectionView == currentChallengesCollectionView {
            let count = self.viewModel.currentChallenges.count
            if indexPath.row < count {
                height = self.viewModel.expectedCellHeight(challenge: self.viewModel.currentChallenges[indexPath.row], viewWdth: collectionView.frame.width)
            } else {
                height = collectionView.bounds.height
            }
        } else if collectionView == pastChallengesCollectionView {
            let count = self.viewModel.pastChallenges.count
            if indexPath.row < count {
                height = self.viewModel.expectedCellHeight(challenge: self.viewModel.pastChallenges[indexPath.row], viewWdth: collectionView.frame.width)
            } else {
                height = collectionView.bounds.height
            }
        } else {
            height = collectionView.bounds.height
        }
        return CGSize(width: collectionView.bounds.width, height: height)
    }

}

extension ChallengeListVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == parentScrollView {
            self.highlightConstraint?.constant = scrollView.contentOffset.x / 2
        }
    }
}
