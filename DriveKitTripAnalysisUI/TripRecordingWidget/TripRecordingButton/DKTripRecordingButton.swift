//
//  DKTripRecordingButton.swift
//  DriveKitTripAnalysisUI
//
//  Created by Frédéric Ruaudel on 12/05/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

public class DKTripRecordingButton: UIButton {
    private var contentView: DKTripRecordingButtonContentView
    private var viewModel: DKTripRecordingButtonViewModel?
    private weak var presentingVC: UIViewController?
    
    override init(frame: CGRect) {
        guard
            let contentView = Bundle.tripAnalysisUIBundle?.loadNibNamed(
                "DKTripRecordingButtonContentView",
                owner: nil,
                options: nil
            )?.first as? DKTripRecordingButtonContentView
        else {
            preconditionFailure("Can't find bundle or nib for DKTripRecordingButtonContentView")
        }
        self.contentView = contentView
        super.init(frame: frame)
        self.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(Self.self).init(coder:) is not implemented")
    }
    
    @objc func didTapButton() {
        guard let viewModel else { return }
        let shouldShowTripStopConfirmationDialog = viewModel.toggleRecordingState()
        if shouldShowTripStopConfirmationDialog {
            showConfirmationDialog()
        }
    }
    
    func configure(viewModel: DKTripRecordingButtonViewModel, presentingVC: UIViewController) {
        self.contentView.configure(viewModel: viewModel)
        self.viewModel = viewModel
        self.viewModel?.viewModelDidUpdate = { [weak self] in
            guard let self else { return }
            self.updateUI()
        }
        self.presentingVC = presentingVC
        self.setupUI()
    }
    
    public func showConfirmationDialog() {
        guard let viewModel, viewModel.isHidden == false else { return }
        if viewModel.canShowTripStopConfirmationDialog {
            let confirmationDialogViewModel = DKTripStopConfirmationViewModel()
            let confirmationDialog = DKTripStopConfirmationViewController(
                viewModel: confirmationDialogViewModel
            )
            confirmationDialog.modalPresentationStyle = .overCurrentContext
            self.presentingVC?.present(confirmationDialog, animated: true)
        }
    }
    
    private func setupUI() {
        self.setTitle("", for: .normal)
        self.removeSubviews()
        self.embedSubview(contentView)
        self.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        self.clipsToBounds = true
        self.setBackgroundImage(UIImage(color: DKUIColors.secondaryColor.color), for: .normal)
        self.updateUI()
    }
    
    private func updateUI() {
        guard let viewModel else { return }
        self.isHidden = viewModel.isHidden
        self.contentView.updateUI()
    }
}
