//
//  DriverDistanceEstimationViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import UIKit

class DriverDistanceEstimationViewController: UIViewController, DKUIPageViewModel {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var estimationLabel: UILabel!
    @IBOutlet private weak var realDistanceLabel: UILabel!
    @IBOutlet private weak var estimationBarView: UIView!
    @IBOutlet private weak var realDistanceBarView: UIView!
    @IBOutlet private weak var estimationLegendLabel: UILabel!
    @IBOutlet private weak var realDistanceLegendLabel: UILabel!
    @IBOutlet private weak var estimationLegendCircle: UIView!
    @IBOutlet private weak var realDistanceLegendCircle: UIView!
    @IBOutlet private weak var referenceView: UIView!

    @IBOutlet private weak var realDistancePaddingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var estimationPaddingConstraint: NSLayoutConstraint!

    var viewModel: DriverDistanceEstimationViewModel
    var pageId: DKPeriod
    
    required init(pageId: DKPeriod, pageViewModel: DriverDistanceEstimationViewModel) {
        self.viewModel = pageViewModel
        self.pageId = pageId
        super.init(
            nibName: String(describing: Self.self),
            bundle: .driverDataUIBundle
        )
        self.viewModel.viewModelDidUpdate = { [weak self] in
            self?.refreshView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = viewModel.title
        self.titleLabel.textColor = DKUIColors.mainFontColor.color
        self.estimationLegendLabel.text = viewModel.estimationLegendText
        self.realDistanceLegendLabel.text = viewModel.realDistanceLegendText
        self.estimationLegendLabel.textColor = DKUIColors.complementaryFontColor.color
        self.realDistanceLegendLabel.textColor = DKUIColors.complementaryFontColor.color
        self.estimationLabel.textColor = DKUIColors.complementaryFontColor.color
        self.realDistanceLabel.textColor = DKUIColors.complementaryFontColor.color
        self.refreshView()
    }
    
    private func refreshView() {
        if viewModel.hasData {
            self.estimationLabel.text = viewModel.estimation.formatWithThousandSeparator()
            self.realDistanceLabel.text = viewModel.realDistance.formatWithThousandSeparator()
            self.estimationLegendCircle.backgroundColor = DKUIColors.primaryColor.color
            self.realDistanceLegendCircle.backgroundColor = DKUIColors.secondaryColor.color
            self.estimationBarView.backgroundColor = DKUIColors.primaryColor.color
            self.realDistanceBarView.backgroundColor = DKUIColors.secondaryColor.color
            self.estimationPaddingConstraint.constant = viewModel.estimationPaddingPercent * self.referenceView.frame.width
            self.realDistancePaddingConstraint.constant = viewModel.realDistancePaddingPercent * self.referenceView.frame.width
        } else {
            self.estimationLabel.text = ""
            self.realDistanceLabel.text = ""
            self.estimationLegendCircle.backgroundColor = DKUIColors.neutralColor.color
            self.realDistanceLegendCircle.backgroundColor = DKUIColors.neutralColor.color
            self.estimationBarView.backgroundColor = DKUIColors.neutralColor.color
            self.realDistanceBarView.backgroundColor = DKUIColors.neutralColor.color
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewModel.hasData {
            self.estimationPaddingConstraint.constant = viewModel.estimationPaddingPercent * self.referenceView.frame.width
            self.realDistancePaddingConstraint.constant = viewModel.realDistancePaddingPercent * self.referenceView.frame.width
        }
    }
}
