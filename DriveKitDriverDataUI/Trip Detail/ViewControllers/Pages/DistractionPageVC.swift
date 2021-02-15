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

    @IBOutlet var circularRingContainer: UIView!
    @IBOutlet var circularRingTitle: UILabel!
    @IBOutlet var eventContainer: UIStackView!
    
    var viewModel: DistractionPageViewModel
    
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
        unlockView.configure(title: self.viewModel.getUnlockTitle(), description: self.viewModel.getUnlockDescription(), value: self.viewModel.getUnlockValue())
        eventContainer.addArrangedSubview(unlockView)

        let callsView = DistractionPageView.viewFromNib
        callsView.configure(title: self.viewModel.getPhoneCallTitle(), description: self.viewModel.getPhoneCallDescription(), value: self.viewModel.getPhoneCallValue())
        eventContainer.addArrangedSubview(callsView)
    }

}
