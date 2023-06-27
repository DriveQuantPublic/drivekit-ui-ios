//
//  DriverProfileFeaturePagingViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 27/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class DriverProfileFeatureViewController: UIViewController, DKUIPageViewModel {
    var viewModel: DriverProfileFeatureViewModel
    var pageId: DriverProfileFeature
    
    required init(pageId: DriverProfileFeature, pageViewModel: DriverProfileFeatureViewModel) {
        self.viewModel = pageViewModel
        self.pageId = pageId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
