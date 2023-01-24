// swiftlint:disable all
//
//  TripTipFeedbackViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Meryl Barantal on 06/12/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule
import DriveKitCommonUI

class TripTipFeedbackViewModel {
    var title: String
    var content: String
    var send: String
    var cancel: String
    var choices: [String]

    var selectedChoice: Int
    var adviceID: String
    var itinId: String
    var advice: TripAdvice
    var evaluation: Int
    var comment: String = ""
    var feedBack: Int = 0

    let noChoice = -1

    init(trip: Trip, tripAdvice: TripAdvice) {
        self.title = "dk_driverdata_advice_feedback_disagree_title".dkDriverDataLocalized()
        self.content = "dk_driverdata_advice_feedback_disagree_desc".dkDriverDataLocalized()
        self.cancel = DKCommonLocalizable.cancel.text()
        self.send = DKCommonLocalizable.ok.text()
        self.choices = [
            "dk_driverdata_advice_feedback_01".dkDriverDataLocalized(),
            "dk_driverdata_advice_feedback_02".dkDriverDataLocalized(),
            "dk_driverdata_advice_feedback_03".dkDriverDataLocalized(),
            "dk_driverdata_advice_feedback_04".dkDriverDataLocalized(),
            "dk_driverdata_advice_feedback_05".dkDriverDataLocalized()
        ]
        
        selectedChoice = noChoice
        advice = tripAdvice
        adviceID = advice.id ?? ""
        itinId = trip.itinId ?? ""
        evaluation = 0
    }

    func sendFeedback(completion: @escaping (Bool) -> Void) {
        if evaluation == 1 {
            self.feedBack = 4
            self.comment = "dk_driverdata_advice_agree".dkDriverDataLocalized()
        }
        
        DriveKitDriverData.shared.sendTripAdviceFeedback(itinId: itinId, adviceId: adviceID, evaluation: evaluation, feedback: feedBack, comment: comment, completionHandler: { sucess in
            completion(sucess)
        })
    }

    func clearSelectedChoice() {
        self.selectedChoice = self.noChoice
    }
}
