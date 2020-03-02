//
//  DistractionPageVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class DistractionPageVC: UIViewController {
    
    
    @IBOutlet var circularRingContainer: UIView!
    @IBOutlet var circularRingTitle: UILabel!
    @IBOutlet var eventContainer: UIStackView!
    
    var viewModel: DistractionPageViewModel
    
    init(viewModel: DistractionPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DistractionPageVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configure()
    }
    
    func configure() {
        let score = CircularProgressView.viewFromNib
        let configScore = ConfigurationCircularProgressView(scoreType: viewModel.scoreType, value: viewModel.scoreType.rawValue(trip: viewModel.trip), size: .large)
        score.configure(configuration: configScore)
        score.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        score.center = circularRingContainer.center
        circularRingContainer.embedSubview(score)
        DriverDataStyle.applyCircularRingTitle(label: circularRingTitle)
        circularRingTitle.text = self.viewModel.scoreType.stringValue()
        setupEventContainer()
    }
    
    func setupEventContainer() {
        eventContainer.removeAllSubviews()
        let nbUnlockView = DistractionPageView.viewFromNib
        nbUnlockView.configure(title: "dk_unlock_number".dkDriverDataLocalized(), count: self.getNumberUnlocks())
        eventContainer.addArrangedSubview(nbUnlockView)
        
        let unlockDurationView = DistractionPageView.viewFromNib
        unlockDurationView.configure(title: "dk_unlock_duration".dkDriverDataLocalized(), count: self.getScreenUnlockDuration())
        eventContainer.addArrangedSubview(unlockDurationView)
        
        let unlockDistanceView = DistractionPageView.viewFromNib
        unlockDistanceView.configure(title: "dk_unlock_distance".dkDriverDataLocalized(), count: self.getScreenUnlockDistance())
        eventContainer.addArrangedSubview(unlockDistanceView)
        
    }
    
    func getNumberUnlocks() -> NSAttributedString {
        let number = Int(viewModel.trip.driverDistraction?.nbUnlock ?? 0)
        return self.valueAttributedText(value: String(number))
    }
    
    func getScreenUnlockDuration() -> NSAttributedString {
        var firstValue = "0"
        var secondValue = ""
        var unit = DKCommonLocalizable.unitSecond.text()
        if let driverdistraction = viewModel.trip.driverDistraction {
            if driverdistraction.durationUnlock >= 3600 {
                firstValue = "\(Int(floor(driverdistraction.durationUnlock/3600)))"
                let leftSecond = Int(driverdistraction.durationUnlock) % 3600
                secondValue = " \(Int(leftSecond / 60))"
                unit = DKCommonLocalizable.unitHour.text()
            }else if driverdistraction.durationUnlock >= 60{
                firstValue = "\(Int(floor(driverdistraction.durationUnlock/60)))"
                secondValue = " \(Int(driverdistraction.durationUnlock) % 60)"
                unit = DKCommonLocalizable.unitMinute.text()
            }else{
                firstValue = "\(Int(driverdistraction.durationUnlock)) "
                unit = DKCommonLocalizable.unitSecond.text()
            }
        }
        let attributedString = NSMutableAttributedString()
        attributedString.append(self.valueAttributedText(value: firstValue))
        attributedString.append(self.unitAttributedText(value: unit))
        attributedString.append(self.valueAttributedText(value: secondValue))
        
        return attributedString
    }
    
    func getScreenUnlockDistance() -> NSAttributedString {
        let distance = Double(self.viewModel.trip.driverDistraction?.distanceUnlock ?? 0)
         var text = "0"
        var unit = DKCommonLocalizable.unitMeter.text()
        if distance > 1000{
            text = String(format: "%.1f ", distance / 1000)
            unit = DKCommonLocalizable.unitKilometer.text()
        } else {
            text = "\(Int(distance)) "
        }
        let attributedString = NSMutableAttributedString()
        attributedString.append(self.valueAttributedText(value: text))
        attributedString.append(self.unitAttributedText(value: unit))
        return attributedString
    }
    
    private func valueAttributedText(value: String) -> NSAttributedString {
        return NSAttributedString(string: value, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22, weight: .bold), NSAttributedString.Key.foregroundColor : DKUIColors.primaryColor.color])
    }
    
    private func unitAttributedText(value: String) -> NSAttributedString {
        return NSAttributedString(string: value, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : DKUIColors.mainFontColor.color])
    }
    
}
