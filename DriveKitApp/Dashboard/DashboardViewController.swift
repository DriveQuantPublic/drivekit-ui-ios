// swiftlint:disable no_magic_numbers
//
//  DashboardViewController.swift
//  DriveKitApp
//
//  Created by David Bauduin on 15/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitPermissionsUtilsUI
import DriveKitTripAnalysisUI
import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet private weak var bannersContainer: UIStackView!
    @IBOutlet private weak var synthesisCardViewContainer: UIView!
    @IBOutlet private weak var lastTripsViewContainer: UIView!
    @IBOutlet private weak var featureListViewContainer: UIView!
    @IBOutlet private weak var buttonsContainer: UIStackView!
    @IBOutlet private weak var simulateTripButton: UIButton!
    private var startStopTripButton: DKTripRecordingButton!
    private var synthesisCardView: UIView?
    private var lastTripsView: UIView?
    private var viewModel: DashboardViewModel = DashboardViewModel()
    private let margin: CGFloat = 4

    init() {
        super.init(nibName: String(describing: DashboardViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = DKUIColors.backgroundView.color
        self.viewModel.delegate = self
        self.title = "dashboard_header".keyLocalized()
        self.synthesisCardViewContainer.applyCardStyle()
        self.lastTripsViewContainer.applyCardStyle()
        addAllFeatureView()
        self.setupStartStopButton()

        self.simulateTripButton.configure(title: "simulate_trip".keyLocalized(), style: .bordered)
        configureNavBar()
        updateBanners()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppNavigationController.alreadyOnboarded = true

        self.viewModel.updateBanners()
        updateSynthesisCardView()
        updateLastTripView()
    }

    @IBAction private func showDriveKitFeatures() {
        self.navigationController?.pushViewController(FeaturesViewController(), animated: true)
    }

    @IBAction private func simulateTrip() {
        let simulationVC = TripSimulatorViewController(nibName: String(describing: TripSimulatorViewController.self), bundle: nil)
        self.navigationController?.pushViewController(simulationVC, animated: true)
    }
    
    func showTripStopConfirmationDialog() {
        self.startStopTripButton.showConfirmationDialog()
    }
    
    private func setupStartStopButton() {
        self.startStopTripButton = DriveKitTripAnalysisUI.shared.getTripRecordingButton(presentedIn: self)
        self.buttonsContainer.insertArrangedSubview(startStopTripButton, at: 0)
    }

    private func addAllFeatureView() {
        let featureView = FeatureView.viewFromNib
        featureView.translatesAutoresizingMaskIntoConstraints = false
        featureView.update(viewModel: FeatureViewViewModel(type: .all), parentViewController: self)
        self.featureListViewContainer.addSubview(featureView)
        self.featureListViewContainer.applyCardStyle()
        NSLayoutConstraint.activate([
            featureView.topAnchor.constraint(equalTo: self.featureListViewContainer.topAnchor, constant: self.margin),
            featureView.bottomAnchor.constraint(equalTo: self.featureListViewContainer.bottomAnchor, constant: -self.margin),
            featureView.leftAnchor.constraint(equalTo: self.featureListViewContainer.leftAnchor, constant: self.margin),
            featureView.rightAnchor.constraint(equalTo: self.featureListViewContainer.rightAnchor, constant: -self.margin)
        ])
    }

    private func updateSynthesisCardView() {
        self.synthesisCardViewContainer.removeSubviews()
        let synthesisCardView = self.viewModel.getSynthesisCardsView()
        synthesisCardView.translatesAutoresizingMaskIntoConstraints = false
        UIView.reducePageControl(in: synthesisCardView)
        self.synthesisCardViewContainer.addSubview(synthesisCardView)
        synthesisCardView.roundCorners(clipping: true)

        self.synthesisCardViewContainer.addConstraints([
            synthesisCardView.topAnchor.constraint(equalTo: self.synthesisCardViewContainer.topAnchor, constant: self.margin),
            synthesisCardView.bottomAnchor.constraint(equalTo: self.synthesisCardViewContainer.bottomAnchor, constant: -self.margin),
            synthesisCardView.leftAnchor.constraint(equalTo: self.synthesisCardViewContainer.leftAnchor, constant: self.margin),
            synthesisCardView.rightAnchor.constraint(equalTo: self.synthesisCardViewContainer.rightAnchor, constant: -self.margin)
        ])
    }

    private func updateLastTripView() {
        self.lastTripsViewContainer.removeSubviews()
        let lastTripView = self.viewModel.getLastTripsView(parentViewController: self)
        lastTripView.translatesAutoresizingMaskIntoConstraints = false
        UIView.reducePageControl(in: lastTripView)
        self.lastTripsViewContainer.addSubview(lastTripView)

        self.lastTripsViewContainer.addConstraints([
            lastTripView.topAnchor.constraint(equalTo: self.lastTripsViewContainer.topAnchor, constant: self.margin),
            lastTripView.bottomAnchor.constraint(equalTo: self.lastTripsViewContainer.bottomAnchor, constant: -self.margin),
            lastTripView.leftAnchor.constraint(equalTo: self.lastTripsViewContainer.leftAnchor, constant: self.margin),
            lastTripView.rightAnchor.constraint(equalTo: self.lastTripsViewContainer.rightAnchor, constant: -self.margin)
        ])
    }

    private func updateBanners() {
        let bannerViewModels = self.viewModel.bannerViewModels
        for view in self.bannersContainer.arrangedSubviews {
            view.removeFromSuperview()
        }
        if bannerViewModels.isEmpty {
            self.bannersContainer.isHidden = true
        } else {
            for bannerViewModel in bannerViewModels {
                let bannerView = InfoBannerView.viewFromNib
                bannerView.translatesAutoresizingMaskIntoConstraints = false
                bannerView.update(with: bannerViewModel)
                if bannerViewModel.hasAction {
                    bannerView.addTarget(self, action: #selector(didTouchBannerView(_:)), for: .touchUpInside)
                }
                NSLayoutConstraint.activate([
                    bannerView.heightAnchor.constraint(equalToConstant: 50)
                ])
                self.bannersContainer.addArrangedSubview(bannerView)
            }
            self.bannersContainer.isHidden = false
        }
    }

    private func configureNavBar() {
        let image = UIImage(named: "settings", in: Bundle.main, compatibleWith: nil)?.resizeImage(25, opaque: false).withRenderingMode(.alwaysTemplate)
        let settingsButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(openSettings))
        settingsButton.tintColor = DKUIColors.navBarElementColor.color
        self.navigationItem.rightBarButtonItem = settingsButton
    }

    @objc private func openSettings() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }

    @objc private func didTouchBannerView(_ sender: InfoBannerView) {
        sender.viewModel?.showAction(parentViewController: self)
    }
}

extension DashboardViewController: DashboardViewModelDelegate {
    func bannersDidUpdate() {
        updateBanners()
    }
}
