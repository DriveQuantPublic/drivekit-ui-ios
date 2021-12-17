//
//  ActivationHoursViewController.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 16/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ActivationHoursViewController: DKUIViewController {

    private let viewModel: ActivationHoursViewModel

    public init() {
        self.viewModel = ActivationHoursViewModel()
        super.init(nibName: String(describing: ActivationHoursViewController.self), bundle: Bundle.tripAnalysisUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension ActivationHoursViewController: DKActivationHoursConfigDelegate {
    func onActivationHoursAvaiblale() {
        
    }
    
    func onActivationHoursUpdated() {
        
    }
    
    func didReceiveErrorFromService() {
        
    }
}
