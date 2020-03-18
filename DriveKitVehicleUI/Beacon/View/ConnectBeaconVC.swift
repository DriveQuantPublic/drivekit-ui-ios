//
//  ConnectBeaconVC.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 10/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBVehicleAccess

public class ConnectBeaconVC: DKUIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var step1Circle: UIView!
    @IBOutlet weak var step1ValueCircle: UILabel!
    @IBOutlet weak var step1Label: UILabel!
    
    @IBOutlet weak var step2Circle: UIView!
    @IBOutlet weak var step2ValueCircle: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    
    @IBOutlet weak var step3Circle: UIView!
    @IBOutlet weak var step3ValueCircle: UILabel!
    @IBOutlet weak var step3Label: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    private let viewModel : BeaconViewModel
    private let parentView : UIViewController
    
    public init(vehicle: DKVehicle, parentView: UIViewController) {
        self.viewModel = BeaconViewModel(vehicle: vehicle, scanType: .pairing)
        self.parentView = parentView
        super.init(nibName: "ConnectBeaconVC", bundle: .vehicleUIBundle)
        self.title = "dk_beacon_paired_title".dkVehicleLocalized()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView() {
        titleLabel.attributedText = "dk_vehicle_beacon_setup_guide_title".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).uppercased().build()
        
        configureCircle(view: step1Circle)
        step1ValueCircle.attributedText = "1".dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        step1Label.attributedText = "dk_vehicle_beacon_setup_guide_desc1".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        
        configureCircle(view: step2Circle)
        step2ValueCircle.attributedText = "2".dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        step2Label.attributedText = "dk_vehicle_beacon_setup_guide_desc2".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        
        configureCircle(view: step3Circle)
        step3ValueCircle.attributedText = "3".dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        step3Label.attributedText = "dk_vehicle_beacon_setup_guide_desc3".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
    
        confirmButton.backgroundColor = DKUIColors.secondaryColor.color
        confirmButton.setAttributedTitle("dk_vehicle_begin".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).uppercased().build(), for: .normal)
    }
    
    private func configureCircle(view: UIView) {
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
        view.layer.borderColor = DKUIColors.mainFontColor.color.cgColor
        view.layer.borderWidth = 4.0
    }
    
    @IBAction func startBeaconPairing(_ sender: Any) {
        let beaconInputIdVC = BeaconInputIdVC(viewModel: viewModel, parentView: parentView)
        navigationController?.pushViewController(beaconInputIdVC, animated: true)
    }
}
