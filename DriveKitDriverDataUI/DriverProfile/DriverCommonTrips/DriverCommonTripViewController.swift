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
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var conditionsLabel: UILabel!

    var viewModel: DriverCommonTripViewModel
    var pageId: DKCommonTripType
    
    required init(pageId: DKCommonTripType, pageViewModel: DriverCommonTripViewModel) {
        self.viewModel = pageViewModel
        self.pageId = pageId
        super.init(nibName: String(describing: Self.self), bundle: .driverDataUIBundle)
        self.viewModel.viewModelDidUpdate = { [weak self] in
            self?.refreshView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "dk_driverdata_usual_trip_card_title".dkDriverDataLocalized()
        titleLabel.font = DKStyles.headLine2.style.applyTo(font: .primary)
        conditionsLabel.font = DKStyles.normalText.style.applyTo(font: .primary)
    }
    
    private func refreshView() {
        distanceLabel.attributedText = viewModel.distanceText
        durationLabel.attributedText = viewModel.durationText
        conditionsLabel.text = viewModel.conditionsText
    }
}
