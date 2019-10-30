//
//  TripTableViewCell.swift
//  drivekit-test-app
//
//  Created by Jérémy Bayle on 20/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDriverData

final class TripTableViewCell: UITableViewCell, Nibable {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var departureHourLabel: UILabel!
    @IBOutlet weak var arrivalHourLabel: UILabel!
    @IBOutlet weak var departureCityLabel: UILabel!
    @IBOutlet weak var arrivalCityLabel: UILabel!
    @IBOutlet weak var tripLineView: TripListSeparator!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(trip: Trip, tripListViewConfig: TripListViewConfig){
        tripLineView.color = tripListViewConfig.secondaryColor
        configureLabels(trip: trip)
        configureTripData(trip: trip, tripListViewConfig: tripListViewConfig)
        configureTripInfo(trip: trip, tripListViewConfig: tripListViewConfig)
    }
    
    private func configureLabels(trip: Trip){
        DriverDataStyle.applyTripHour(label: self.departureHourLabel)
        DriverDataStyle.applyTripHour(label: self.arrivalHourLabel)
        self.departureHourLabel.text = trip.startDate?.dateToTime()
        self.arrivalHourLabel.text = trip.endDate?.dateToTime()

        DriverDataStyle.applyTripListCity(label: self.departureCityLabel)
        DriverDataStyle.applyTripListCity(label: self.arrivalCityLabel)
        self.departureCityLabel.text = trip.departureCity ?? ""
        self.arrivalCityLabel.text = trip.arrivalCity ?? ""
    }
    
    private func configureTripData(trip: Trip, tripListViewConfig: TripListViewConfig){
        switch tripListViewConfig.tripData.displayType() {
        case .gauge:
            if tripListViewConfig.tripData.isScored(trip: trip) {
                let score = CircularProgressView.viewFromNib
                let scoreType: ScoreType = ScoreType(rawValue: tripListViewConfig.tripData.rawValue) ?? .safety
                let configScore = ConfigurationCircularProgressView(scoreType: scoreType, trip: trip, size: .small)
                score.configure(configuration: configScore, scoreFont: tripListViewConfig.primaryFont)
                score.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                score.center = dataView.center
                dataView.embedSubview(score)
            } else {
                dataView.addSubview(NoScoreImageView.viewFromNib)
            }
        case .text:
            let label = UILabel()
            label.text = tripListViewConfig.tripData.stringValue(trip: trip)
            label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
            label.textColor = tripListViewConfig.secondaryColor
            label.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
            label.center = dataView.center
            dataView.embedSubview(label)
        }
    }
    
    private func configureTripInfo(trip: Trip,  tripListViewConfig: TripListViewConfig){
        if let advices = trip.tripAdvices?.allObjects as! [TripAdvice]? , advices.count > 0 {
            var tripInfo : TripInfo? = nil
            if advices.count > 1 {
                tripInfo = .count
            }else{
                let advice = advices[0]
                if advice.theme == "SAFETY" {
                    tripInfo = .safety
                }else if advice.theme == "ECODRIVING" {
                    tripInfo = .ecoDriving
                }
            }
            if let info = tripInfo{
                if info == .count {
                    let adviceCountView = AdviceCountView.viewFromNib
                    // TODO : add right image
                    adviceCountView.setAdviceCount(count: info.text(trip: trip) ?? "")
                    adviceCountView.backgroundColor = tripListViewConfig.secondaryColor
                    adviceCountView.layer.cornerRadius = 5
                    adviceCountView.layer.masksToBounds = true
                    accessoryView = adviceCountView
                } else {
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 32))
                    let imageID = info.imageID()
                    if let image =  UIImage(named: imageID ?? "", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.resizeImage(24, opaque: false).withRenderingMode(.alwaysTemplate) {
                       button.setImage(image, for: .normal)
                    } else {
                       button.setTitle(info.text(trip: trip), for: .normal)
                    }
                    button.tintColor = .white
                    button.backgroundColor = tripListViewConfig.secondaryColor
                    button.layer.cornerRadius = 5
                    button.layer.masksToBounds = true
                   
                    button.addTarget(self, action: #selector(openTips), for: .touchUpInside)
                    accessoryView = button
                }
            }
        }
    }
    
    @objc func openTips(){
        // Release in future version of Driver data UI
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataView.subviews.forEach({  $0.removeFromSuperview() })
        accessoryView = nil
    }
}
