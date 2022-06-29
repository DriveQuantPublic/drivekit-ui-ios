//
//  AlternativeTripDetailInfoVC.swift
//  IFPClient
//
//  Created by David Bauduin on 31/07/2020.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

class AlternativeTripDetailInfoVC: UIViewController {
    @IBOutlet private weak var transportationModeImage: UIImageView!
    @IBOutlet private weak var changeTransportationModeButton: UIButton!
    @IBOutlet private weak var detectedTransportationModeContainer: UIView!
    @IBOutlet private weak var detectedTransportationModeTitle: UILabel!
    @IBOutlet private weak var detectedTransportationModeValue: UILabel!
    @IBOutlet private weak var declaredTransportationModeContainer: UIView!
    @IBOutlet private weak var declaredTransportationModeTitle: UILabel!
    @IBOutlet private weak var declaredTransportationModeValue: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var tripConditionTitle: UILabel!
    @IBOutlet private weak var tripConditionValue: UILabel!
    @IBOutlet private weak var tripWeatherTitle: UILabel!
    @IBOutlet private weak var tripWeatherValue: UILabel!
    @IBOutlet private weak var tripAverageSpeedTitle: UILabel!
    @IBOutlet private weak var tripAverageSpeedValue: UILabel!
    @IBOutlet private var separators: [UIView]!

    let viewModel: AlternativeTripViewModel
    private weak var parentView: UIViewController?

    init(viewModel: AlternativeTripViewModel, parentView: UIViewController) {
        self.viewModel = viewModel
        self.parentView = parentView
        super.init(nibName: String(describing: AlternativeTripDetailInfoVC.self), bundle: Bundle.driverDataUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTransportationModeButton.configure(text: "dk_driverdata_change_transportation_mode".dkDriverDataLocalized(), style: .full)
        
        self.detectedTransportationModeTitle.attributedText = "dk_driverdata_detected_transportation_mode".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        self.declaredTransportationModeTitle.attributedText = "dk_driverdata_declared_transportation_mode".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        
        self.tripConditionTitle.attributedText = "dk_driverdata_synthesis_condition".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        self.tripWeatherTitle.attributedText = "dk_driverdata_synthesis_weather".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        self.tripAverageSpeedTitle.attributedText = "dk_driverdata_synthesis_mean_speed".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()

        let separatorColor = DKUIColors.neutralColor.color
        for separator in self.separators {
            separator.backgroundColor = separatorColor
        }

        update()
    }

    func update() {
        let valueStyle = DKStyle(size: DKStyles.smallText.style.size, traits: UIFontDescriptor.SymbolicTraits.traitBold)
        let detectionModeStyle = DKStyle(size: DKStyles.smallText.style.size, traits: UIFontDescriptor.SymbolicTraits.traitBold)
        if let declaredMode = self.viewModel.declaredTransportationMode() {
            self.detectedTransportationModeValue.attributedText = self.viewModel.detectedTransportationMode().getName().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
            self.declaredTransportationModeContainer.isHidden = false
            self.declaredTransportationModeValue.attributedText = declaredMode.getName().dkAttributedString().font(dkFont: .primary, style: detectionModeStyle).color(.primaryColor).build()
            self.transportationModeImage.image = declaredMode.getImage()
            self.messageLabel.attributedText = "dk_driverdata_alternative_transportation_thanks".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
            self.declaredTransportationModeValue.textColor = DKUIColors.primaryColor.color
            
        } else {
            self.detectedTransportationModeValue.attributedText = self.viewModel.detectedTransportationMode().getName().dkAttributedString().font(dkFont: .primary, style: detectionModeStyle).color(.primaryColor).build()
            self.declaredTransportationModeContainer.isHidden = true
            self.transportationModeImage.image = nil
            self.messageLabel.attributedText = "dk_driverdata_alternative_transportation_remark".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
            self.detectedTransportationModeValue.textColor = DKUIColors.primaryColor.color
            self.transportationModeImage.image = self.viewModel.detectedTransportationMode().getImage()
        }
        
        self.tripConditionValue.attributedText = self.viewModel.conditionValue.dkAttributedString().font(dkFont: .primary, style: valueStyle).color(.primaryColor).build()
        self.tripWeatherValue.attributedText = self.viewModel.weatherValue.dkAttributedString().font(dkFont: .primary, style: valueStyle).color(.primaryColor).build()
        self.tripAverageSpeedValue.attributedText = self.viewModel.meanSpeedValue.dkAttributedString().font(dkFont: .primary, style: valueStyle).color(.primaryColor).build()
    }

    @IBAction private func changeTransportationMode() {
        let transportationModeVC = TransportationModeVC(viewModel: self.viewModel.getTransportationModeViewModel(), parent: self)
        self.parentView?.navigationController?.pushViewController(transportationModeVC, animated: true)
    }
}
