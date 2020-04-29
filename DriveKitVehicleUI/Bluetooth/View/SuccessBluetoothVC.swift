//
//  SuccessBluetoothVC.swift
//  IFPClient
//
//  Created by Meryl Barantal on 03/01/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class SuccessBluetoothVC: DKUIViewController {
    @IBOutlet var successTitle: UILabel!
    @IBOutlet var successDesc: UILabel!
    @IBOutlet var successImage: UIImageView!
    @IBOutlet var successNotice: UILabel!
    @IBOutlet var successButton: UIButton!
    
    private let viewModel: BluetoothViewModel
    
    public init(viewModel: BluetoothViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SuccessBluetoothVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "dk_vehicle_bluetooth_combination_view_title".dkVehicleLocalized()
        self.setup()
        self.setupDesc()
    }
    
    func setup() {
        successTitle.attributedText = "dk_vehicle_bluetooth_congrats_title".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).build()
        successButton.configure(text: DKCommonLocalizable.finish.text(), style: .full)
        successImage.image = UIImage(named: "dk_vehicle_congrats",in: .vehicleUIBundle, compatibleWith: nil)
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.hidesBackButton = true
        setupDesc()
        setupNotice()
    }
    
    func setupDesc() {
        let bluetoothName = self.viewModel.bluetoothName.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
        let vehicelName = self.viewModel.vehicleName.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
        successDesc.attributedText = "dk_vehicle_bluetooth_congrats_desc".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).buildWithArgs(bluetoothName, vehicelName)
    }
    
    func setupNotice() {
        let bluetoothName = self.viewModel.bluetoothName.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
        successNotice.attributedText = "dk_vehicle_bluetooth_congrats_notice".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).buildWithArgs(bluetoothName)
    }
    
    @IBAction func successAction(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        if viewControllers.count >= 4{
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
        } else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
