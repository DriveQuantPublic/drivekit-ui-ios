// swiftlint:disable no_magic_numbers
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
    case active, ranked, all
}

class ChallengeListVC: DKUIViewController {
    @IBOutlet private weak var headerContainer: UIView?
    @IBOutlet private weak var selectorHighlightView: UIView?
    @IBOutlet private weak var highlightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var activeTabButton: UIButton?
    @IBOutlet private weak var rankedButton: UIButton?
    @IBOutlet private weak var allButton: UIButton?
    @IBOutlet private weak var dateSelectorContainer: UIView?
    @IBOutlet private weak var collectionViewsContainer: UIView?
    @IBOutlet private weak var activeChallengesCollectionView: UICollectionView?
    @IBOutlet private weak var rankedChallengesCollectionView: UICollectionView?
    @IBOutlet private weak var allChallengesCollectionView: UICollectionView?
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
        
        switch viewModel.selectedTab {
            case .active:
                DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_list_active", viewController: self)
            case .ranked:
                DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_list_ranked", viewController: self)
            case .all:
                DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_list_all", viewController: self)
        }
    }

    func setupCollectionViews() {
        self.parentScrollView?.isScrollEnabled = false
        self.activeChallengesCollectionView?.register(UINib(nibName: "NoChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "NoChallengeCellIdentifier")
        self.activeChallengesCollectionView?.register(UINib(nibName: "ChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "ChallengeCellIdentifier")
        self.rankedChallengesCollectionView?.register(UINib(nibName: "NoChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "NoChallengeCellIdentifier")
        self.rankedChallengesCollectionView?.register(UINib(nibName: "ChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "ChallengeCellIdentifier")
        self.allChallengesCollectionView?.register(UINib(nibName: "NoChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "NoChallengeCellIdentifier")
        self.allChallengesCollectionView?.register(UINib(nibName: "ChallengeCell", bundle: .challengeUIBundle), forCellWithReuseIdentifier: "ChallengeCellIdentifier")
        let defaultBackgroundColor = DKDefaultColors.driveKitBackgroundColor
        self.activeChallengesCollectionView?.backgroundColor = defaultBackgroundColor
        self.rankedChallengesCollectionView?.backgroundColor = defaultBackgroundColor
        self.allChallengesCollectionView?.backgroundColor = defaultBackgroundColor
        self.collectionViewsContainer?.backgroundColor = defaultBackgroundColor

        self.activeChallengesCollectionView?.refreshControl = UIRefreshControl()
        self.activeChallengesCollectionView?.refreshControl?.addTarget(self, action: #selector(refreshChallenges(_ :)), for: .valueChanged)
        self.rankedChallengesCollectionView?.refreshControl = UIRefreshControl()
        self.rankedChallengesCollectionView?.refreshControl?.addTarget(self, action: #selector(refreshChallenges(_ :)), for: .valueChanged)
        self.allChallengesCollectionView?.refreshControl = UIRefreshControl()
        self.allChallengesCollectionView?.refreshControl?.addTarget(self, action: #selector(refreshChallenges(_ :)), for: .valueChanged)

    }

    func setupHeaders() {
        let font = DKStyles.smallText.style.applyTo(font: .primary)
        self.activeTabButton?.titleLabel?.font = font
        self.activeTabButton?.setTitle("dk_challenge_active".dkChallengeLocalized().uppercased(), for: .normal)
        self.rankedButton?.setTitle("dk_challenge_ranked".dkChallengeLocalized().uppercased(), for: .normal)
        self.rankedButton?.titleLabel?.font = font
        self.allButton?.setTitle("dk_challenge_all".dkChallengeLocalized().uppercased(), for: .normal)
        self.allButton?.titleLabel?.font = font
        self.selectorHighlightView?.backgroundColor = DKUIColors.secondaryColor.color
        updateSelectedButton()
        if let dateSelectorContainer = dateSelectorContainer {
            DKDateSelectorView.createDateSelectorView(
                configuredWith: self.viewModel.dateSelectorViewModel,
                embededIn: dateSelectorContainer
            )
        }
    }

    func updateSelectedTab() {
        switch self.viewModel.selectedTab {
        case .active:
            if let activeChallengesCollectionView = self.activeChallengesCollectionView {
                self.parentScrollView?.scrollRectToVisible(activeChallengesCollectionView.frame, animated: false)
            }
        case .ranked:
            if let rankedChallengesCollectionView = self.rankedChallengesCollectionView {
                self.parentScrollView?.scrollRectToVisible(rankedChallengesCollectionView.frame, animated: false)
            }
        case .all:
            if let allChallengesCollectionView = self.allChallengesCollectionView {
                self.parentScrollView?.scrollRectToVisible(allChallengesCollectionView.frame, animated: false)
            }
        }
        updateSelectedButton()
    }

    func updateSelectedButton() {
        switch self.viewModel.selectedTab {
        case .active:
            rankedButton?.setTitleColor(defaultColor, for: .normal)
            allButton?.setTitleColor(defaultColor, for: .normal)
            activeTabButton?.setTitleColor(DKUIColors.secondaryColor.color, for: .normal)
        case .ranked:
            rankedButton?.setTitleColor(DKUIColors.secondaryColor.color, for: .normal)
            activeTabButton?.setTitleColor(defaultColor, for: .normal)
            allButton?.setTitleColor(defaultColor, for: .normal)
        case .all:
            allButton?.setTitleColor(DKUIColors.secondaryColor.color, for: .normal)
            activeTabButton?.setTitleColor(defaultColor, for: .normal)
            rankedButton?.setTitleColor(defaultColor, for: .normal)
        }

    }
    @IBAction func selectActiveTab() {
        if viewModel.selectedTab != .active {
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_list_active", viewController: self)
        }
        viewModel.updateSelectedTab(challengeTab: .active)
        updateSelectedTab()
    }

    @IBAction func selectRankedTab() {
        if viewModel.selectedTab != .ranked {
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_list_ranked", viewController: self)
        }
        viewModel.updateSelectedTab(challengeTab: .ranked)
        updateSelectedTab()
    }

    @IBAction func selectAllTab() {
        if viewModel.selectedTab != .all {
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_list_all", viewController: self)
        }
        viewModel.updateSelectedTab(challengeTab: .all)
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
        guard self.viewIfLoaded?.window != nil else {
            return
        }
        if let refreshControl = activeChallengesCollectionView?.refreshControl {
            refreshControl.beginRefreshing()
        }
        if let refreshControl = rankedChallengesCollectionView?.refreshControl {
            refreshControl.beginRefreshing()
        }
        if let refreshControl = allChallengesCollectionView?.refreshControl {
            refreshControl.beginRefreshing()
        }

    }

    func onChallengesAvailable() {
        if let refreshControl = activeChallengesCollectionView?.refreshControl, refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        if let refreshControl = rankedChallengesCollectionView?.refreshControl, refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        if let refreshControl = allChallengesCollectionView?.refreshControl, refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        activeChallengesCollectionView?.reloadData()
        rankedChallengesCollectionView?.reloadData()
        allChallengesCollectionView?.reloadData()
        activeChallengesCollectionView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        rankedChallengesCollectionView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        allChallengesCollectionView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
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
        if collectionView == activeChallengesCollectionView {
            let count = self.viewModel.activeChallenges.count
            if indexPath.row < count {
                self.viewModel.challengeViewModelSelected(challengeViewModel: self.viewModel.activeChallenges[indexPath.row])
            }
        } else if collectionView == rankedChallengesCollectionView {
            let count = self.viewModel.rankedChallenges.count
            if indexPath.row < count {
                self.viewModel.challengeViewModelSelected(challengeViewModel: self.viewModel.rankedChallenges[indexPath.row])
            }
        } else if collectionView == allChallengesCollectionView {
            let count = self.viewModel.allChallenges.count
            if indexPath.row < count {
                self.viewModel.challengeViewModelSelected(challengeViewModel: self.viewModel.allChallenges[indexPath.row])
            }
        }
    }
}

extension ChallengeListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == activeChallengesCollectionView {
            let count = self.viewModel.activeChallenges.count
            return max(count, 1)
        } else if collectionView == rankedChallengesCollectionView {
            let count = self.viewModel.rankedChallenges.count
            return max(count, 1)
        } else if collectionView == allChallengesCollectionView {
            let count = self.viewModel.allChallenges.count
            return max(count, 1)
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        let sourceChallenges: [ChallengeItemViewModel]
        let cellTab: ChallengeListTab
        if collectionView == activeChallengesCollectionView {
            cellTab = .active
            sourceChallenges = self.viewModel.activeChallenges
        } else if collectionView == rankedChallengesCollectionView {
            cellTab = .ranked
            sourceChallenges = self.viewModel.rankedChallenges
        } else if collectionView == allChallengesCollectionView {
            cellTab = .all
            sourceChallenges = self.viewModel.allChallenges
        } else {
            sourceChallenges = []
            cellTab = .all
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoChallengeCellIdentifier", for: indexPath)
            return cell
        }

        if sourceChallenges.isEmpty {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoChallengeCellIdentifier", for: indexPath)
            if let noChallengeCell = cell as? NoChallengeCell {
                noChallengeCell.configure(viewModel: NoChallengeViewModel(text: viewModel.noChallengeMessage(for: cellTab)))
            }
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeCellIdentifier", for: indexPath)
            if let challengeCell = cell as? ChallengeCell, indexPath.row < sourceChallenges.count {
                challengeCell.configure(challenge: sourceChallenges[indexPath.row])
            }
        }
        return cell
    }
}

extension ChallengeListVC: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat
        if collectionView == activeChallengesCollectionView {
            let count = self.viewModel.activeChallenges.count
            if indexPath.row < count {
                height = self.viewModel.expectedCellHeight(challenge: self.viewModel.activeChallenges[indexPath.row], viewWdth: collectionView.frame.width)
            } else {
                height = collectionView.bounds.height
            }
        } else if collectionView == rankedChallengesCollectionView {
            let count = self.viewModel.rankedChallenges.count
            if indexPath.row < count {
                height = self.viewModel.expectedCellHeight(challenge: self.viewModel.rankedChallenges[indexPath.row], viewWdth: collectionView.frame.width)
            } else {
                height = collectionView.bounds.height
            }
        } else if collectionView == allChallengesCollectionView {
            let count = self.viewModel.allChallenges.count
            if indexPath.row < count {
                height = self.viewModel.expectedCellHeight(challenge: self.viewModel.allChallenges[indexPath.row], viewWdth: collectionView.frame.width)
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
            self.highlightConstraint?.constant = scrollView.contentOffset.x / 3
        }
    }
}
