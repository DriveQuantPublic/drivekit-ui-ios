//
//  VehiclePickerTextVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 28/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehiclePickerTextVC: VehiclePickerStepView {

    @IBOutlet weak var textImageView: UIImageView!
    @IBOutlet weak var textDescriptionLabel: UILabel!
    @IBOutlet weak var textConfirmButton: UIButton!
    @IBOutlet weak var textContinueButton: UIButton!

    init (viewModel: VehiclePickerViewModel) {
        super.init(nibName: String(describing: VehiclePickerTextVC.self), bundle: .vehicleUIBundle)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    func setup() {
        if let category = self.viewModel.vehicleCategory {
            textImageView.image = category.categoryImage()
            textDescriptionLabel.attributedText = category.categoryDescription().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
            textConfirmButton.setAttributedTitle(DKCommonLocalizable.validate.text().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).build(), for: .normal)
            textConfirmButton.backgroundColor = DKUIColors.secondaryColor.color
            textContinueButton.setAttributedTitle("dk_vehicle_category_display_brands".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .button).color(.secondaryColor).build(), for: .normal)
            textContinueButton.titleLabel?.textAlignment = .center
            if DriveKitVehicleUI.shared.categoryConfigType == .liteConfigOnly {
                textContinueButton.isHidden = true
            }
        } else {
            textConfirmButton.isEnabled = false
            textContinueButton.isEnabled = false
        }
    }

    @IBAction func didConfirmText(_ sender: Any) {
        self.viewModel.vehicleCategory?.onLiteConfigSelected(viewModel: viewModel)
        self.viewModel.coordinator.showStep(viewController: self.viewModel.getViewController())
    }
    
    @IBAction func didContinueText(_ sender: Any) {
        self.viewModel.vehicleCategory?.onFullConfigSelected(viewModel: viewModel)
        self.viewModel.coordinator.showStep(viewController: self.viewModel.getViewController())
    }
    
}
