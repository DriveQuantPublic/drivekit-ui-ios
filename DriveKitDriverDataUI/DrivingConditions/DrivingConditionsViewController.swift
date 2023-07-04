//
//  DrivingConditionsViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 05/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import UIKit

class DrivingConditionsViewController: DKUIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var periodSelectorContainer: UIView!
    @IBOutlet private weak var dateSelectorContainer: UIView!
    @IBOutlet private weak var drivingConditionsSummaryContainer: UIView!
    @IBOutlet private weak var contextPagingContainer: UIView!
    @IBOutlet private weak var pagingControl: UIPageControl!
    private var contextPagingViewController: DKUIPagingCardViewController<DKContextKind, DrivingConditionsContextViewController, DrivingConditionsViewModel>!
    
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
        
        DrivingConditionsSummaryCardView.createSummaryCardView(
            configuredWith: viewModel.drivingConditionsSummaryViewModel,
            embededIn: self.drivingConditionsSummaryContainer
        )
        
        if viewModel.hasData {
            self.contextPagingViewController = .init(
                pagingControl: self.pagingControl,
                viewModel: viewModel
            )
            if viewModel.shouldDisplayPagingController {
                self.configurePagingContexts()
            } else {
                self.embedContextViewController(
                    contextPagingViewController.pageController(
                        for: viewModel.firstPageId
                    )
                )
                self.pagingControl.isHidden = true
            }
        } else {
            self.contextPagingContainer.isHidden = true
            self.pagingControl.isHidden = true
        }
        
        if self.viewModel.updating {
            showRefreshControl()
        } else {
            hideRefreshControl()
        }
    }
    
    private func configurePagingContexts() {
        self.embedContextViewController(contextPagingViewController)
        contextPagingViewController.configure()
    }
    
    private func embedContextViewController(_ contextViewController: UIViewController) {
        self.addChild(contextViewController)
        contextPagingContainer.embedSubview(contextViewController.view)
        contextPagingContainer.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        contextPagingContainer.clipsToBounds = true
        contextViewController.didMove(toParent: self)
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
