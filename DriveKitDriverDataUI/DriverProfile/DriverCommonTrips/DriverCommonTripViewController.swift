//
//  DriverCommonTripViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitDBTripAccessModule
import UIKit

class DriverCommonTripViewController: UIViewController, DKUIPageViewModel {
    @IBOutlet private weak var placeholderLabel: UILabel!

    var viewModel: DriverCommonTripViewModel
    var pageId: DKCommonTripType
    
    required init(pageId: DKCommonTripType, pageViewModel: DriverCommonTripViewModel) {
        self.viewModel = pageViewModel
        self.pageId = pageId
        super.init(nibName: String(describing: Self.self), bundle: .driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderLabel.text = "\(pageId)"
    }
}
