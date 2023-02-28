//
//  MySynthesisViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 16/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class MySynthesisViewController: DKUIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scoreSelectorContainer: UIView!
    @IBOutlet private weak var periodSelectorContainer: UIView!
    @IBOutlet private weak var dateSelectorContainer: UIView!
    @IBOutlet private weak var scoreViewContainer: UIView!
    @IBOutlet private weak var communityViewContainer: UIView!
    @IBOutlet weak var showDetailButton: UIButton!
    
    private let viewModel: MySynthesisViewModel
    
    init(viewModel: MySynthesisViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: MySynthesisViewController.self), bundle: .driverDataUIBundle)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "dk_driverdata_mysynthesis_main_title".dkDriverDataLocalized()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_ :)), for: .valueChanged)
        self.scrollView.refreshControl = refreshControl
        
        DKScoreSelectorView.createScoreSelectorView(
            configuredWith: self.viewModel.scoreSelectorViewModel,
            embededIn: scoreSelectorContainer
        )
        DKPeriodSelectorView.createPeriodSelectorView(
            configuredWith: self.viewModel.periodSelectorViewModel,
            embededIn: periodSelectorContainer
        )
        DKDateSelectorView.createDateSelectorView(
            configuredWith: self.viewModel.dateSelectorViewModel,
            embededIn: dateSelectorContainer
        )
        
        showDetailButton.isHidden = viewModel.shouldHideDetailButton
        
        if self.viewModel.updating {
            showRefreshControl()
        } else {
            hideRefreshControl()
        }
        setupHorizontalGauge()
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

    private func setupHorizontalGauge() {
        HorizontalGaugeView.createHorizontalGaugeView(
            configuredWith: viewModel.horizontalGaugeViewModel,
            embededIn: communityViewContainer
        )
    }
}
    
extension MySynthesisViewController: MySynthesisViewModelDelegate {
    func willUpdateData() {
        showRefreshControl()
    }
    
    func didUpdateData() {
        hideRefreshControl()
    }
    
    func didUpdateDetailButtonDisplay() {
        self.showDetailButton.isHidden = viewModel.shouldHideDetailButton
    }
}
