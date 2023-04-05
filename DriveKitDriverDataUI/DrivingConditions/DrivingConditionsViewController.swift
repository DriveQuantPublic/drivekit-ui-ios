//
//  DrivingConditionsViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 05/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class DrivingConditionsViewController: DKUIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var periodSelectorContainer: UIView!
    @IBOutlet private weak var dateSelectorContainer: UIView!
    @IBOutlet private weak var drivingConditionSummaryContainer: UIView!
    @IBOutlet private weak var contextPagingContainer: UIView!
    @IBOutlet private weak var pagingControl: UIPageControl!
    private var contextPagingViewController: UIPageViewController!
    private var contextViewControllers: [ContextKind: DrivingConditionsContextViewController] = [:]
    
    private let viewModel: DrivingConditionsViewModel
    
    var allContexts: [ContextKind] {
        ContextKind.allCases
    }
    
    init(viewModel: DrivingConditionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DrivingConditionsViewController.self), bundle: .driverDataUIBundle)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DKPeriodSelectorView.createPeriodSelectorView(
            configuredWith: self.viewModel.periodSelectorViewModel,
            embededIn: periodSelectorContainer
        )
        DKDateSelectorView.createDateSelectorView(
            configuredWith: self.viewModel.dateSelectorViewModel,
            embededIn: dateSelectorContainer
        )

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_ :)), for: .valueChanged)
        self.scrollView.refreshControl = refreshControl
        
        contextPagingViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        contextPagingViewController.dataSource = self
        contextPagingViewController.delegate = self
        
        self.addChild(contextPagingViewController)
        contextPagingContainer.embedSubview(contextPagingViewController.view)
        contextPagingContainer.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        contextPagingContainer.clipsToBounds = true
        contextPagingViewController.didMove(toParent: self)
        
        pagingControl.numberOfPages = allContexts.count
        pagingControl.currentPage = 0
        pagingControl.pageIndicatorTintColor = .dkPageIndicatorTintColor
        pagingControl.currentPageIndicatorTintColor = DKUIColors.primaryColor.color
        
        pagingControl.addTarget(
            self,
            action: #selector(didTapPagingControl(_:)),
            for: .valueChanged
        )
        
        let firstContextVC = DrivingConditionsContextViewController(context: allContexts[0])
        contextViewControllers[allContexts[0]] = firstContextVC
        contextPagingViewController.setViewControllers(
            [firstContextVC],
            direction: .forward,
            animated: false
        )
        
        if self.viewModel.updating {
            showRefreshControl()
        } else {
            hideRefreshControl()
        }
    }
    
    @objc private func didTapPagingControl(_ sender: Any) {
        guard
            let selectedContext = ContextKind(rawValue: self.pagingControl.currentPage),
            let contextController = self.contextController(for: selectedContext)
        else {
            assertionFailure("We should always have a page that match an existing context")
            return
        }
        
        var direction = UIPageViewController.NavigationDirection.forward
        if let currentContextController = self.contextPagingViewController.viewControllers?.first,
           let previousContext = self.context(from: currentContextController) {
               direction = previousContext.rawValue < selectedContext.rawValue
                ? .forward
                : .reverse
           }
        
        self.contextPagingViewController.setViewControllers(
            [contextController],
            direction: direction,
            animated: true
        )
    }
    
    @objc private func refresh(_ sender: Any) {
        self.viewModel.updateData()
    }
    
    private func showRefreshControl() {
        self.scrollView.refreshControl?.beginRefreshing()
    }
    
    private func hideRefreshControl() {
        self.scrollView.refreshControl?.endRefreshing()
    }
    
    func contextController(for context: ContextKind?) -> DrivingConditionsContextViewController? {
        guard let context else {
            return nil
        }
        
        guard let contextVC = contextViewControllers[context] else {
            let newContextVC = DrivingConditionsContextViewController(context: context)
            contextViewControllers[context] = newContextVC
            return newContextVC
        }
        
        return contextVC
    }
    
    func context(from contextController: UIViewController) -> ContextKind? {
        guard let contextController = contextController as? DrivingConditionsContextViewController else {
            assertionFailure("We should only have DrivingConditionsContextViewController here")
            return nil
        }
        
        return contextController.context
    }
}

extension DrivingConditionsViewController: DrivingConditionsViewModelDelegate {
    func willUpdateData() {
        showRefreshControl()
    }
    
    func didUpdateData() {
        hideRefreshControl()
    }
}

extension DrivingConditionsViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        self.context(from: viewController).flatMap { currentContext in
            return self.contextController(for: currentContext.previous)
        }
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        self.context(from: viewController).flatMap { currentContext in
            return self.contextController(for: currentContext.next)
        }
    }
}

extension DrivingConditionsViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed,
            let currentVC = pageViewController.viewControllers?.first,
            let currentPage = self.context(from: currentVC)?.rawValue {
            self.pagingControl.currentPage = currentPage
        }
    }
}
