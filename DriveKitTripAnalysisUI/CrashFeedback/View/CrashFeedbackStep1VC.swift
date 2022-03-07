//
//  CrashFeedbackStep1VC.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 07/03/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

class CrashFeedbackStep1VC: UIViewController {

    private let viewModel: CrashFeedbackStep1ViewModel

    public init(viewModel: CrashFeedbackStep1ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: CrashFeedbackStep1VC.self), bundle: Bundle.tripAnalysisUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
