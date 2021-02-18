//
//  DistractionPageVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class DistractionPageVC: UIViewController {

    @IBOutlet private var circularRingContainer: UIView!
    @IBOutlet private var circularRingTitle: UILabel!
    @IBOutlet private var eventContainer: UIStackView!
    
    private var viewModel: DistractionPageViewModel
    private var selectedDistractionPageView: DistractionPageView? = nil
    
    init(viewModel: DistractionPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DistractionPageVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    func configure() {
        let score = CircularProgressView.viewFromNib
        let configScore = ConfigurationCircularProgressView(scoreType: viewModel.scoreType, value: viewModel.getScore(), size: .large)
        score.configure(configuration: configScore)
        score.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        score.center = circularRingContainer.center
        circularRingContainer.embedSubview(score)
        circularRingTitle.attributedText = viewModel.getScoreTitle().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
        setupEventContainer()
    }
    
    func setupEventContainer() {
        eventContainer.removeAllSubviews()

        let unlockView = DistractionPageView.viewFromNib
        unlockView.configure(title: self.viewModel.getUnlockTitle(), description: self.viewModel.getUnlockDescription(), value: self.viewModel.getUnlockValue(), mapTrace: .unlockScreen)
        eventContainer.addArrangedSubview(unlockView)
        unlockView.addTarget(self, action: #selector(selectDistractionPageView), for: .touchUpInside)

        let callsView = DistractionPageView.viewFromNib
        callsView.configure(title: self.viewModel.getPhoneCallTitle(), description: self.viewModel.getPhoneCallDescription(), value: self.viewModel.getPhoneCallValue(), mapTrace: .phoneCall)
        eventContainer.addArrangedSubview(callsView)
        callsView.addTarget(self, action: #selector(selectDistractionPageView), for: .touchUpInside)

        switch self.viewModel.tripDetailViewModel.getSelectedMapTrace() {
            case .phoneCall:
                selectDistractionPageView(callsView)
            case .unlockScreen:
                selectDistractionPageView(unlockView)
        }
    }

    @objc private func selectDistractionPageView(_ distractionPageView: DistractionPageView) {
        if distractionPageView != self.selectedDistractionPageView {
            self.selectedDistractionPageView?.isSelected = false
        }
        if !distractionPageView.isSelected {
            distractionPageView.isSelected = true
            self.viewModel.tripDetailViewModel.setSelectedMapTrace(distractionPageView.mapTrace)
        }
        self.selectedDistractionPageView = distractionPageView
    }

}
