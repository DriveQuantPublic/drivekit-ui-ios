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
    private let margin: CGFloat = 10

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
        updateStartStopButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateSynthesisCardView()
        updateLastTripView()
    }

    @IBAction private func showDriveKitFeatures() {
        #warning("TODO")
    }

    @IBAction private func startStopTrip() {
        self.viewModel.startStopTrip()
    }

    @IBAction private func simulateTrip() {
        #warning("TODO")
    }

    private func updateSynthesisCardView() {
        self.synthesisCardViewContainer.removeSubviews()
        let synthesisCardView = self.viewModel.getSynthesisCardView()
        synthesisCardView.translatesAutoresizingMaskIntoConstraints = false
        synthesisCardView.addShadow()
        UIView.reducePageControl(in: synthesisCardView)
        self.synthesisCardViewContainer.addSubview(synthesisCardView)

        self.synthesisCardViewContainer.addConstraints([
            synthesisCardView.topAnchor.constraint(equalTo: self.synthesisCardViewContainer.topAnchor, constant: self.margin),
            synthesisCardView.bottomAnchor.constraint(equalTo: self.synthesisCardViewContainer.bottomAnchor, constant: -self.margin),
            synthesisCardView.leftAnchor.constraint(equalTo: self.synthesisCardViewContainer.leftAnchor, constant: self.margin),
            synthesisCardView.rightAnchor.constraint(equalTo: self.synthesisCardViewContainer.rightAnchor, constant: -self.margin)
        ])
    }

    private func updateLastTripView() {
        self.lastTripsViewContainer.removeSubviews()
        let lastTripView = self.viewModel.getLastTripView(parentViewController: self)
        lastTripView.translatesAutoresizingMaskIntoConstraints = false
        lastTripView.addShadow()
        UIView.reducePageControl(in: lastTripView)
        self.lastTripsViewContainer.addSubview(lastTripView)

        self.lastTripsViewContainer.addConstraints([
            lastTripView.topAnchor.constraint(equalTo: self.lastTripsViewContainer.topAnchor, constant: self.margin),
            lastTripView.bottomAnchor.constraint(equalTo: self.lastTripsViewContainer.bottomAnchor, constant: -self.margin),
            lastTripView.leftAnchor.constraint(equalTo: self.lastTripsViewContainer.leftAnchor, constant: self.margin),
            lastTripView.rightAnchor.constraint(equalTo: self.lastTripsViewContainer.rightAnchor, constant: -self.margin)
        ])
    }
}

extension DashboardViewController: DashboardViewModelDelegate {
    func updateStartStopButton() {
        self.startStopTripButton.configure(text: self.viewModel.getStartStopTripButtonTitle().keyLocalized(), style: .full)
    }
}
