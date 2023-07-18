//
//  DriverProfileViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 27/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import UIKit

class DriverProfileViewController: DKUIViewController {
    @IBOutlet private weak var drivingConditionsButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var driverProfileFeaturePagingContainer: UIView!
    @IBOutlet private weak var driverProfileFeaturePagingControl: UIPageControl!
    typealias DriverProfileFeaturePagingViewController = DKUIPagingCardViewController<
        DriverProfileFeature,
        DriverProfileFeatureViewController,
        DriverProfileFeaturePagingViewModel>
    private var driverProfileFeaturePagingViewController: DriverProfileFeaturePagingViewController!
    @IBOutlet private weak var driverDistanceEstimationPagingContainer: UIView!
    @IBOutlet private weak var driverDistanceEstimationPagingControl: UIPageControl!
    typealias DriverDistanceEstimationPagingViewController = DKUIPagingCardViewController<
        DKPeriod,
        DriverDistanceEstimationViewController,
        DriverDistanceEstimationPagingViewModel>
    private var driverDistanceEstimationPagingViewController: DriverDistanceEstimationPagingViewController!
    @IBOutlet private weak var driverCommonTripPagingContainer: UIView!
    @IBOutlet private weak var driverCommonTripPagingControl: UIPageControl!
    typealias DriverCommonTripPagingViewController = DKUIPagingCardViewController<
        DKCommonTripType,
        DriverCommonTripViewController,
        DriverCommonTripPagingViewModel>
    private var driverCommonTripPagingViewController: DriverCommonTripPagingViewController!
    
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
        
        self.title = "dk_driverdata_profile_title".dkDriverDataLocalized()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_ :)), for: .valueChanged)
        self.scrollView.refreshControl = refreshControl
        
        self.configureDriverFeaturePagingContexts()
        self.configureDistanceEstimationPagingContexts()
        self.configureCommonTripPagingContexts()
        
        if self.viewModel.updating {
            showRefreshControl()
        } else {
            hideRefreshControl()
        }
        
        drivingConditionsButton.configure(title: "dk_driverdata_drivingconditions_show".dkDriverDataLocalized(), style: .empty)
        
        drivingConditionsButton.addTarget(self, action: #selector(drivingConditionsButtonTapped), for: .touchUpInside)
    }
    
    @objc private func drivingConditionsButtonTapped() {
        self.navigationController?.pushViewController(
            DrivingConditionsViewController(viewModel: viewModel.drivingConditionsViewModel),
            animated: true
        )
    }
    
    private func configureDriverFeaturePagingContexts() {
        self.driverProfileFeaturePagingContainer.removeSubviews()
        self.driverProfileFeaturePagingViewController = DriverProfileFeaturePagingViewController.createPagingViewController(
            configuredWith: viewModel.driverProfileFeaturePagingViewModel,
            pagingControl: self.driverProfileFeaturePagingControl,
            embededIn: driverProfileFeaturePagingContainer,
            of: self
        )
    }
    
    private func configureDistanceEstimationPagingContexts() {
        self.driverDistanceEstimationPagingContainer.removeSubviews()
        self.driverDistanceEstimationPagingViewController = DriverDistanceEstimationPagingViewController.createPagingViewController(
            configuredWith: viewModel.driverDistanceEstimationPagingViewModel,
            pagingControl: self.driverDistanceEstimationPagingControl,
            embededIn: driverDistanceEstimationPagingContainer,
            of: self
        )
    }
    
    private func configureCommonTripPagingContexts() {
        self.driverCommonTripPagingContainer.removeSubviews()
        self.driverCommonTripPagingViewController = DriverCommonTripPagingViewController.createPagingViewController(
            configuredWith: viewModel.driverCommonTripPagingViewModel,
            pagingControl: self.driverCommonTripPagingControl,
            embededIn: driverCommonTripPagingContainer,
            of: self
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
    
}

extension DriverProfileViewController: DriverProfileViewModelDelegate {
    func willUpdateData() {
        showRefreshControl()
    }
    
    func didUpdateData() {
        hideRefreshControl()
        configureDriverFeaturePagingContexts()
        configureDistanceEstimationPagingContexts()
        configureCommonTripPagingContexts()
        self.drivingConditionsButton.isHidden = viewModel.shouldHideDrivingConditions
    }
}
