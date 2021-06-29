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
    private let defaultColor = UIColor(red: 153, green: 153, blue: 153)

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.selectedTab == .current {
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_list_active", viewController: self)
        } else if viewModel.selectedTab == .past {
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_list_finished", viewController: self)
        }
    }

    func setupCollectionViews() {
        self.currentChallengesCollectionView?.register(UINib(nibName: "NoChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "NoChallengeCellIdentifier")
        self.currentChallengesCollectionView?.register(UINib(nibName: "ChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "ChallengeCellIdentifier")
        self.pastChallengesCollectionView?.register(UINib(nibName: "NoChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "NoChallengeCellIdentifier")
        self.pastChallengesCollectionView?.register(UINib(nibName: "ChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "ChallengeCellIdentifier")
        let defaultBackgroundColor = DKDefaultColors.driveKitBackgroundColor
        self.currentChallengesCollectionView?.backgroundColor = defaultBackgroundColor
        self.pastChallengesCollectionView?.backgroundColor = defaultBackgroundColor
        
        self.currentChallengesCollectionView?.refreshControl = UIRefreshControl()
        self.currentChallengesCollectionView?.refreshControl?.addTarget(self, action: #selector(refreshChallenges(_ :)), for: .valueChanged)
        self.pastChallengesCollectionView?.refreshControl = UIRefreshControl()
        self.pastChallengesCollectionView?.refreshControl?.addTarget(self, action: #selector(refreshChallenges(_ :)), for: .valueChanged)
    }

    func setupHeaders() {
        self.currentTabButton?.setTitle("dk_challenge_active".dkChallengeLocalized().uppercased(), for: .normal)
        self.pastTabButton?.setTitle("dk_challenge_finished".dkChallengeLocalized().uppercased(), for: .normal)
        self.selectorHighlightView?.backgroundColor = DKUIColors.secondaryColor.color
        updateSelectedButton()
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
        updateSelectedButton()
    }

    func updateSelectedButton() {
        switch self.viewModel.selectedTab {
        case .current:
            pastTabButton?.setTitleColor(defaultColor, for: .normal)
            currentTabButton?.setTitleColor(DKUIColors.secondaryColor.color, for: .normal)
        case .past:
            pastTabButton?.setTitleColor(DKUIColors.secondaryColor.color, for: .normal)
            currentTabButton?.setTitleColor(defaultColor, for: .normal)
        }

    }
    @IBAction func selectCurrentTab() {
        if viewModel.selectedTab != .current {
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_list_active", viewController: self)
        }
        viewModel.updateSelectedTab(challengeTab: .current)
        updateSelectedTab()
    }

    @IBAction func selectPastTab() {
        if viewModel.selectedTab != .past {
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_list_finished", viewController: self)
        }
        viewModel.updateSelectedTab(challengeTab: .past)
        updateSelectedTab()
    }

    func refresh() {
        DispatchQueue.main.async {
            self.viewModel.fetchChallenges(fromServer: false)
        }
    }

    @objc func refreshChallenges(_ sender: Any) {
        self.viewModel.fetchChallenges()
    }
}

extension ChallengeListVC: ChallengeListDelegate {
    func challengesFetchStarted() {
        if let refreshControl = currentChallengesCollectionView?.refreshControl {
            refreshControl.beginRefreshing()
        }
        if let refreshControl = pastChallengesCollectionView?.refreshControl {
            refreshControl.beginRefreshing()
        }
    }

    func onChallengesAvailable() {
        if let refreshControl = currentChallengesCollectionView?.refreshControl, refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        if let refreshControl = pastChallengesCollectionView?.refreshControl, refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        currentChallengesCollectionView?.reloadData()
        pastChallengesCollectionView?.reloadData()
    }

    func didReceiveErrorFromService() {
    }

    func showAlert(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }

    func showViewController(_ viewController: UIViewController, animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension ChallengeListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == currentChallengesCollectionView {
            let count = self.viewModel.currentChallenges.count
            if indexPath.row < count {
                self.viewModel.challengeViewModelSelected(challengeViewModel: self.viewModel.currentChallenges[indexPath.row])
            }
        } else if collectionView == pastChallengesCollectionView {
            let count = self.viewModel.pastChallenges.count
            if indexPath.row < count {
                self.viewModel.challengeViewModelSelected(challengeViewModel: self.viewModel.pastChallenges[indexPath.row])
            }
        }
    }
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
                    challengeCell.configure(challenge: self.viewModel.currentChallenges[indexPath.row])
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
                    challengeCell.configure(challenge: self.viewModel.pastChallenges[indexPath.row])
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == parentScrollView {
            let isCurrentTab = Int(scrollView.contentOffset.x / (scrollView.frame.width / 2)) == 0
            if isCurrentTab, viewModel.selectedTab != .current {
                viewModel.updateSelectedTab(challengeTab: .current)
                DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_list_active", viewController: self)
            } else if !isCurrentTab, viewModel.selectedTab != .past {
                viewModel.updateSelectedTab(challengeTab: .past)
                DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_list_finished", viewController: self)
            }
            updateSelectedButton()
        }
    }
}
