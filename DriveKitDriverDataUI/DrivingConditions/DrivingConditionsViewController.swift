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
    private var contextViewControllers: [DKContextKind: DrivingConditionsContextViewController] = [:]
    
    private let viewModel: DrivingConditionsViewModel
    
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
        
        self.title = "dk_driverdata_drivingconditions_title".dkDriverDataLocalized()
        
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
        
        if viewModel.shouldDisplayPagingController {
            self.configurePagingContexts()
        } else {
            self.embedContextViewController(contextController(for: viewModel.firstContext))
            self.pagingControl.isHidden = true
        }
        
        if self.viewModel.updating {
            showRefreshControl()
        } else {
            hideRefreshControl()
        }
    }
    
    private func configurePagingContexts() {
        contextPagingViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        contextPagingViewController.dataSource = self
        contextPagingViewController.delegate = self
        
        self.embedContextViewController(contextPagingViewController)
        
        pagingControl.numberOfPages = viewModel.numberOfContexts
        pagingControl.currentPage = 0
        pagingControl.pageIndicatorTintColor = .dkPageIndicatorTintColor
        pagingControl.currentPageIndicatorTintColor = DKUIColors.primaryColor.color
        
        pagingControl.addTarget(
            self,
            action: #selector(didTapPagingControl(_:)),
            for: .valueChanged
        )
        
        contextPagingViewController.setViewControllers(
            [contextController(for: viewModel.firstContext)],
            direction: .forward,
            animated: false
        )
    }
    
    private func embedContextViewController(_ contextViewController: UIViewController) {
        self.addChild(contextViewController)
        contextPagingContainer.embedSubview(contextViewController.view)
        contextPagingContainer.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        contextPagingContainer.clipsToBounds = true
        contextViewController.didMove(toParent: self)
    }
    
    @objc private func didTapPagingControl(_ sender: Any) {
        guard
            let selectedContext = viewModel.context(
                at: self.pagingControl.currentPage
            )
        else {
            assertionFailure("We should always have a page that match an existing context")
            return
        }
        
        let contextController = self.contextController(for: selectedContext)
        
        var direction = UIPageViewController.NavigationDirection.forward
        if let currentContextController = self.contextPagingViewController.viewControllers?.first,
           let previousContext = self.context(from: currentContextController) {
                direction = (
                    viewModel.position(of: previousContext) ?? -1
                    <
                    viewModel.position(of: selectedContext) ?? -1
                )
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
    
    func contextController(for context: DKContextKind) -> DrivingConditionsContextViewController {
        guard let contextVC = contextViewControllers[context] else {
            let newContextVC = DrivingConditionsContextViewController(context: context)
            contextViewControllers[context] = newContextVC
            return newContextVC
        }
        
        return contextVC
    }
    
    func context(from contextController: UIViewController) -> DKContextKind? {
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
            return viewModel.context(before: currentContext).flatMap(self.contextController(for:))
        }
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        self.context(from: viewController).flatMap { currentContext in
            return viewModel.context(after: currentContext).flatMap(self.contextController(for:))
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
            let currentContext = self.context(from: currentVC) {
            self.pagingControl.currentPage = viewModel.position(of: currentContext) ?? 0
        }
    }
}
