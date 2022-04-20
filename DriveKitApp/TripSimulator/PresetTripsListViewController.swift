//
//  PresetTripsListViewController.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 20/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

class PresetTripsListViewController: UIViewController {
    @IBOutlet private weak var topDescriptionLabel: UILabel!
    @IBOutlet private weak var selectTripLabel: UILabel!
    @IBOutlet private weak var tripTitleLabel: UILabel!
    @IBOutlet private weak var tripDescriptionLabel: UILabel!
    @IBOutlet private weak var simulationButton: UIButton!
    private var viewModel = PresetTripsListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        self.title = "trip_simulator_header".keyLocalized()
        simulationButton.configure(text: "trip_simulator_start_button".keyLocalized(), style: .full)
        topDescriptionLabel.attributedText = viewModel.getDescriptionAttibutedText()
        selectTripLabel.text = "trip_simulator_select_trip".keyLocalized()
        tripDescriptionLabel.attributedText = viewModel.getTripDescriptionAttibutedText()
        tripTitleLabel.text = viewModel.getTripTitleText()
    }
}
