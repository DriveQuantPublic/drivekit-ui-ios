//
//  ConnectBluetoothVC.swift
//  IFPClient
//
//  Created by Meryl Barantal on 03/01/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBVehicleAccess

public class ConnectBluetoothVC: DKUIViewController {
    @IBOutlet var setupTitle: UILabel!
    @IBOutlet var setupDesc1: UILabel!
    @IBOutlet var setupDesc2: UILabel!
    @IBOutlet var setupDesc3: UILabel!
    @IBOutlet var startButton: UIButton!
    
    private let viewModel: BluetoothViewModel
    private let presentingView : UIViewController
    
    public init(vehicle: DKVehicle, parentView : UIViewController) {
        self.viewModel = BluetoothViewModel(vehicle: vehicle)
        self.presentingView = parentView
        super.init(nibName: "ConnectBluetoothVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "dk_vehicle_bluetooth_combination_view_title".dkVehicleLocalized()
        self.setup()
    }
    
    func setup(){
        setupTitle.attributedText = "dk_vehicle_bluetooth_guide_header".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).uppercased().build()
        setupDesc1.attributedText = "dk_vehicle_bluetooth_guide_desc1_ios".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        setupDesc2.attributedText = "dk_vehicle_bluetooth_guide_desc2_ios".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        setupDesc3.attributedText = "dk_vehicle_bluetooth_guide_desc3_ios".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        
        startButton.configure(text: "dk_vehicle_begin".dkVehicleLocalized(), style: .full)
    }
    
    @IBAction func startAction(_ sender: Any) {
        if self.viewModel.getBluetoothDevices().count == 0 {
            let errorVC: ErrorBluetoothVC = ErrorBluetoothVC(parentView: presentingView)
            self.navigationController?.pushViewController(errorVC, animated: true)
        } else {
            let selectVC: SelectBluetoothVC = SelectBluetoothVC(viewModel: viewModel, parentView: presentingView)
            self.navigationController?.pushViewController(selectVC, animated: true)
        }
    }
}
