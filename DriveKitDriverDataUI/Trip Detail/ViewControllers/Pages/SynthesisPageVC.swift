//
//  SynthesisPageVC.swift
//  DriveKitDriverDataUI
//
//  Created by Meryl Barantal on 17/12/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

class SynthesisPageVC: UIViewController {
    var viewModel: SynthesisPageViewModel
    var detailConfig: TripDetailViewConfig
    var config: TripListViewConfig
    
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
    
    init(viewModel: SynthesisPageViewModel, detailConfig: TripDetailViewConfig, config: TripListViewConfig) {
        self.viewModel = viewModel
        self.detailConfig =  detailConfig
        self.config = config
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
        vehicleTitle.text = viewModel.synthesisVehicle
        DriverDataStyle.applyTitleSynthesis(label: vehicleTitle)
        vehicleValue.text = "-"
        DriverDataStyle.applyTripMainValue(label: vehicleValue, color: config.secondaryColor)
        
        consumptionTitle.text = viewModel.fuelConsumption
        DriverDataStyle.applyTitleSynthesis(label: consumptionTitle)
        
        consumptionValue.text = viewModel.fuelConsumptionValue
        DriverDataStyle.applyTripMainValue(label: consumptionValue, color: config.primaryColor)

        conditionTitle.text = viewModel.condition
        DriverDataStyle.applyTitleSynthesis(label: conditionTitle)

        conditionValue.text = viewModel.conditionValue
        DriverDataStyle.applyTripMainValue(label: conditionValue, color: config.primaryColor)
        
        speedTitle.text = viewModel.meanSpeed
        DriverDataStyle.applyTitleSynthesis(label: speedTitle)

        speedValue.text = viewModel.meanSpeedValue
        DriverDataStyle.applyTripMainValue(label: speedValue, color: config.primaryColor)

        stopTimeTitle.text = viewModel.stopTime
        DriverDataStyle.applyTitleSynthesis(label: stopTimeTitle)

        stopTimeValue.text = viewModel.stopTimeValue
        DriverDataStyle.applyTripMainValue(label: stopTimeValue, color: config.primaryColor)

        
        carbonTitle.text = viewModel.co2Emissions
        DriverDataStyle.applyTitleSynthesis(label: carbonTitle)

        carbonValue.text = viewModel.co2EmissionValue
        DriverDataStyle.applyTripMainValue(label: carbonValue, color: config.primaryColor)
        
        weatherTitle.text = viewModel.weather
        DriverDataStyle.applyTitleSynthesis(label: weatherTitle)
        
        weatherValue.text = viewModel.weatherValue
        DriverDataStyle.applyTripMainValue(label: weatherValue, color: config.primaryColor)

        carbonVolumeTitle.text = viewModel.co2Mass
        DriverDataStyle.applyTitleSynthesis(label: carbonVolumeTitle)

        carbonVolumeValue.text = viewModel.co2MassValue
        DriverDataStyle.applyTripMainValue(label: carbonVolumeValue, color: config.primaryColor)

        
        contextTitle.text = viewModel.roadContext
        DriverDataStyle.applyTitleSynthesis(label: contextTitle)

        contextValue.text = viewModel.contextValue
        DriverDataStyle.applyTripMainValue(label: contextValue, color: config.primaryColor)
        
    }
}
