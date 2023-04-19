// swiftlint:disable all
//
//  CrashFeedbackStep2VC.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 09/03/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitTripAnalysisModule

class CrashFeedbackStep2VC: CrashFeedbackBaseVC {

    private let viewModel: CrashFeedbackStep2ViewModel
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var noCrashButton: UIButton!
    @IBOutlet weak private var minorCrashButton: UIButton!
    @IBOutlet weak private var criticalCrashButton: UIButton!

    public init(viewModel: CrashFeedbackStep2ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: CrashFeedbackStep2VC.self), bundle: Bundle.tripAnalysisUIBundle)
        DriveKitTripAnalysis.shared.registerCrashFeedbackDelegate(delegate: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        navigationItem.hidesBackButton = true
        self.noCrashButton.configure(title: "dk_crash_detection_feedback_step2_option_no_crash".dkTripAnalysisLocalized(), style: .rounded(color: greenColor))
        self.minorCrashButton.configure(title: "dk_crash_detection_feedback_step2_option_minor_accident".dkTripAnalysisLocalized(), style: .rounded(color: yellowColor))
        self.criticalCrashButton.configure(title: "dk_crash_detection_feedback_step2option_critical_accident".dkTripAnalysisLocalized(), style: .rounded(color: redColor))
        messageLabel.attributedText = viewModel.getMessageAttributedText()
    }

    deinit {
        DriveKitTripAnalysis.shared.unregisterCrashFeedbackDelegate(delegate: self)
    }

    @IBAction func noCrashAction() {
        viewModel.sendNoCrash()
        self.dismiss()
    }

    @IBAction func minorCrashAction() {
        viewModel.sendMinorCrash()
        self.dismiss()
    }

    @IBAction func criticalCrashAction() {
        viewModel.sendCriticalCrash()
        makeCrashAssistanceCall()
        self.dismiss()
    }
}

extension CrashFeedbackStep2VC: CrashFeedbackDelegate {
    func didUpdateProgress(remainingSeconds: TimeInterval, totalSeconds: TimeInterval) {
    }

    func timeoutReached() {
    }

    func confirmationTimeoutReached() {
        self.dismiss()
    }
}
