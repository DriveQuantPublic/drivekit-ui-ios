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
    
    init(viewModel: SynthesisPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: SynthesisPageVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    func setup() {        
        vehicleTitle.text = "dk_synthesis_vehicle".dkDriverDataLocalized()
        DriverDataStyle.applyTitleSynthesis(label: vehicleTitle)
        
        vehicleValue.text = "-"
        DriverDataStyle.applyTripMainValue(label: vehicleValue, color: DKUIColors.secondaryColor.color)
        
        consumptionTitle.text = "dk_synthesis_fuel_consumption".dkDriverDataLocalized()
        DriverDataStyle.applyTitleSynthesis(label: consumptionTitle)
        
        consumptionValue.text = viewModel.fuelConsumptionValue
        DriverDataStyle.applyTripMainValue(label: consumptionValue, color: DKUIColors.primaryColor.color)

        conditionTitle.text = "dk_synthesis_condition".dkDriverDataLocalized()
        DriverDataStyle.applyTitleSynthesis(label: conditionTitle)

        conditionValue.text = viewModel.conditionValue
        DriverDataStyle.applyTripMainValue(label: conditionValue, color: DKUIColors.primaryColor.color)
        
        speedTitle.text = "dk_synthesis_mean_speed".dkDriverDataLocalized()
        DriverDataStyle.applyTitleSynthesis(label: speedTitle)

        speedValue.text = viewModel.meanSpeedValue
        DriverDataStyle.applyTripMainValue(label: speedValue, color: DKUIColors.primaryColor.color)

        stopTimeTitle.text = "dk_synthesis_mean_speed".dkDriverDataLocalized()
        DriverDataStyle.applyTitleSynthesis(label: stopTimeTitle)

        stopTimeValue.text = viewModel.stopTimeValue
        DriverDataStyle.applyTripMainValue(label: stopTimeValue, color: DKUIColors.primaryColor.color)

        carbonTitle.text = "dk_synthesis_co2_emmissions".dkDriverDataLocalized()
        DriverDataStyle.applyTitleSynthesis(label: carbonTitle)

        carbonValue.text = viewModel.co2EmissionValue
        DriverDataStyle.applyTripMainValue(label: carbonValue, color: DKUIColors.primaryColor.color)
        
        weatherTitle.text = "dk_synthesis_weather".dkDriverDataLocalized()
        DriverDataStyle.applyTitleSynthesis(label: weatherTitle)
        
        weatherValue.text = viewModel.weatherValue
        DriverDataStyle.applyTripMainValue(label: weatherValue, color: DKUIColors.primaryColor.color)

        carbonVolumeTitle.text = "dk_synthesis_co2_mass".dkDriverDataLocalized()
        DriverDataStyle.applyTitleSynthesis(label: carbonVolumeTitle)

        carbonVolumeValue.text = viewModel.co2MassValue
        DriverDataStyle.applyTripMainValue(label: carbonVolumeValue, color: DKUIColors.primaryColor.color)

        contextTitle.text = "dk_synthesis_road_context".dkDriverDataLocalized()
        DriverDataStyle.applyTitleSynthesis(label: contextTitle)

        contextValue.text = viewModel.contextValue
        DriverDataStyle.applyTripMainValue(label: contextValue, color: DKUIColors.primaryColor.color)
        
    }
}
