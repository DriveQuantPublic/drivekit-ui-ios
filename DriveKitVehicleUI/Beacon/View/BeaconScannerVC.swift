//
//  BeaconScannerVC.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

public class BeaconScannerVC : DKUIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var step : BeaconStep
    private let viewModel : BeaconViewModel
    private let parentView : UIViewController
    
    public init(viewModel: BeaconViewModel, step: BeaconStep, parentView: UIViewController) {
        self.viewModel = viewModel
        self.step = step
        self.parentView = parentView
        super.init(nibName: "BeaconScannerVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        updateStep(step: self.step)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
    }
    
    private func updateStep(step: BeaconStep) {
        self.step = step
        descriptionLabel.attributedText = step.title(viewModel: viewModel)
        UIView.transition(with: self.imageView, duration: 0.4, options: .transitionFlipFromTop, animations: { self.imageView.image = step.image })
        view.gestureRecognizers?.removeAll()
        bottomStackView.removeAllSubviews()
        if let viewController = step.viewController(viewModel: viewModel) {
            addChild(viewController)
            bottomStackView.addArrangedSubview(viewController.view)
            viewController.didMove(toParent: self)
        }
    }
    
    @objc func tapDetected() {
        self.step.onImageClicked(viewModel: self.viewModel)
    }
}

extension BeaconScannerVC : ScanStateDelegate {
    func onStateUpdated(step: BeaconStep) {
        self.updateStep(step: step)
    }
    
    func onScanFinished() {
        self.navigationController?.popToViewController(self.parentView, animated: true)
    }
    
    func shouldShowLoader() {
        self.showLoader()
    }
    
    func shouldHideLoader() {
        self.hideLoader()
    }
}
