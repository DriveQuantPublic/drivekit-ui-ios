//
//  TripSimulatorDetailViewController.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 22/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class TripSimulatorDetailViewController: UIViewController {
    @IBOutlet private weak var tripTitleLabel: UILabel!
    @IBOutlet private weak var tripDescriptionLabel: UILabel!
    @IBOutlet private weak var durationTitleLabel: UILabel!
    @IBOutlet private weak var durationValueLabel: UILabel!
    @IBOutlet private weak var sdkStateTitleLabel: UILabel!
    @IBOutlet private weak var sdkStateValueLabel: UILabel!
    @IBOutlet private weak var timeTitleLabel: UILabel!
    @IBOutlet private weak var timeValueLabel: UILabel!
    @IBOutlet private weak var velocityTitleLabel: UILabel!
    @IBOutlet private weak var velocityValueLabel: UILabel!
    @IBOutlet private weak var autoStopTitleLabel: UILabel!
    @IBOutlet private weak var autoStopValueLabel: UILabel!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var velocityGraphView: VelocityChartView!
    
    private var viewModel: TripSimulatorDetailViewModel

    init(viewModel: TripSimulatorDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TripSimulatorDetailViewController.self), bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        self.title = "trip_simulator_header".keyLocalized()
        self.tripTitleLabel.text = viewModel.getTripTitle()
        self.tripTitleLabel.font = DKStyles.headLine1.style.applyTo(font: .primary)
        self.tripDescriptionLabel.text = viewModel.getTripDescription()
        self.durationValueLabel.text = viewModel.getTotalDurationText()
        self.durationTitleLabel.text = "trip_simulator_run_duration".keyLocalized()
        self.sdkStateTitleLabel.text = "trip_simulator_run_sdk_state".keyLocalized()
        self.timeTitleLabel.text = "trip_simulator_run_time".keyLocalized()
        self.velocityTitleLabel.text = "trip_simulator_run_velocity".keyLocalized()
        self.autoStopTitleLabel.text = "trip_simulator_automatic_stop_in".keyLocalized()

        let smallFont = DKStyles.smallText.style.applyTo(font: DKUIFonts.primary)
        self.tripDescriptionLabel.font = smallFont
        self.durationTitleLabel.font = smallFont
        self.sdkStateTitleLabel.font = smallFont
        self.timeTitleLabel.font = smallFont
        self.velocityTitleLabel.font = smallFont
        self.autoStopTitleLabel.font = smallFont

        let boldlFont = DKStyles.headLine2.style.applyTo(font: DKUIFonts.primary)
        self.durationValueLabel.font = boldlFont
        self.sdkStateValueLabel.font = boldlFont
        self.timeValueLabel.font = boldlFont
        self.velocityValueLabel.font = boldlFont
        self.autoStopValueLabel.font = boldlFont

        let complementaryFontColor = DKUIColors.complementaryFontColor.color
        self.tripDescriptionLabel.textColor = complementaryFontColor
        self.durationTitleLabel.textColor = complementaryFontColor
        self.sdkStateTitleLabel.textColor = complementaryFontColor
        self.timeTitleLabel.textColor = complementaryFontColor
        self.velocityTitleLabel.textColor = complementaryFontColor
        self.autoStopTitleLabel.textColor = complementaryFontColor
        self.updateViewContent()
        stopButton.configure(title: "trip_simulator_stop_button".keyLocalized(), style: .full)
        configureBackButton()
        self.velocityGraphView.setupChart()
    }

    func updateViewContent() {
        self.timeValueLabel.text = viewModel.getSpentDurationText()
        self.sdkStateValueLabel.text = viewModel.getStateText()
        self.velocityValueLabel.text = viewModel.getSpeedText()
        if viewModel.shouldDisplayStoppingMessage() {
            self.autoStopTitleLabel.isHidden = false
            self.autoStopValueLabel.isHidden = false
            self.autoStopValueLabel.text = viewModel.getRemainingTimeToStopText()
        } else {
            self.autoStopTitleLabel.isHidden = true
            self.autoStopValueLabel.isHidden = true
        }
        if viewModel.isSimulating {
            stopButton.configure(title: "trip_simulator_stop_button".keyLocalized(), style: .full)
        } else {
            stopButton.configure(title: "trip_simulator_restart_button".keyLocalized(), style: .full)
        }
    }

    private func configureBackButton() {
        DKUIViewController.configureBackButton(viewController: self, selector: #selector(onBack))
    }

    @objc private func onBack(sender: UIBarButtonItem) {
        if viewModel.isSimulating {
            stopSimulator {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func startStopSimulation() {
        if viewModel.isSimulating {
            stopSimulator {
                self.updateViewContent()
            }
        } else {
            self.velocityGraphView.clean()
            self.viewModel.startSimulation()
        }
        updateViewContent()
    }

    private func stopSimulator(stopCompletion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "trip_simulator_stop_simulation_alert_title".keyLocalized(),
            message: "trip_simulator_stop_simulation_alert_content".keyLocalized(),
            preferredStyle: .alert
        )
        let stopAction = UIAlertAction(title: "button_stop".keyLocalized(), style: .default) { [weak self] _ in
            self?.viewModel.stopSimulation()
            stopCompletion()
        }
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(stopAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

extension TripSimulatorDetailViewController: TripSimulatorDetailViewModelDelegate {
    func updateNeeded(updatedValue: Double?, timestamp: Double?) {
        if let updatedValue = updatedValue, let timestamp = timestamp {
            self.velocityGraphView.updateGraph(velocity: updatedValue, timestamp: timestamp)
        }
        self.updateViewContent()
    }
}
