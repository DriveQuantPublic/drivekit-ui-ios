//
//  ErrorBluetoothVC.swift
//  IFPClient
//
//  Created by Meryl Barantal on 03/01/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ErrorBluetoothVC: DKUIViewController {
    
    @IBOutlet var errorText: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    
    private let presentingView : UIViewController
    
    public init(parentView : UIViewController) {
        self.presentingView = parentView
        super.init(nibName: "ErrorBluetoothVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "dk_vehicle_bluetooth_combination_view_title".dkVehicleLocalized()
        self.setup()
    }
    
    
    func setup(){
        errorText.attributedText = "dk_vehicle_bluetooth_not_found".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        cancelButton.backgroundColor = DKUIColors.secondaryColor.color
        cancelButton.setAttributedTitle(DKCommonLocalizable.cancel.text().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).uppercased().build(), for: .normal)
        
        settingsButton.setAttributedTitle("dk_vehicle_open_bluetooth_settings".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .button).color(.secondaryColor).uppercased().build(), for: .normal)
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popToViewController(self.presentingView, animated: true)
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        guard #available(iOS 10, *) else {
            UIApplication.shared.openURL(settingsUrl)
            return
        }
        UIApplication.shared.open(settingsUrl)
    }
    
}
