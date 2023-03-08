//
//  ScoreLevelLegendRowView.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 03/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

public class ScoreLevelLegendRowView: UIStackView {
    @IBOutlet private weak var scoreLevelDescriptionLabel: UILabel!
    @IBOutlet private weak var colorSwatchView: UIView!
    
    private var viewModel: ScoreLevelLegendRowViewModel?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public func configure(viewModel: ScoreLevelLegendRowViewModel?) {
        self.viewModel = viewModel
        self.setupView()
        self.viewModel?.scoreLevelLegendRowViewModelDidUpdate = { [weak self] in
            self?.setupView()
        }
    }
    
    func setupView() {
        colorSwatchView.backgroundColor = viewModel?.scoreLevelColor
        scoreLevelDescriptionLabel.attributedText = viewModel?.scoreLevelDescription
    }
}

extension ScoreLevelLegendRowView {
    public static func createScoreLevelLegendRowView(
        configuredWith viewModel: ScoreLevelLegendRowViewModel,
        embededIn stackView: UIStackView
    ) {
        guard let scoreLevelLegendRowView = Bundle.driverDataUIBundle?.loadNibNamed(
            "ScoreLevelLegendRowView",
            owner: nil
        )?.first as? ScoreLevelLegendRowView else {
            preconditionFailure("Can't find bundle or nib for ScoreLevelLegendRowView")
        }
        
        scoreLevelLegendRowView.configure(viewModel: viewModel)
        scoreLevelLegendRowView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(scoreLevelLegendRowView)
    }
}
