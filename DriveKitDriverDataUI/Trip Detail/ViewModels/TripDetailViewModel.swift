//
//  TripDetailViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 14/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDriverData
import CoreLocation

class TripDetailViewModel {

    let itinId : String
    private let mapItems: [MapItem]
    
    var trip : Trip? = nil
    var route: Route? = nil
    private var routeSync: Bool? = nil
    private var tripSyncStatus: TripSyncStatus? = nil
    
    var events: [TripEvent] = []
    
    var configurableMapItems : [MapItem] = []
    var displayMapItem: MapItem? = nil
    
    var startEvent : TripEvent? = nil
    var endEvent : TripEvent? = nil
    var safetyEvents: [TripEvent] = []
    var distractionEvents: [TripEvent] = []
    
    private var selection: Int? = nil
    
    var delegate: TripDetailDelegate? = nil {
        didSet {
            if self.delegate != nil {
                self.fetchTripData()
            }
        }
    }
    
    init(itinId: String, mapItems: [MapItem]) {
        self.itinId = itinId
        self.mapItems = mapItems
    }
    
    private func fetchTripData(){
        DriveKitDriverData.shared.getRoute(itinId: itinId, completionHandler: { route in
            if let route = route {
                self.route = route
                self.routeSync = true
            }else{
                self.routeSync = false
            }
            self.computeEvents()
        })
        DriveKitDriverData.shared.getTrip(itinId: itinId, completionHandler: {status, trip in
            if let trip = trip {
                self.tripSyncStatus = status
                self.trip = trip
                if !trip.unscored {
                    for item in self.mapItems {
                        switch item {
                        case .safety:
                            if let safety = trip.safety{
                                if safety.safetyScore <= 10 {
                                    self.configurableMapItems.append(item)
                                }
                            }
                        case .ecoDriving:
                            if let ecoDriving = trip.ecoDriving{
                                if ecoDriving.score <= 10 {
                                    self.configurableMapItems.append(item)
                                }
                            }
                        case .distraction:
                            if let distraction = trip.driverDistraction{
                                if distraction.score <= 10 {
                                    self.configurableMapItems.append(item)
                                }
                            }
                        case .interactiveMap:
                            self.configurableMapItems.append(item)
                        }
                    }
                    self.displayMapItem = self.configurableMapItems[0]
                }
                self.computeEvents()
           }
       })
    }
    
    private func computeEvents(){
        if let routeSync = self.routeSync, let tripSyncStatus = self.tripSyncStatus {
            if let trip = trip, route != nil {
                DriveKitDriverData.shared.getMissingCities(trip: trip)
            }
            if routeSync, let trip = trip, !trip.unscored {
                addStartAndEndEvents(trip: trip)
                if let safetyEvents = trip.safetyEvents, mapItems.contains(.safety) {
                    for safetyEvent in safetyEvents {
                        let event = safetyEvent as! SafetyEvents
                        switch event.type {
                        case 1:
                            events.append(TripEvent(type: .adherence, date: trip.tripStartDate.addingTimeInterval(event.time), position: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude), value: event.value, isHigh: event.value > 0.3))
                        case 2:
                            events.append(TripEvent(type: .acceleration, date: trip.tripStartDate.addingTimeInterval(event.time), position: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude), value: event.value, isHigh: event.value > 2.5))
                        case 3:
                            events.append(TripEvent(type: .brake, date: trip.tripStartDate.addingTimeInterval(event.time), position: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude), value: event.value, isHigh: event.value < -2.4))
                        default:
                            // Invalid event type
                             break
                        }
                    }
                }
                if let route = self.route, let screenLockedIndex = route.screenLockedIndex, let screenStatus = route.screenStatus, let screenLockedTime = route.screenLockedTime, screenLockedTime.count > 2, mapItems.contains(.distraction){
                    for i in 1...screenLockedIndex.count - 2{
                        var eventType : EventType = .lock
                        if screenStatus[i] == 1 {
                            eventType = .unlock
                        }
                        events.append(TripEvent(type: eventType, date: trip.tripStartDate.addingTimeInterval(Double(screenLockedTime[i])), position: CLLocationCoordinate2D(latitude: route.latitude![screenLockedIndex[i]], longitude: route.longitude![screenLockedIndex[i]]), value: 0))
                    }
                }
                events = events.sorted(by: { $0.date.compare($1.date) == .orderedAscending})
                safetyEvents = events.filter({
                    $0.type == .acceleration || $0.type == .adherence || $0.type == .brake
                })
                distractionEvents = events.filter({
                   $0.type == .lock || $0.type == .unlock
                })
                delegate?.onDataAvailable(tripSyncStatus: tripSyncStatus, routeSync: routeSync)
            }else{
                if let trip = trip {
                    if trip.unscored {
                        addStartAndEndEvents(trip: trip)
                        delegate?.unScoredTrip(noRoute: route == nil)
                    }else{
                        if !routeSync {
                            delegate?.noRoute()
                        }else{
                            delegate?.onDataAvailable(tripSyncStatus: tripSyncStatus, routeSync: routeSync)
                        }
                    }
                }else{
                    delegate?.noData()
                }
            }
        }
    }
    
    private func addStartAndEndEvents(trip: Trip){
        if let route = self.route {
            startEvent = TripEvent(type: .start, date: trip.tripStartDate, position: route.startLocation, value: 0)
            events.append(startEvent!)
            endEvent = TripEvent(type: .end, date: trip.tripEndDate, position: route.endLocation, value: 0)
            events.append(endEvent!)
        }
    }

    func setSelectedEvent(position: Int?){
        selection = position
        if let pos = position {
            delegate?.onEventSelected(event: events[pos], position: pos)
        }
    }
}

protocol TripDetailDelegate {
    func onDataAvailable(tripSyncStatus : TripSyncStatus, routeSync: Bool)
    func noRoute()
    func noData()
    func unScoredTrip(noRoute: Bool)
    func onEventSelected(event: TripEvent, position: Int)
}
