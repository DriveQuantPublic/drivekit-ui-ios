//
//  SynthesisPageVC.swift
//  DriveKitDriverDataUI
//
//  Created by Meryl Barantal on 17/12/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class SynthesisPageVC: UIViewController {
    var viewModel: SynthesisPageViewModel
    
    @IBOutlet var vehicleTitle: UILabel!
    @IBOutlet var vehicleValue: UILabel!
    @IBOutlet var vehicleView: UIView!
    
    @IBOutlet var consumptionTitle: UILabel!
    @IBOutlet var consumptionValue: UILabel!
    
    @IBOutlet var conditionTitle: UILabel!
    @IBOutlet var conditionValue: UILabel!
    
    @IBOutlet var speedTitle: UILabel!
    @IBOutlet var speedValue: UILabel!
    
    @IBOutlet var carbonTitle: UILabel!
    @IBOutlet var carbonValue: UILabel!
    
    @IBOutlet var weatherTitle: UILabel!
    @IBOutlet var weatherValue: UILabel!
    
    @IBOutlet var stopTimeTitle: UILabel!
    @IBOutlet var stopTimeValue: UILabel!
    
    @IBOutlet var carbonVolumeTitle: UILabel!
    @IBOutlet var carbonVolumeValue: UILabel!
    
    @IBOutlet var contextTitle: UILabel!
    @IBOutlet var contextValue: UILabel!
    
    private weak var parentView : UIViewController?
    
    init(viewModel: SynthesisPageViewModel, parentView : UIViewController) {
        self.viewModel = viewModel
        self.parentView = parentView
        super.init(nibName: String(describing: SynthesisPageVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.configureVehicleName()
        self.configureVehicleClick()
    }
    
    private func setup() {
        vehicleTitle.attributedText = "dk_driverdata_synthesis_vehicle".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        vehicleValue.attributedText = "-".dkAttributedString().font(dkFont: .primary, style: .smallText).color(.secondaryColor).build()

        consumptionTitle.attributedText = "dk_driverdata_synthesis_fuel_consumption".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        consumptionValue.attributedText = viewModel.fuelConsumptionValue.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.primaryColor).build()

        conditionTitle.attributedText = "dk_driverdata_synthesis_condition".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        conditionValue.attributedText = viewModel.conditionValue.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.primaryColor).build()
        
        speedTitle.attributedText = "dk_driverdata_synthesis_mean_speed".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        speedValue.attributedText = viewModel.meanSpeedValue.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.primaryColor).build()

        stopTimeTitle.attributedText = "dk_driverdata_synthesis_mean_speed".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        stopTimeValue.attributedText = viewModel.stopTimeValue.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.primaryColor).build()

        carbonTitle.attributedText = "dk_driverdata_synthesis_co2_emissions".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        carbonValue.attributedText = viewModel.co2EmissionValue.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.primaryColor).build()
        
        weatherTitle.attributedText = "dk_driverdata_synthesis_weather".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        weatherValue.attributedText = viewModel.weatherValue.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.primaryColor).build()

        carbonVolumeTitle.attributedText = "dk_driverdata_synthesis_co2_mass".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        carbonVolumeValue.attributedText = viewModel.co2MassValue.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.primaryColor).build()

        contextTitle.attributedText = "dk_driverdata_synthesis_road_context".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        contextValue.attributedText = viewModel.contextValue.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.primaryColor).build()
    }
    
    private func configureVehicleName() {
        if let dKVehicleUI = DriveKitNavigationController.shared.vehicleUI, let vehicleId = self.viewModel.vehicleId {
            dKVehicleUI.getVehicleNameWith(vehicleId: vehicleId, completion: { [weak self] name in
                DispatchQueue.main.async {
                    if let vehicleName = name {
                        self?.vehicleValue.attributedText = vehicleName.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.secondaryColor).build()
                    }
                }
            })
        }
    }
    
    private func configureVehicleClick() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(vehicleClicked))
        vehicleValue.isUserInteractionEnabled = true
        vehicleValue.addGestureRecognizer(singleTap)
    }
    
    @objc private func vehicleClicked() {
        if let dKVehicleUI = DriveKitNavigationController.shared.vehicleUI, let vehicleId = self.viewModel.vehicleId {
            dKVehicleUI.getVehicleDetailViewController(vehicleId: vehicleId, completion: { [weak self] viewController in
                DispatchQueue.main.async {
                    if let vc = viewController {
                        self?.parentView?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            })
        }
    }
}
