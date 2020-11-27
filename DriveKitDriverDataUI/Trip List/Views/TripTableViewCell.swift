//
//  TripTableViewCell.swift
//  drivekit-test-app
//
//  Created by Jérémy Bayle on 20/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule
import DriveKitCommonUI

final class TripTableViewCell: UITableViewCell, Nibable {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var departureHourLabel: UILabel!
    @IBOutlet weak var arrivalHourLabel: UILabel!
    @IBOutlet weak var departureCityLabel: UILabel!
    @IBOutlet weak var arrivalCityLabel: UILabel!
    @IBOutlet weak var tripLineView: TripListSeparator!
    
    var adviceButton: AdviceButton? = nil
    var adviceCountView: AdviceCountView? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(trip: Trip){
        tripLineView.color = DKUIColors.secondaryColor.color
        configureLabels(trip: trip)
        configureTripData(trip: trip)
        configureTripInfo(trip: trip)
    }
    
    private func configureLabels(trip: Trip){
        self.departureHourLabel.attributedText = trip.startDate?.format(pattern: .hourMinute).dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        self.arrivalHourLabel.attributedText = trip.endDate?.format(pattern: .hourMinute).dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()

        self.departureCityLabel.attributedText = (trip.departureCity ?? "").dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        self.arrivalCityLabel.attributedText = (trip.arrivalCity ?? "").dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
    }
    
    private func configureTripData(trip: Trip){
        switch DriveKitDriverDataUI.shared.tripData.displayType() {
        case .gauge:
            if DriveKitDriverDataUI.shared.tripData.isScored(trip: trip) {
                let score = CircularProgressView.viewFromNib
                let scoreType: ScoreType = ScoreType(rawValue: DriveKitDriverDataUI.shared.tripData.rawValue) ?? .safety
                let configScore = ConfigurationCircularProgressView(scoreType: scoreType, value: scoreType.rawValue(trip: trip), size: .small)
                score.configure(configuration: configScore)
                score.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                score.center = dataView.center
                dataView.embedSubview(score)
            } else {
                dataView.addSubview(NoScoreImageView.viewFromNib)
            }
        case .text:
            let label = UILabel()
            label.text = DriveKitDriverDataUI.shared.tripData.stringValue(trip: trip)
            label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
            label.textColor = DKUIColors.secondaryColor.color
            label.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
            label.center = dataView.center
            dataView.embedSubview(label)
        }
    }
    
    private func configureTripInfo(trip: Trip){
        // TODO : configure a unique view for trip label
        /*if let advices = trip.tripAdvices?.allObjects as! [TripAdvice]? , advices.count > 0 {
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
                    adviceCountView = AdviceCountView.viewFromNib
                    adviceCountView?.setTrip(trip: trip)
                    adviceCountView?.setAdviceCount(count: info.text(trip: trip) ?? "")
                    adviceCountView?.backgroundColor = DKUIColors.secondaryColor.color
                    adviceCountView?.layer.cornerRadius = 5
                    adviceCountView?.layer.masksToBounds = true
                    accessoryView = adviceCountView
                } else {
                    adviceButton = AdviceButton(frame: CGRect(x: 0, y: 0, width: 44, height: 32), trip: trip)
                    let imageID = info.imageID()
                    if let image =  UIImage(named: imageID ?? "", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.resizeImage(24, opaque: false).withRenderingMode(.alwaysTemplate) {
                       adviceButton?.setImage(image, for: .normal)
                    } else {
                       adviceButton?.setTitle(info.text(trip: trip), for: .normal)
                    }
                    adviceButton?.tintColor = DKUIColors.fontColorOnSecondaryColor.color
                    adviceButton?.backgroundColor = DKUIColors.secondaryColor.color
                    adviceButton?.layer.cornerRadius = 5
                    adviceButton?.layer.masksToBounds = true
                    accessoryView = adviceButton
                }
            }
        }*/
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dataView.subviews.forEach({  $0.removeFromSuperview() })
        accessoryView = nil
        adviceCountView = nil
        adviceButton = nil
    }
}
