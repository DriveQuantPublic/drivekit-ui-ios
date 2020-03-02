//
//  SafetyPageVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 14/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class SafetyPageVC: UIViewController {
    @IBOutlet var progressRingContainer: UIView!
    @IBOutlet var progressRingTitle: UILabel!
    
    @IBOutlet var eventContainer: UIStackView!
    
    var viewModel : SafetyPageViewModel
    
    init(viewModel: SafetyPageViewModel) {
        self.viewModel = viewModel
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
        let configScore = ConfigurationCircularProgressView(scoreType: viewModel.scoreType, value: viewModel.scoreType.rawValue(trip: viewModel.trip), size: .large)
        score.configure(configuration: configScore)
        score.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        progressRingContainer.embedSubview(score)
        progressRingTitle.attributedText = viewModel.scoreType.stringValue().dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.mainFontColor).build()
        setupEventContainer()
    }
    
    func setupEventContainer() {
        eventContainer.removeAllSubviews()
        let accelerationView = SafetyPageView.viewFromNib
        accelerationView.configure(title: "dk_safety_accel".dkDriverDataLocalized(), image: DKImages.safetyAccel.image, count: viewModel.getAccelerations())
        eventContainer.addArrangedSubview(accelerationView)
        
        let brakeView = SafetyPageView.viewFromNib
        brakeView.configure(title: "dk_safety_decel".dkDriverDataLocalized(), image: DKImages.safetyDecel.image, count: viewModel.getBrakes())
        eventContainer.addArrangedSubview(brakeView)
        
        let adherenceView = SafetyPageView.viewFromNib
        adherenceView.configure(title: "dk_safety_adherence".dkDriverDataLocalized(), image: DKImages.safetyAdherence.image, count: viewModel.getAdherences())
        eventContainer.addArrangedSubview(adherenceView)
        
        
    }

}
