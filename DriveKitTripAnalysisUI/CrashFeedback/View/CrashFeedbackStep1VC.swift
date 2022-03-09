//
//  CrashFeedbackStep1VC.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 07/03/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import UICircularProgressRing
import DriveKitTripAnalysisModule

class CrashFeedbackStep1VC: CrashFeedbackBaseVC {

    private let viewModel: CrashFeedbackStep1ViewModel
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var noCrashButton: UIButton!
    @IBOutlet weak private var criticalCrashButton: UIButton!
    @IBOutlet weak private var counterContainer: UIView!
    @IBOutlet weak private var progressRing: UICircularProgressRing!
    @IBOutlet weak private var insideCircleView: UIView!


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
        setupView()
    }

    func setupView() {
        self.noCrashButton.configure(text: "dk_crash_detection_feedback_step1_option_no_crash".dkTripAnalysisLocalized(), style: .rounded(color: greenColor))
        self.criticalCrashButton.configure(text: "dk_crash_detection_feedback_step1_option_critical_accident".dkTripAnalysisLocalized(), style: .rounded(color: redColor))
        initProgressRing(threshold: 60, progress: 60)
        insideCircleView.layer.masksToBounds = true
        insideCircleView.backgroundColor = UIColor(hex: 0xEEB0B2).withAlphaComponent(0.2)
        messageLabel.attributedText = viewModel.getMessageAttributedText()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        insideCircleView.layer.cornerRadius = insideCircleView.frame.width / 2
    }

    private func initProgressRing(threshold: Float, progress: Float) {
        progressRing.valueFormatter = UICircularProgressRingFormatter(valueIndicator: "", rightToLeft: false, showFloatingPoint: false, decimalPlaces: 0)
        progressRing.fullCircle = true
        progressRing.maxValue = CGFloat(threshold)
        progressRing.value = CGFloat(progress)
        progressRing.font = DKUIFonts.secondary.fonts(size: 48)
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

    @IBAction func noCrashAction() {
        if let crashInfo = viewModel.prepareStep2() {
            let step2ViewModel = CrashFeedbackStep2ViewModel(crashInfo: crashInfo)
            let step2VC = CrashFeedbackStep2VC(viewModel: step2ViewModel)
            self.navigationController?.pushViewController(step2VC, animated: true)
        } else {
            // something went wrong, crash not found
            dismiss()
        }
    }

    @IBAction func criticalCrashAction() {
        viewModel.sendCriticalCrash()
        makeCrashAssistanceCall()
        self.dismiss()
    }
}

extension CrashFeedbackStep1VC: CrashFeedbackDelegate {
    func didUpdateProgress(remainingSeconds: TimeInterval, totalSeconds: TimeInterval) {
        progressRing.value = CGFloat(remainingSeconds.rounded())
    }

    func timeoutReached() {
        self.dismiss()
    }

    func confirmationTimeoutReached() {
        self.dismiss()
    }
}
