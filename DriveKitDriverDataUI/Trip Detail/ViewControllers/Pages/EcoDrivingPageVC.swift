//
//  EvoDrivingPageVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

class EcoDrivingPageVC: UIViewController {
    
    @IBOutlet var circularRingTitle: UILabel!
    @IBOutlet var circularRingContainer: UIView!
    @IBOutlet var eventContainer: UIStackView!
    
    var viewModel: EcoDrivingPageViewModel
    var detailConfig: TripDetailViewConfig
    
    init(viewModel: EcoDrivingPageViewModel, detailConfig: TripDetailViewConfig) {
        self.viewModel = viewModel
        self.detailConfig = detailConfig
        super.init(nibName: String(describing: EcoDrivingPageVC.self), bundle: Bundle.driverDataUIBundle)
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
        score.configure(configuration: configScore)
        score.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        score.center = circularRingContainer.center
        circularRingContainer.embedSubview(score)
        DriverDataStyle.applyCircularRingTitle(label: circularRingTitle)
        circularRingTitle.text = viewModel.scoreType.stringValue(detailConfig: detailConfig)
        setupEventContainer()
    }
    
    func setupEventContainer() {
        eventContainer.removeAllSubviews()
        let accelerationView = EcoDrivingPageView.viewFromNib
        accelerationView.configure(title: viewModel.getAccelerations(), image: "dk_eco_accel")
        eventContainer.addArrangedSubview(accelerationView)
        
        let speedView = EcoDrivingPageView.viewFromNib
        speedView.configure(title: viewModel.getMaintain(), image: "dk_eco_maintain")
        eventContainer.addArrangedSubview(speedView)
        
        let brakeView = EcoDrivingPageView.viewFromNib
        brakeView.configure(title: viewModel.getDecel(), image: "dk_eco_decel")
        eventContainer.addArrangedSubview(brakeView)
        
    }
    
}
