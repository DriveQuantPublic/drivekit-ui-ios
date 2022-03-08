//
//  CrashFeedbackStep1VC.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 07/03/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import UICircularProgressRing
import DriveKitTripAnalysisModule

class CrashFeedbackStep1VC: UIViewController {

    private let viewModel: CrashFeedbackStep1ViewModel
    @IBOutlet weak private var noCrashButton: UIButton!
    @IBOutlet weak private var criticalCrashButton: UIButton!
    @IBOutlet weak var progressRing: UICircularProgressRing!

    public init(viewModel: CrashFeedbackStep1ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: CrashFeedbackStep1VC.self), bundle: Bundle.tripAnalysisUIBundle)
        DriveKitTripAnalysis.shared.registerCrashFeedbackDelegate(delegate: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.noCrashButton.configure(text: "dk_crash_detection_feedback_step1_option_no_crash".dkTripAnalysisLocalized(), style: .rounded(color: UIColor(hex: 0x77E2B0)))
        self.criticalCrashButton.configure(text: "dk_crash_detection_feedback_step1_option_critical_accident".dkTripAnalysisLocalized(), style: .rounded(color: UIColor(hex: 0xEA676B)))
        initProgressRing(threshold: 60, progress: 60)
    }

    private func initProgressRing(threshold: Float, progress: Float) {
        progressRing.valueFormatter = UICircularProgressRingFormatter(valueIndicator: "", rightToLeft: false, showFloatingPoint: false, decimalPlaces: 0)
        progressRing.fullCircle = true
        progressRing.maxValue = CGFloat(threshold)
        progressRing.value = CGFloat(progress)
        progressRing.startAngle = 270
        progressRing.endAngle = 45
        progressRing.innerRingWidth = 8
        progressRing.outerRingWidth = 0
        progressRing.shouldShowValueText = true
        progressRing.innerRingColor = UIColor(hex: 0xEA676B)
    }

    deinit {
        DriveKitTripAnalysis.shared.unregisterCrashFeedbackDelegate(delegate: self)
    }
}

extension CrashFeedbackStep1VC: CrashFeedbackDelegate {
    func didUpdateProgress(remainingSeconds: TimeInterval, totalSeconds: TimeInterval) {
        progressRing.value = CGFloat(remainingSeconds.rounded())
    }

    func timeoutReached() {
        self.dismiss(animated: true, completion: {
        })
    }

    func confirmationTimeoutReached() {
        
    }
}
