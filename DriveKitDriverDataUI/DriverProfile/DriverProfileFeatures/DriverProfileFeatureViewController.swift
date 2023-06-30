//
//  DriverProfileFeatureViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class DriverProfileFeatureViewController: UIViewController, DKUIPageViewModel {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionTextLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    var viewModel: DriverProfileFeatureViewModel
    var pageId: DriverProfileFeature
    
    required init(pageId: DriverProfileFeature, pageViewModel: DriverProfileFeatureViewModel) {
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
        self.titleLabel.font = DKStyles.headLine2.style.applyTo(font: .primary)
        self.descriptionTextLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.descriptionTextLabel.textColor = DKUIColors.complementaryFontColor.color
        refreshView()
    }
    
    private func refreshView() {
        self.titleLabel.text = viewModel.title
        self.descriptionTextLabel.text = viewModel.descriptionText
        self.iconImageView.image = UIImage(
            named: viewModel.iconName,
            in: .driverDataUIBundle,
            compatibleWith: self.traitCollection
        )
    }
}
