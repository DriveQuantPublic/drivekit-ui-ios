//
//  TripTipFeedbackViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Meryl Barantal on 06/12/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverData

class TripTipFeedbackViewModel {
    var detailConfig: TripDetailViewConfig
    var config: TripListViewConfig
    var title : String
    var content : String
    var send : String
    var cancel : String
    var choices: [String]
    
    var selectedChoice: Int
    var adviceID: String
    var itinId: String
    var advice: TripAdvice
    var evaluation : Int
    var comment: String = ""
    var feedBack: Int = 0
    
    init(trip: Trip, tripAdvice: TripAdvice, detailConfig: TripDetailViewConfig, config: TripListViewConfig){
        self.detailConfig = detailConfig
        self.config = config
        self.title = detailConfig.adviceDisagreeTitleText
        self.content = detailConfig.adviceDisagreeDescText
        self.cancel = config.cancelText
        self.send = config.okText
        self.choices = [
            detailConfig.adviceFeedbackChoice01Text,
            detailConfig.adviceFeedbackChoice02Text,
            detailConfig.adviceFeedbackChoice03Text,
            detailConfig.adviceFeedbackChoice04Text,
            detailConfig.adviceFeedbackChoice05Text
        ]
        
        selectedChoice = 0
        advice = tripAdvice
        adviceID = advice.id ?? ""
        itinId = trip.itinId ?? ""
        evaluation = 0
    }

    func sendFeedback(completion: @escaping (Bool) -> ()) {
        if evaluation == 1 {
            self.feedBack = 4
            self.comment = detailConfig.adviceAgreeText
        }
        
        DriveKitDriverData.shared.sendTripAdviceFeedback(itinId: itinId, adviceId: adviceID, evaluation: evaluation, feedback: feedBack, comment: comment, completionHandler : { sucess in
            completion(sucess)
        })
    }
}
