//
//  DashboardViewController.swift
//  DriveKitApp
//
//  Created by David Bauduin on 15/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class DashboardViewController: UIViewController {
    @IBOutlet private weak var synthesisCardViewContainer: UIView!
    @IBOutlet private weak var lastTripsViewContainer: UIView!
    @IBOutlet private weak var featureListViewContainer: UIView!
    @IBOutlet private weak var startStopTripButton: UIButton!
    @IBOutlet private weak var simulateTripButton: UIButton!
    private var synthesisCardView: UIView?
    private var lastTripsView: UIView?
    private var viewModel: DashboardViewModel = DashboardViewModel()
    private let horizontalMargin: CGFloat = 8

    init() {
        super.init(nibName: String(describing: DashboardViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.delegate = self
        self.title = "dashboard_header".keyLocalized()
        self.synthesisCardViewContainer.addShadow()
        self.lastTripsViewContainer.addShadow()
        addAllFeatureView()
        updateStartStopButton()
        self.simulateTripButton.configure(text: "simulate_trip".keyLocalized(), style: .full)
        configureNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateSynthesisCardView()
        updateLastTripView()
    }

    @IBAction private func showDriveKitFeatures() {
        self.navigationController?.pushViewController(FeaturesViewController(), animated: true)
    }

    @IBAction private func startStopTrip() {
        self.viewModel.startStopTrip()
    }

    @IBAction private func simulateTrip() {
        let simulationVC = TripSimulatorViewController(nibName: String(describing: TripSimulatorViewController.self), bundle: nil)
        self.navigationController?.pushViewController(simulationVC, animated: true)
    }

    private func addAllFeatureView() {
        let featureView = FeatureView.viewFromNib
        featureView.translatesAutoresizingMaskIntoConstraints = false
        featureView.update(viewModel: FeatureViewViewModel(type: .all), parentViewController: self)
        self.featureListViewContainer.addSubview(featureView)
        self.featureListViewContainer.addShadow()
        NSLayoutConstraint.activate([
            featureView.topAnchor.constraint(equalTo: self.featureListViewContainer.topAnchor),
            featureView.bottomAnchor.constraint(equalTo: self.featureListViewContainer.bottomAnchor),
            featureView.leftAnchor.constraint(equalTo: self.featureListViewContainer.leftAnchor, constant: self.horizontalMargin),
            featureView.rightAnchor.constraint(equalTo: self.featureListViewContainer.rightAnchor, constant: -self.horizontalMargin)
        ])
    }

    private func updateSynthesisCardView() {
        self.synthesisCardViewContainer.removeSubviews()
        let synthesisCardView = self.viewModel.getSynthesisCardsView()
        synthesisCardView.translatesAutoresizingMaskIntoConstraints = false
        UIView.reducePageControl(in: synthesisCardView)
        self.synthesisCardViewContainer.addSubview(synthesisCardView)

        self.synthesisCardViewContainer.addConstraints([
            synthesisCardView.topAnchor.constraint(equalTo: self.synthesisCardViewContainer.topAnchor),
            synthesisCardView.bottomAnchor.constraint(equalTo: self.synthesisCardViewContainer.bottomAnchor),
            synthesisCardView.leftAnchor.constraint(equalTo: self.synthesisCardViewContainer.leftAnchor, constant: self.horizontalMargin),
            synthesisCardView.rightAnchor.constraint(equalTo: self.synthesisCardViewContainer.rightAnchor, constant: -self.horizontalMargin)
        ])
    }

    private func updateLastTripView() {
        self.lastTripsViewContainer.removeSubviews()
        let lastTripView = self.viewModel.getLastTripsView(parentViewController: self)
        lastTripView.translatesAutoresizingMaskIntoConstraints = false
        UIView.reducePageControl(in: lastTripView)
        self.lastTripsViewContainer.addSubview(lastTripView)

        self.lastTripsViewContainer.addConstraints([
            lastTripView.topAnchor.constraint(equalTo: self.lastTripsViewContainer.topAnchor),
            lastTripView.bottomAnchor.constraint(equalTo: self.lastTripsViewContainer.bottomAnchor),
            lastTripView.leftAnchor.constraint(equalTo: self.lastTripsViewContainer.leftAnchor, constant: self.horizontalMargin),
            lastTripView.rightAnchor.constraint(equalTo: self.lastTripsViewContainer.rightAnchor, constant: -self.horizontalMargin)
        ])
    }

    private func configureNavBar() {
        let image = UIImage(named: "settings", in: Bundle.main, compatibleWith: nil)?.resizeImage(25, opaque: false).withRenderingMode(.alwaysTemplate)
        let settingsButton = UIBarButtonItem(image: image , style: .plain, target: self, action: #selector(openSettings))
        settingsButton.tintColor = DKUIColors.navBarElementColor.color
        self.navigationItem.rightBarButtonItem = settingsButton
    }

    @objc private func openSettings() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}

extension DashboardViewController: DashboardViewModelDelegate {
    func updateStartStopButton() {
        self.startStopTripButton.configure(text: self.viewModel.getStartStopTripButtonTitle().keyLocalized(), style: .full)
    }
}
