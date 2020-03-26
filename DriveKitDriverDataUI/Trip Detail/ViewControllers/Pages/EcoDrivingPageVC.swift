//
//  EvoDrivingPageVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class EcoDrivingPageVC: UIViewController {
    
    @IBOutlet var circularRingTitle: UILabel!
    @IBOutlet var circularRingContainer: UIView!
    @IBOutlet var eventContainer: UIStackView!
    
    var viewModel: EcoDrivingPageViewModel
    
    init(viewModel: EcoDrivingPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: EcoDrivingPageVC.self), bundle: Bundle.driverDataUIBundle)
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
        let configScore = ConfigurationCircularProgressView(scoreType: viewModel.scoreType, value: viewModel.scoreType.rawValue(trip: viewModel.trip), size: .large)
        score.configure(configuration: configScore)
        score.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        score.center = circularRingContainer.center
        circularRingContainer.embedSubview(score)
        circularRingTitle.attributedText = viewModel.scoreType.stringValue().dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.mainFontColor).build()
        setupEventContainer()
    }
    
    func setupEventContainer() {
        eventContainer.removeAllSubviews()
        let accelerationView = EcoDrivingPageView.viewFromNib
        accelerationView.configure(title: viewModel.getAccelerations(), image: DKImages.ecoAccel.image)
        eventContainer.addArrangedSubview(accelerationView)
        
        let speedView = EcoDrivingPageView.viewFromNib
        speedView.configure(title: viewModel.getMaintain(), image: DKImages.ecoMaintain.image)
        eventContainer.addArrangedSubview(speedView)
        
        let brakeView = EcoDrivingPageView.viewFromNib
        brakeView.configure(title: viewModel.getDecel(), image: DKImages.ecoDecel.image)
        eventContainer.addArrangedSubview(brakeView)
        
    }
    
}
