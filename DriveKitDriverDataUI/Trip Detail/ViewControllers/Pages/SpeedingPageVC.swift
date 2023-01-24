//
//  SpeedingPageVC.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 08/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class SpeedingPageVC: UIViewController {

    @IBOutlet private var circularRingContainer: UIView!
    @IBOutlet private var circularRingTitle: UILabel!
    @IBOutlet private var summaryContainer: UIStackView!
    @IBOutlet private var infoButton: UIButton!

    private var viewModel: SpeedingPageViewModel

    init(viewModel: SpeedingPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: SpeedingPageVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    func configure() {
        let score = CircularProgressView.viewFromNib
        let configScore = ConfigurationCircularProgressView(scoreType: viewModel.scoreType, value: viewModel.getScore(), size: .large)
        score.configure(configuration: configScore)
        score.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        score.center = circularRingContainer.center
        circularRingContainer.embedSubview(score)
        circularRingTitle.attributedText = viewModel.getScoreTitle().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
        setupSummaryContainer()
        infoButton.setImage(DKImages.info.image, for: .normal)
        infoButton.tintColor = DKUIColors.secondaryColor.color
    }
    
    func setupSummaryContainer() {
        summaryContainer.removeAllSubviews()

        let distanceView = SpeedingPageItemView.viewFromNib
        distanceView.configure(title: viewModel.getDistanceTitle(), description: viewModel.getDistanceDescription(), value: viewModel.getDistancePercentage(), displayValue: true)
        summaryContainer.addArrangedSubview(distanceView)

        let durationView = SpeedingPageItemView.viewFromNib
        durationView.configure(title: viewModel.getDurationTitle(), description: viewModel.getDurationDescription(), value: viewModel.getDurationPercentage(), displayValue: viewModel.shouldDisplayDuration())
        summaryContainer.addArrangedSubview(durationView)
    }
    
    @IBAction func infoAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "dk_driverdata_speeding_score".dkDriverDataLocalized(), message: "dk_driverdata_speeding_score_info".dkDriverDataLocalized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
