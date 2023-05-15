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
    private let buttonHeight: CGFloat = 60.0
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
        fatalError("\(Self.self).init(coder:) is not implemented")
    }
    
    public func configure(viewModel: DKTripRecordingButtonViewModel) {
        self.contentView.configure(viewModel: viewModel)
        self.updateUI()
    }
    
    private func updateUI() {
        self.setTitle("", for: .normal)
        self.removeSubviews()
        self.embedSubview(contentView)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        self.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        self.clipsToBounds = true
        self.setBackgroundImage(UIImage(color: DKUIColors.secondaryColor.color), for: .normal)
    }
}
