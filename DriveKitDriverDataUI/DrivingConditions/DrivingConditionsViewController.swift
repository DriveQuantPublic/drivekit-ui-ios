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
    
    private let viewModel: DrivingConditionsViewModel
    
    enum ContextKind: Int, CaseIterable {
        case tripDistance = 0, week, road, weather, dayNight
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
        
        self.addChild(contextPagingViewController)
        contextPagingContainer.embedSubview(contextPagingViewController.view)
        contextPagingContainer.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        contextPagingContainer.clipsToBounds = true
        contextPagingViewController.didMove(toParent: self)
        
        pagingControl.numberOfPages = ContextKind.allCases.count
        pagingControl.currentPage = 0
        
        if self.viewModel.updating {
            showRefreshControl()
        } else {
            hideRefreshControl()
        }
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
        #warning("Setup context VCs")
        return nil
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        #warning("Setup context VCs")
        return nil
    }
}
