//
//  TripDetailViewConfig.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 18/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

public class TripDetailViewConfig {
    var mapItems: [MapItem]
    var headerSummary: HeaderDay = .distanceDuration
    var displayAdvices: Bool
    var mapTrace: UIColor
    var mapTraceWarningColor: UIColor
    
    var ecoDrivingGaugeTitle: String
    var lowAccelText: String
    var weakAccelText: String
    var goodAccelText: String
    var strongAccelText: String
    var highAccelText: String
    var goodMaintainText: String
    var weakMaintainText: String
    var badMaintainText: String
    var lowDecelText: String
    var weakDecelText : String
    var goodDecelText: String
    var strongDecelText: String
    var highDecelText: String
    
    var safetyGaugeTitle : String
    var accelerationText: String
    var decelText: String
    var adherenceText: String
    
    var distractionGaugeTitle: String
    var nbUnlockText: String
    var durationUnlockText: String
    var distanceUnlockText: String
    var distanceMeterUnit: String
    var distanceKmUnit: String
    var durationSecondUnit: String
    var durationMinUnit: String
    var durationHourUnit: String
    var accelUnitText: String
    
    var endText: String
    var startText: String
    var eventAdherenceText: String
    var eventDecelText: String
    var eventAccelText: String
    var eventAdherenceCritText: String
    var eventDecelCritText: String
    var eventAccelCritText: String
    var lockText: String
    var unlockText: String
    
    var viewTitleText : String
    var noScoreText: String
    var errorRouteText: String
    var errorEventText: String
    
    /*var eventAccelExplain: String
    var eventAccelCritExplain: String
    var eventAdhExplain: String
    var eventAdhCritExplain: String
    var eventDecelExplain: String
    var eventDecelCritExplain: String*/
    
    var enableDeleteTrip: Bool
    var deleteText: String
    var tripDeleted:String
    var failedToDeleteTrip: String
    
    public init( mapItems: [MapItem] = [.safety, .ecoDriving, .distraction, .interactiveMap],
          displayAdvices: Bool = true,
          mapTrace: UIColor = .dkMapTrace,
          mapTraceWarningColor: UIColor = .dkMapTraceWarning,
          ecoDrivingGaugeTitle: String = "dk_ecodriving_gauge_title".dkLocalized(),
          lowAccelText: String = "dk_low_accel".dkLocalized(),
          weakAccelText: String = "dk_weak_accel".dkLocalized(),
          goodAccelText: String = "dk_good_accel".dkLocalized(),
          strongAccelText: String = "dk_strong_accel".dkLocalized(),
          highAccelText: String = "dk_high_accel".dkLocalized(),
          goodMaintainText: String = "dk_good_maintain".dkLocalized(),
          weakMaintainText: String = "dk_weak_maintain".dkLocalized(),
          badMaintainText: String = "dk_bad_maintain".dkLocalized(),
          lowDecelText: String = "dk_low_decel".dkLocalized(),
          weakDecelText : String = "dk_weak_decel".dkLocalized(),
          goodDecelText: String = "dk_good_decel".dkLocalized(),
          strongDecelText: String = "dk_strong_decel".dkLocalized(),
          highDecelText: String = "dk_high_decel".dkLocalized(),
          safetyGaugeTitle : String = "dk_safety_gauge_title".dkLocalized(),
          accelerationText: String = "dk_safety_accel".dkLocalized(),
          decelText: String = "dk_safety_decel".dkLocalized(),
          adherenceText: String = "dk_safety_adherence".dkLocalized(),
          distractionGaugeTitle: String = "dk_distraction_gauge_title".dkLocalized(),
          nbUnlockText: String = "dk_unlock_number".dkLocalized(),
          durationUnlockText: String = "dk_unlock_duration".dkLocalized(),
          distanceUnlockText: String = "dk_unlock_distance".dkLocalized(),
          distanceMeterUnit: String = "dk_unit_meter".dkLocalized(),
          distanceKmUnit: String = "dk_unit_km".dkLocalized(),
          durationSecondUnit: String = "dk_unit_second".dkLocalized(),
          durationMinUnit: String = "dk_unit_minute".dkLocalized(),
          durationHourUnit: String = "dk_unit_hour".dkLocalized(),
          accelUnitText: String = "dk_unit_accel".dkLocalized(),
          lockText: String = "dk_lock_event".dkLocalized(),
          unlockText: String = "dk_unlock_event".dkLocalized(),
          endText: String = "dk_end_event".dkLocalized(),
          startText: String = "dk_start_event".dkLocalized(),
          eventAdherenceText: String = "dk_safety_list_adherence".dkLocalized(),
          eventDecelText: String = "dk_safety_brake".dkLocalized(),
          eventAccelText: String = "dk_safety_acceleration".dkLocalized(),
          eventAdherenceCritText: String = "dk_safety_list_adherence_critical".dkLocalized(),
          eventDecelCritText: String = "dk_safety_list_brake_critical".dkLocalized(),
          eventAccelCritText: String = "dk_safety_list_acceleration_critical".dkLocalized(),
          viewTitleText: String = "dk_trip_detail_title".dkLocalized(),
          noScoreText: String = "dk_trip_detail_no_score".dkLocalized(),
          errorRouteText: String = "dk_trip_detail_get_road_failed".dkLocalized(),
          errorEventText: String = "dk_trip_detail_data_error".dkLocalized(),
          enableDeleteTrip: Bool = true,
          deleteText: String = "dk_confirm_delete_trip".dkLocalized(),
          tripDeleted: String = "dk_trip_deleted".dkLocalized(),
          failedToDeleteTrip: String = "dk_failed_to_delete_trip".dkLocalized()
          /*eventAccelExplain: String = "dk_safety_explain_acceleration".dkLocalized(),
          eventAccelCritExplain: String = "dk_safety_explain_acceleration_critical".dkLocalized(),
          eventAdhExplain: String = "dk_safety_explain_adherence".dkLocalized(),
          eventAdhCritExplain: String = "dk_safety_explain_adherence_critical".dkLocalized(),
          eventDecelExplain: String = "dk_safety_explain_brake".dkLocalized(),
          eventDecelCritExplain: String = "dk_safety_explain_brake_critical".dkLocalized()*/){
        
        self.mapItems = mapItems
        self.displayAdvices = displayAdvices
        self.mapTrace = mapTrace
        self.mapTraceWarningColor = mapTraceWarningColor
        self.ecoDrivingGaugeTitle = ecoDrivingGaugeTitle
        self.lowAccelText = lowAccelText
        self.weakAccelText = weakAccelText
        self.goodAccelText = goodAccelText
        self.strongAccelText = strongAccelText
        self.highAccelText = highAccelText
        self.goodMaintainText = goodMaintainText
        self.weakMaintainText = weakMaintainText
        self.badMaintainText = badMaintainText
        self.lowDecelText = lowDecelText
        self.weakDecelText = weakDecelText
        self.goodDecelText = goodDecelText
        self.strongDecelText = strongDecelText
        self.highDecelText = highDecelText
        self.safetyGaugeTitle = safetyGaugeTitle
        self.accelerationText = accelerationText
        self.decelText = decelText
        self.adherenceText = adherenceText
        self.distractionGaugeTitle = distractionGaugeTitle
        self.nbUnlockText = nbUnlockText
        self.durationUnlockText = durationUnlockText
        self.distanceUnlockText = distanceUnlockText
        self.distanceMeterUnit = distanceMeterUnit
        self.distanceKmUnit = distanceKmUnit
        self.durationSecondUnit = durationSecondUnit
        self.durationMinUnit = durationMinUnit
        self.durationHourUnit = durationHourUnit
        self.accelUnitText = accelUnitText
        self.lockText = lockText
        self.unlockText = unlockText
        self.endText = endText
        self.startText = startText
        self.eventAdherenceText = eventAdherenceText
        self.eventDecelText = eventDecelText
        self.eventAccelText = eventAccelText
        self.eventAdherenceCritText = eventAdherenceCritText
        self.eventDecelCritText = eventDecelCritText
        self.eventAccelCritText = eventAccelCritText
        self.viewTitleText = viewTitleText
        self.noScoreText = noScoreText
        self.errorEventText = errorEventText
        self.errorRouteText = errorRouteText
        self.enableDeleteTrip = enableDeleteTrip
        self.deleteText = deleteText
        self.tripDeleted = tripDeleted
        self.failedToDeleteTrip = failedToDeleteTrip
        /*self.eventAccelExplain = eventAccelExplain
        self.eventAccelCritExplain = eventAccelCritExplain
        self.eventAdhExplain = eventAdhExplain
        self.eventAdhCritExplain = eventAdhCritExplain
        self.eventDecelExplain = eventDecelExplain
        self.eventDecelCritExplain = eventDecelCritExplain*/
    }
}
