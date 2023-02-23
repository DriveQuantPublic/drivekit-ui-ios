//
//  DKDateSelectorView.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

public class DKDateSelectorView: UIView {
    @IBOutlet private weak var dateIntervalLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var previousButton: UIButton!

    private var viewModel: DKDateSelectorViewModel?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    public func configure(viewModel: DKDateSelectorViewModel?) {
        self.viewModel = viewModel
        self.setupView()
        self.viewModel?.dateSelectorViewModelDidUpdate = { [weak self] in
            self?.setupView()
        }
    }

    func setupView() {
        self.dateIntervalLabel.attributedText = self.viewModel?.getDateIntervalAttributedText()
        self.nextButton.isEnabled = self.viewModel?.hasNextDate ?? false
        self.previousButton.isEnabled = self.viewModel?.hasPreviousDate ?? false
        
        self.nextButton.tintColor = DKUIColors.secondaryColor.color
        self.previousButton.tintColor = DKUIColors.secondaryColor.color
    }

    @IBAction func showNextDate() {
        self.viewModel?.moveToNextDate()
    }

    @IBAction func showPreviousDate() {
        self.viewModel?.moveToPreviousDate()
    }
}

extension DKDateSelectorView {
    public static func createDateSelectorView(
        configuredWith viewModel: DKDateSelectorViewModel,
        embededIn containerView: UIView
    ) {
        guard let dateSelectorView = Bundle.driveKitCommonUIBundle?.loadNibNamed(
            "DKDateSelectorView",
            owner: nil
        )?.first as? DKDateSelectorView else {
            preconditionFailure("Can't find bundle or nib for DateSelectorView")
        }
        
        dateSelectorView.configure(viewModel: viewModel)
        containerView.embedSubview(dateSelectorView)
        containerView.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        containerView.clipsToBounds = true
    }
}
