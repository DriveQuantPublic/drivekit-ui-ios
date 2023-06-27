//
//  DriverProfileViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 27/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class DriverProfileViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var driverProfileFeaturePagingContainer: UIView!
    @IBOutlet private weak var driverProfileFeaturePagingControl: UIPageControl!
    private var driverProfileFeaturePagingViewController: DKUIPagingCardViewController<
        DriverProfileFeature,
        DriverProfileFeatureViewController,
        DriverProfileFeaturePagingViewModel>!
    
    private let viewModel: DriverProfileViewModel
    
    init(viewModel: DriverProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DriverProfileViewController.self), bundle: .driverDataUIBundle)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "dk_driverdata_drivingconditions_title".dkDriverDataLocalized()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_ :)), for: .valueChanged)
        self.scrollView.refreshControl = refreshControl
        
        self.configureDriverFeaturePagingContexts()
        
        if self.viewModel.updating {
            showRefreshControl()
        } else {
            hideRefreshControl()
        }
    }
    
    private func configureDriverFeaturePagingContexts() {
        self.driverProfileFeaturePagingViewController = .init(
            pagingControl: self.driverProfileFeaturePagingControl,
            viewModel: viewModel.driverProfileFeaturePagingViewModel
        )
        self.embedPagingViewController(
            driverProfileFeaturePagingViewController,
            in: driverProfileFeaturePagingContainer
        )
    }
    
    private func embedPagingViewController(
        _ pagingViewController: UIViewController,
        in pagingContainer: UIView
    ) {
        self.addChild(pagingViewController)
        pagingContainer.embedSubview(pagingViewController.view)
        pagingContainer.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        pagingContainer.clipsToBounds = true
        pagingViewController.didMove(toParent: self)
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

extension DriverProfileViewController: DriverProfileViewModelDelegate {
    func willUpdateData() {
        showRefreshControl()
    }
    
    func didUpdateData() {
        hideRefreshControl()
    }
}
