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
    @IBOutlet private var infoButton: UIButton!

    private var viewModel: DistractionPageViewModel
    private var unlockView: DistractionPageView?
    private var callsView: DistractionPageView?
    private var selectedDistractionPageView: DistractionPageView?
    
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
        infoButton.setImage(DKImages.info.image, for: .normal)
        infoButton.tintColor = DKUIColors.secondaryColor.color
    }
    
    func setupEventContainer() {
        eventContainer.removeAllSubviews()

        let unlockView = DistractionPageView.viewFromNib
        unlockView.configure(title: self.viewModel.getUnlockTitle(), description: self.viewModel.getUnlockDescription(), value: self.viewModel.getUnlockValue(), mapTrace: .unlockScreen)
        eventContainer.addArrangedSubview(unlockView)
        unlockView.button.addTarget(self, action: #selector(selectUnlocks), for: .touchUpInside)
        self.unlockView = unlockView

        let callsView = DistractionPageView.viewFromNib
        callsView.configure(title: self.viewModel.getPhoneCallTitle(), description: self.viewModel.getPhoneCallDescription(), value: self.viewModel.getPhoneCallValue(), mapTrace: .phoneCall)
        eventContainer.addArrangedSubview(callsView)
        callsView.button.addTarget(self, action: #selector(selectCalls), for: .touchUpInside)
        self.callsView = callsView

        switch self.viewModel.tripDetailViewModel.getSelectedMapTrace() {
            case .phoneCall:
                selectCalls()
            case .unlockScreen:
                selectUnlocks()
        }
    }

    @objc private func selectUnlocks() {
        selectDistractionPageView(self.unlockView)
    }

    @objc private func selectCalls() {
        selectDistractionPageView(self.callsView)
    }

    private func selectDistractionPageView(_ distractionPageView: DistractionPageView?) {
        if let distractionPageView = distractionPageView {
            self.selectedDistractionPageView?.isSelected = false
            distractionPageView.isSelected = true
            self.selectedDistractionPageView = distractionPageView
            self.viewModel.tripDetailViewModel.setSelectedMapTrace(distractionPageView.mapTrace)
        }
    }

    @IBAction func infoAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "dk_driverdata_distraction_score".dkDriverDataLocalized(), message: "dk_driverdata_distraction_score_info".dkDriverDataLocalized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
