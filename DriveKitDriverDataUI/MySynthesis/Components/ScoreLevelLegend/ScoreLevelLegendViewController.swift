//
//  ScoreLevelLegendViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 03/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

public class ScoreLevelLegendViewController: UIViewController {
    @IBOutlet private weak var legendTitleLabel: UILabel!
    @IBOutlet private weak var legendDescriptionLabel: UILabel!
    @IBOutlet private weak var legendStackView: UIStackView!

    private var viewModel: ScoreLevelLegendViewModel!
    
    public init(viewModel: ScoreLevelLegendViewModel) {
        self.viewModel = viewModel
        super.init(
            nibName: String(describing: ScoreLevelLegendViewController.self),
            bundle: .driverDataUIBundle
        )
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let closeButton = UIBarButtonItem(
            title: DKCommonLocalizable.close.text(),
            style: .done,
            target: self,
            action: #selector(closeButtonTapped)
        )
        
        legendTitleLabel.text = viewModel.legendTitle
        legendTitleLabel.font = DKStyles.headLine2.style.applyTo(font: .primary)
        legendTitleLabel.textColor = DKUIColors.primaryColor.color
        
        legendDescriptionLabel.text = viewModel.legendDescription
        legendDescriptionLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        legendDescriptionLabel.textColor = DKUIColors.mainFontColor.color
        
        viewModel.scoreLevelRowViewModels?.forEach { [weak self] viewModel in
            guard let self else { return }
            ScoreLevelLegendRowView.createScoreLevelLegendRowView(
                configuredWith: viewModel,
                embededIn: self.legendStackView
            )
        }
        
        closeButton.tintColor = DKUIColors.secondaryColor.color
        self.navigationItem.rightBarButtonItem = closeButton
    }

    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}

extension ScoreLevelLegendViewController {
    public static func createScoreLevelLegendViewController(
        configuredWith viewModel: ScoreLevelLegendViewModel,
        presentedBy viewController: UIViewController
    ) {
        let scoreLevelLegendViewController = ScoreLevelLegendViewController(viewModel: viewModel)
        scoreLevelLegendViewController.modalPresentationStyle = .formSheet
        viewController.present(
            UINavigationController(
                rootViewController: scoreLevelLegendViewController
            ),
            animated: true
        )
    }
}
