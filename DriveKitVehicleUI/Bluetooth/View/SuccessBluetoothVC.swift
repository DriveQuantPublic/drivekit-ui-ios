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
    private let presentingView : UIViewController
    
    public init(viewModel: BluetoothViewModel, parentView : UIViewController) {
        self.viewModel = viewModel
        self.presentingView = parentView
        super.init(nibName: "SuccessBluetoothVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        successTitle.attributedText = "dk_vehicle_bluetooth_congrats_title".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).build()
        successButton.backgroundColor = DKUIColors.secondaryColor.color
        successButton.setAttributedTitle(DKCommonLocalizable.finish.text().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).build(), for: .normal)
        successImage.image = UIImage(named: "dk_vehicle_congrats",in: .vehicleUIBundle, compatibleWith: nil)
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.hidesBackButton = true
        setupDesc()
        setupNotice()
    }
    
    func setupDesc() {
        
        let descString = String(format: "dk_vehicle_bluetooth_congrats_desc".dkVehicleLocalized(), viewModel.bluetoothName, viewModel.vehicleName)
        /*let descAttributedString = NSMutableAttributedString(string: descString, attributes: Attributes.primaryAttributes(size: 16))
        let rangeBluetooth = (descAttributedString.string as NSString).range(of: bluetoothName)
        let rangeVehicle = (descAttributedString.string as NSString).range(of: vehicleName)
        descAttributedString.setAttributes(Attributes.primaryBoldAttributes(size: 16), range: rangeBluetooth)
        descAttributedString.setAttributes(Attributes.primaryBoldAttributes(size: 16), range: rangeVehicle)
        successDesc.attributedText = descAttributedString*/
    }
    
    func setupNotice() {
        let noticeString = String(format: "dk_vehicle_bluetooth_congrats_notice".dkVehicleLocalized(), viewModel.bluetoothName)
        /*let noticeAttributedString = NSMutableAttributedString(string: noticeString, attributes: Attributes.primaryAttributes(size: 16))
        let rangeBluetooth = (noticeAttributedString.string as NSString).range(of: bluetoothName)
        noticeAttributedString.setAttributes(Attributes.primaryBoldAttributes(size: 16), range: rangeBluetooth)
        successNotice.attributedText = noticeAttributedString*/
    }
    
    @IBAction func successAction(_ sender: Any) {
        self.navigationController?.popToViewController(self.presentingView, animated: true)
    }
}
