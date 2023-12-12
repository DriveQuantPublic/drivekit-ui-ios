//
//  VehiclePickerDefaultCarEngineVC.swift
//  DriveKitVehicleUI
//
//  Created by Amine Gahbiche on 12/12/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehiclePickerDefaultCarEngineVC: VehiclePickerStepView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!

    init (viewModel: VehiclePickerViewModel) {
        super.init(nibName: String(describing: VehiclePickerDefaultCarEngineVC.self), bundle: .vehicleUIBundle)
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
        self.topConstraint.constant = 20
        imageView.image = DKVehicleImages.vehicleIsItElectric.image
        textLabel.attributedText = "dk_vehicle_is_it_electric"
            .dkVehicleLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: .normalText)
            .color(.mainFontColor)
            .build()
        confirmButton.configure(title: DKCommonLocalizable.validate.text(), style: .full)
    }

    @IBAction func didConfirmInput(_ sender: Any) {
        
        // TODO: set the selected value
        self.viewModel.isElectric = false
        self.viewModel.nextStep(.defaultCarEngine)
    }
}
