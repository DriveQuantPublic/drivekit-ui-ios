//
//  ChallengeDetailsVCViewController.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 28/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

enum ChallengeDetaiItem {
    case results, ranking, tripList, rules
}

class ChallengeDetailsVCViewController: UIViewController {
    private let viewModel: ChallengeDetailsViewModel?
    @IBOutlet var pageContainer: UIView?
    var pageViewController: UIPageViewController?
    var swipableViewControllers: [UIViewController] = []

    public init(viewModel: ChallengeDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ChallengeDetailsVCViewController.self), bundle: Bundle.challengeUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipableViewControllers.append(UIViewController())
        setupPageContainer()
    }

    func setupPageContainer() {
        if self.pageViewController == nil {
            let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            self.pageViewController = pageViewController
            self.pageViewController?.dataSource = self
            self.pageViewController?.delegate = self
            if let mainViewController = self.swipableViewControllers.first {
                self.pageViewController?.setViewControllers([mainViewController], direction: .forward, animated: true, completion: nil)
            }
            self.pageViewController?.view.frame = CGRect(x: 0, y: 0, width: self.pageContainer?.frame.width ?? 0, height: self.pageContainer?.frame.height ?? 0)
            pageContainer?.addSubview(pageViewController.view)
            self.pageViewController?.didMove(toParent: self)
        }
    }
}

extension ChallengeDetailsVCViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = swipableViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex - 1
        let orderedViewControllersCount = swipableViewControllers.count

        guard nextIndex > 0 else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return swipableViewControllers[nextIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = swipableViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = swipableViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return swipableViewControllers[nextIndex]
    }
}

extension ChallengeDetailsVCViewController: UIPageViewControllerDelegate {
    
}
