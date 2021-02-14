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
        let nbUnlockView = DistractionPageView.viewFromNib
        nbUnlockView.configure(title: "dk_driverdata_unlock_number".dkDriverDataLocalized(), count: self.getNumberUnlocks())
        eventContainer.addArrangedSubview(nbUnlockView)

        let unlockDurationView = DistractionPageView.viewFromNib
        unlockDurationView.configure(title: "dk_driverdata_unlock_duration".dkDriverDataLocalized(), count: self.getScreenUnlockDuration())
        eventContainer.addArrangedSubview(unlockDurationView)

        let unlockDistanceView = DistractionPageView.viewFromNib
        unlockDistanceView.configure(title: "dk_driverdata_unlock_distance".dkDriverDataLocalized(), count: self.getScreenUnlockDistance())
        eventContainer.addArrangedSubview(unlockDistanceView)
    }
    
    func getNumberUnlocks() -> NSAttributedString {
        return self.viewModel.getUnlocksNumber().dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.primaryColor).build()
    }
    
    func getScreenUnlockDuration() -> NSAttributedString {
        return self.viewModel.getScreenUnlockDuration().dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.primaryColor).build()
    }
    
    func getScreenUnlockDistance() -> NSAttributedString {
        return self.viewModel.getScreenUnlockDistance().dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.primaryColor).build()
    }
}
