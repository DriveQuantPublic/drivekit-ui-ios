//
//  DKTripStopConfirmationViewController.swift
//  DriveKitTripAnalysisUI
//
//  Created by Frédéric Ruaudel on 15/05/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class DKTripStopConfirmationViewController: UIViewController {
    @IBOutlet private weak var endTripButton: UIButton!
    @IBOutlet private weak var continueTripButton: UIButton!
    @IBOutlet private weak var cancelTripButton: UIButton!
    private var viewModel: DKTripStopConfirmationViewModel
    
    init(viewModel: DKTripStopConfirmationViewModel) {
        self.viewModel = viewModel
        super.init(
            nibName: String(describing: DKTripStopConfirmationViewController.self),
            bundle: .tripAnalysisUIBundle
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        endTripButton.addTarget(self, action: #selector(didTapEndTripButton), for: .touchUpInside)
        continueTripButton.addTarget(self, action: #selector(didTapContinueTripButton), for: .touchUpInside)
        cancelTripButton.addTarget(self, action: #selector(didTapCancelTripButton), for: .touchUpInside)
        updateUI()
    }
    
    public func configure(with viewModel: DKTripStopConfirmationViewModel) {
        self.viewModel = viewModel
        updateUI()
    }
    
    private func updateUI() {
        endTripButton.configure(
            title: viewModel.endTripTitle,
            subtitle: viewModel.endTripSubtitle,
            style: .multilineBordered
        )
        continueTripButton.configure(
            title: viewModel.continueTripTitle,
            subtitle: viewModel.continueTripSubtitle,
            style: .multilineBordered
        )
        cancelTripButton.configure(
            title: viewModel.cancelTripTitle,
            subtitle: viewModel.cancelTripSubtitle,
            style: .multilineBordered
        )
    }
    
    @objc func didTapEndTripButton() {
        viewModel.endTripButtonTapped()
        self.dismiss(animated: true)
    }
    
    @objc func didTapContinueTripButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapCancelTripButton() {
        let alertVC = UIAlertController(
            title: viewModel.disableRecordingConfirmationTitle,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for (actionTitle, duration) in viewModel.disableRecordingConfirmationTitlesAndDurations {
            let action = UIAlertAction(
                title: actionTitle,
                style: .default
            ) { [weak self] _ in
                guard let viewModel = self?.viewModel else { return }
                viewModel.disableRecordingConfirmationOptionSelected(duration: duration)
                self?.dismiss(animated: true)
            }
            
            alertVC.addAction(action)
        }
        
        alertVC.addAction(UIAlertAction(
                title: DKCommonLocalizable.cancel.text(),
                style: .cancel
        ) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        self.present(alertVC, animated: true)
    }

}
