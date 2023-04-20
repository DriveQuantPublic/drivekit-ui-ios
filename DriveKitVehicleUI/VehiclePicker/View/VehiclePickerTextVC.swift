// swiftlint:disable all
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
    let liteModeButtonHeight = 44.0
    let bothConfigModeButtonHeight = 96.0

    @IBOutlet weak var textImageView: UIImageView!
    @IBOutlet weak var textDescriptionLabel: UILabel!
    @IBOutlet weak var textConfirmButton: UIButton!
    @IBOutlet weak var textContinueButton: UIButton!
    @IBOutlet weak var confirmButtonHeightConstraint: NSLayoutConstraint!
    
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
            if DriveKitVehicleUI.shared.categoryConfigType == .liteConfigOnly {
                textConfirmButton.configure(title: DKCommonLocalizable.validate.text(), style: .full)
                confirmButtonHeightConstraint.constant = liteModeButtonHeight
                textConfirmButton.addTarget(self, action: #selector(didConfirmText), for: .touchUpInside)
                textContinueButton.isHidden = true
            } else {
                textConfirmButton.configure(
                    title: "dk_vehicle_detail_category_button_title".dkVehicleLocalized(),
                    subtitle: "dk_vehicle_detail_category_button_description".dkVehicleLocalized(),
                    style: .multilineBordered
                )
                confirmButtonHeightConstraint.constant = bothConfigModeButtonHeight
                textConfirmButton.addTarget(self, action: #selector(didContinueText), for: .touchUpInside)
                
                textContinueButton.configure(
                    title: "dk_vehicle_quick_category_button_title".dkVehicleLocalized(),
                    subtitle: "dk_vehicle_quick_category_button_description".dkVehicleLocalized(),
                    style: .multilineBordered
                )
            }
        } else {
            textConfirmButton.isEnabled = false
            textContinueButton.isEnabled = false
        }
    }

    @IBAction func didConfirmText(_ sender: Any) {
        self.viewModel.vehicleCategory?.onLiteConfigSelected(viewModel: viewModel)
    }
    
    @IBAction func didContinueText(_ sender: Any) {
        self.viewModel.vehicleCategory?.onFullConfigSelected(viewModel: viewModel)
    }
    
}
