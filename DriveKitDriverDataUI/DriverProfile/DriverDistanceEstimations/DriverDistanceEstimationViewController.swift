//
//  DriverDistanceEstimationViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import UIKit

class DriverDistanceEstimationViewController: UIViewController, DKUIPageViewModel {
    @IBOutlet private weak var placeholderLabel: UILabel!
    
    var viewModel: DriverDistanceEstimationViewModel
    var pageId: DKPeriod
    
    required init(pageId: DKPeriod, pageViewModel: DriverDistanceEstimationViewModel) {
        self.viewModel = pageViewModel
        self.pageId = pageId
        super.init(
            nibName: String(describing: Self.self),
            bundle: .driverDataUIBundle
        )
        self.viewModel.viewModelDidUpdate = { [weak self] in
            self?.refreshView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderLabel.text = "\(pageId)"
    }
    
    private func refreshView() {
        #warning("TODO: refresh view when viewModel updates")
    }
}
