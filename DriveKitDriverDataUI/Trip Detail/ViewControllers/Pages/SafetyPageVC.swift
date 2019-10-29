//
//  SafetyPageVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 14/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

class SafetyPageVC: UIViewController {
    @IBOutlet var progressRingContainer: UIView!
    @IBOutlet var progressRingTitle: UILabel!
    
    @IBOutlet var eventContainer: UIStackView!
    
    var viewModel : SafetyPageViewModel
    var config : TripListViewConfig
    var detailConfig: TripDetailViewConfig
    
    init(viewModel: SafetyPageViewModel, config: TripListViewConfig, detailConfig: TripDetailViewConfig) {
        self.viewModel = viewModel
        self.config = config
        self.detailConfig = detailConfig
        super.init(nibName: String(describing: SafetyPageVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configure()
    }


    func configure() {
        let score = CircularProgressView.viewFromNib
        let configScore = ConfigurationCircularProgressView(scoreType: viewModel.scoreType, trip: viewModel.trip, size: .large)
        score.configure(configuration: configScore, scoreFont: config.primaryFont)
        score.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        progressRingContainer.embedSubview(score)
        DriverDataStyle.applyCircularRingTitle(label: progressRingTitle)
        progressRingTitle.text = viewModel.scoreType.stringValue(detailConfig: detailConfig)
        setupEventContainer()
    }
    
    func setupEventContainer() {
        eventContainer.removeAllSubviews()
        let accelerationView = SafetyPageView.viewFromNib
        accelerationView.config = self.config
        accelerationView.configure(title: detailConfig.accelerationText, image: "dk_safety_accel", count: viewModel.getAccelerations())
        eventContainer.addArrangedSubview(accelerationView)
        
        let brakeView = SafetyPageView.viewFromNib
        brakeView.config = self.config
        brakeView.configure(title: detailConfig.decelText, image: "dk_safety_decel", count: viewModel.getBrakes())
        eventContainer.addArrangedSubview(brakeView)
        
        let adherenceView = SafetyPageView.viewFromNib
        adherenceView.config = self.config
        adherenceView.configure(title: detailConfig.adherenceText, image: "dk_safety_adherence", count: viewModel.getAdherences())
        eventContainer.addArrangedSubview(adherenceView)
        
        
    }

}
