//
//  ChallengeDetailVCViewController.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 28/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

enum ChallengeDetaiItem {
    case results, ranking, tripList, rules
}

class ChallengeDetailVC: DKUIViewController {
    private let viewModel: ChallengeDetailViewModel
    @IBOutlet private weak var pageContainer: UIView?
    @IBOutlet private weak var statsTabButton: UIButton?
    @IBOutlet private weak var rankingTabButton: UIButton?
    @IBOutlet private weak var tripsTabButton: UIButton?
    @IBOutlet private weak var rulesTabButton: UIButton?
    @IBOutlet private weak var selectorHighlightView: UIView?
    @IBOutlet private weak var highlightConstraint: NSLayoutConstraint?

    var pageViewController: UIPageViewController?
    var tabsViewControllers: [UIViewController] = []

    public init(viewModel: ChallengeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ChallengeDetailVC.self), bundle: Bundle.challengeUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tabsViewControllers.append(ChallengeResultsVC(viewModel: viewModel.getResultsViewModel()))
        tabsViewControllers.append(DKDriverRankingCollectionVC(viewModel: viewModel.getRankingViewModel()))
        tabsViewControllers.append(ChallengeTripsVC(viewModel: viewModel))
        tabsViewControllers.append(ChallengeParticipationVC(viewModel: viewModel.getRulesViewModel(), parentView: self.navigationController))
        tripsTabButton?.setImage(DKImages.trip.image, for: .normal)
        selectorHighlightView?.backgroundColor = DKUIColors.secondaryColor.color
        setupPageContainer()
        title = viewModel.getChallengeName()
    }

    func setupPageContainer() {
        if self.pageViewController == nil {
            let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            self.pageViewController = pageViewController
            self.pageViewController?.dataSource = self
            self.pageViewController?.delegate = self
            if let mainViewController = self.tabsViewControllers.first {
                self.pageViewController?.setViewControllers([mainViewController], direction: .forward, animated: true, completion: nil)
            }
            self.pageViewController?.view.frame = CGRect(x: 0, y: 0, width: self.pageContainer?.frame.width ?? 0, height: self.pageContainer?.frame.height ?? 0)
            pageContainer?.addSubview(pageViewController.view)
            self.pageViewController?.didMove(toParent: self)
        }
    }

    @IBAction func selectTab(sender: UIButton) {
        guard let oldIndex = tabsViewControllers.firstIndex(of: pageViewController?.viewControllers?.first ?? UIViewController()) else { return }

        var selectedIndex = 0
        if sender == rankingTabButton {
            selectedIndex = 1
        } else if sender == tripsTabButton {
            selectedIndex = 2
        } else if sender == rulesTabButton {
            selectedIndex = 3
        }
        if selectedIndex < tabsViewControllers.count {
            let mainViewController = self.tabsViewControllers[selectedIndex]
            if oldIndex < selectedIndex {
                self.pageViewController?.setViewControllers([mainViewController], direction: .forward, animated: true, completion: { [weak self] _ in
                    self?.updateSelector()
                })
            } else {
                self.pageViewController?.setViewControllers([mainViewController], direction: .reverse, animated: true, completion: { [weak self] _ in
                    self?.updateSelector()
                })
            }
        }
    }

    func updateSelector() {
        guard let selectedVC = pageViewController?.viewControllers?.first else {
            return
        }
        let index = tabsViewControllers.firstIndex(of: selectedVC)
        highlightConstraint?.constant = CGFloat(index ?? 0) * (view.frame.width / 4)
    }
}

extension ChallengeDetailVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = tabsViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex - 1
        let orderedViewControllersCount = tabsViewControllers.count

        guard nextIndex >= 0 else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return tabsViewControllers[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = tabsViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = tabsViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return tabsViewControllers[nextIndex]
    }
}

extension ChallengeDetailVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let selectedVC = pageViewController.viewControllers?.first else {
            return
        }
        let index = tabsViewControllers.firstIndex(of: selectedVC)
        switch index {
        case 0:
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_detail_results", viewController: selectedVC)
            break
        case 1:
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_detail_ranking", viewController: selectedVC)
            break
        case 2:
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_detail_trips", viewController: selectedVC)
            break
        case 3:
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_detail_rules", viewController: selectedVC)
            break
        default:
            break
        }
        updateSelector()
    }
}

extension ChallengeDetailVC: ChallengeDetailViewModelDelegate {
    func didSelectTrip(tripId: String, showAdvice: Bool) {
        if let driverDataUI = DriveKitNavigationController.shared.driverDataUI, let navigationController = self.navigationController {
            let tripDetail = driverDataUI.getTripDetailViewController(itinId: tripId, showAdvice: showAdvice, alternativeTransport: false)
            navigationController.pushViewController(tripDetail, animated: true)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DKShowTripDetail"), object: nil, userInfo: ["itinId": tripId])
        }
    }
}
