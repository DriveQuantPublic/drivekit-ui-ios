//
//  TripSimulatorViewController.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 20/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class TripSimulatorViewController: UIViewController {
    @IBOutlet private weak var topDescriptionLabel: UILabel!
    @IBOutlet private weak var selectTripLabel: UILabel!
    @IBOutlet private weak var tripTitleLabel: UILabel!
    @IBOutlet private weak var tripDescriptionLabel: UILabel!
    @IBOutlet private weak var simulationButton: UIButton!
    private var viewModel = TripSimulatorViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        self.title = "trip_simulator_header".keyLocalized()
        simulationButton.configure(text: "trip_simulator_start_button".keyLocalized(), style: .full)
        topDescriptionLabel.attributedText = viewModel.getDescriptionAttibutedText()
        selectTripLabel.text = "trip_simulator_select_trip".keyLocalized()
        selectTripLabel.font = DKStyles.headLine1.style.applyTo(font: .primary)
        configureBackButton()
        updateSelectedItem()
    }

    private func configureBackButton() {
        DKUIViewController.configureBackButton(viewController: self, selector: #selector(onBack))
    }

    @objc private func onBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    func updateSelectedItem() {
        tripDescriptionLabel.attributedText = viewModel.getTripDescriptionAttibutedText()
        tripTitleLabel.font = DKStyle(size: DKStyles.smallText.style.size, traits: .traitBold).applyTo(font: .primary)
        tripTitleLabel.text = viewModel.getTripTitleText()
    }

    @IBAction func openTripSelection() {
        let alert: UIAlertController
        let alertTitle = "trip_simulator_select_trip".keyLocalized()
        alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)
        for index in 0..<viewModel.items.count {
            let item = viewModel.items[index]
            alert.addAction(UIAlertAction(title: item.getTitle(), style: .default, handler: { [weak self] _ in
                self?.viewModel.selectItem(at: index)
                DispatchQueue.dispatchOnMainThread {
                    self?.updateSelectedItem()
                }
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func simulateAction() {
        if !self.viewModel.isAutoStartEnabled() {
            self.showAlertMessage(title: "trip_simulator_error_auto_mode".keyLocalized(), message: nil, back: false, cancel: false)
        } else if !self.viewModel.hasVehicleAutoStartMode() {
            self.showAlertMessage(title: "trip_simulator_error_vehicle_disabled".keyLocalized(), message: nil, back: false, cancel: false)
        } else if let navigationController = self.navigationController {
            let selectedItem = self.viewModel.getSelectedItem()
            let detailsViewModel = TripSimulatorDetailViewModel(simulatedItem: selectedItem)
            let detailsVC = TripSimulatorDetailViewController(viewModel: detailsViewModel)
            navigationController.pushViewController(detailsVC, animated: true)
        }
    }
}
