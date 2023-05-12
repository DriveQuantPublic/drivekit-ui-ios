//
//  DKTripRecordingButton.swift
//  DriveKitTripAnalysisUI
//
//  Created by Frédéric Ruaudel on 12/05/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

public class DKTripRecordingButton: UIButton {
    private var contentView: DKTripRecordingButtonContentView
    
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
    }
    
    required init?(coder: NSCoder) {
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
        super.init(coder: coder)
    }
    
    public func configure(viewModel: DKTripRecordingButtonViewModel) {
        self.contentView.configure(viewModel: viewModel)
        self.updateUI()
    }
    
    private func updateUI() {
        self.setTitle("", for: .normal)
        self.removeSubviews()
        self.embedSubview(contentView)
    }
}
