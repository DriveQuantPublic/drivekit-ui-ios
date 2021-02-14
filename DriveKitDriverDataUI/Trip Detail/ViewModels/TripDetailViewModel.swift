//
//  TripDetailViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 14/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule
import CoreLocation

class TripDetailViewModel : DKTripDetailViewModel {

    let itinId : String
    private let mapItems: [DKMapItem]
    
    var trip : Trip? = nil
    var route: Route? = nil
    private var routeSync: Bool? = nil
    private var tripSyncStatus: TripSyncStatus? = nil
    
    var events: [TripEvent] = []
    
    var configurableMapItems : [DKMapItem] = []
    var displayMapItem: DKMapItem? = nil
    
    var startEvent : TripEvent? = nil
    var endEvent : TripEvent? = nil
    var safetyEvents: [TripEvent] = []
    var distractionEvents: [TripEvent] = []
    
    private var selection: Int? = nil
    
    weak var delegate: TripDetailDelegate? = nil {
        didSet {
            if self.delegate != nil {
                self.fetchTripData()
            }
        }
    }
    
    init(itinId: String, listConfiguration: TripListConfiguration) {
        self.itinId = itinId
        switch listConfiguration {
            case .motorized:
                var items = DriveKitDriverDataUI.shared.mapItems as [DKMapItem]
                if let customItem = DriveKitDriverDataUI.shared.customMapItem {
                    items.append(customItem)
                }
                self.mapItems = items
            case .alternative:
                self.mapItems = [AlternativeTripMapItem()]
        }
        
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
            if let trip = trip?.attachedTrip(itinId: self.itinId) {
                DispatchQueue.main.async {
                    self.tripSyncStatus = status
                    self.trip = trip
                    if !trip.unscored {
                        for item in self.mapItems {
                            if item.canShowMapItem(trip: trip) {
                                self.configurableMapItems.append(item)
                            }
                        }
                    } else {
                        for item in self.mapItems {
                            if item.overrideShortTrip() {
                                self.configurableMapItems.append(item)
                            }
                        }
                    }
                    if !self.configurableMapItems.isEmpty {
                        self.displayMapItem = self.configurableMapItems[0]
                    }
                    self.computeEvents()
                }
            }
        })
    }
    
    private func computeEvents() {
        if let routeSync = self.routeSync, let tripSyncStatus = self.tripSyncStatus {
            if let trip = trip, route != nil {
                DriveKitDriverData.shared.getMissingCities(trip: trip)
            }
            if routeSync, let trip = trip, !trip.unscored {
                addStartEvent(trip: trip)
                if let safetyEvents = trip.safetyEvents, mapItems.contains(MapItem.safety) {
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
                if let route = self.route, mapItems.contains(MapItem.distraction), let latitude = route.latitude, let longitude = route.longitude {
                    if let screenLockedIndex = route.screenLockedIndex, let screenStatus = route.screenStatus, let screenLockedTime = route.screenLockedTime, screenLockedTime.count > 2 {
                        for i in 1...screenLockedIndex.count - 2 {
                            let eventType: EventType = screenStatus[i] == 1 ? .unlock : .lock
                            events.append(TripEvent(type: eventType, date: trip.tripStartDate.addingTimeInterval(Double(screenLockedTime[i])), position: CLLocationCoordinate2D(latitude: latitude[screenLockedIndex[i]], longitude: longitude[screenLockedIndex[i]]), value: 0))
                        }
                    }
                    if let callIndex = route.callIndex, let callTime = route.callTime, let calls = self.trip?.calls as? Set<Call>, callIndex.count == 2 * calls.count, callTime.count == 2 * calls.count {
                        for (index, phoneCall) in calls.enumerated() {
                            let startCallIndex = callIndex[2 * index]
                            let startCallTime = callTime[2 * index]
                            if startCallIndex != 0 && startCallIndex != route.lastIndex {
                                addCallEvent(type: .pickUp, phoneCall: phoneCall, callTime: startCallTime, trip: trip, latitude: latitude[startCallIndex], longitude: longitude[startCallIndex])
                            }
                            let endCallIndex = callIndex[2 * index + 1]
                            let endCallTime = callTime[2 * index + 1]
                            if endCallIndex != 0 && endCallIndex != route.lastIndex {
                                addCallEvent(type: .hangUp, phoneCall: phoneCall, callTime: endCallTime, trip: trip, latitude: latitude[endCallIndex], longitude: longitude[endCallIndex])
                            }
                        }
                    }
                }
                addEndEvent(trip: trip)
                events = events.sorted(by: { $0.date.compare($1.date) == .orderedAscending})
                safetyEvents = events.filter({
                    $0.type == .acceleration || $0.type == .adherence || $0.type == .brake
                })
                distractionEvents = events.filter({
                   $0.type == .lock || $0.type == .unlock || $0.type == .pickUp || $0.type == .hangUp
                })
                delegate?.onDataAvailable(tripSyncStatus: tripSyncStatus, routeSync: routeSync)
            } else {
                if let trip = trip {
                    if trip.unscored {
                        addStartAndEndEvents(trip: trip)
                        delegate?.unScoredTrip(noRoute: route == nil)
                    } else {
                        if !routeSync {
                            delegate?.noRoute()
                        } else {
                            delegate?.onDataAvailable(tripSyncStatus: tripSyncStatus, routeSync: routeSync)
                        }
                    }
                } else {
                    delegate?.noData()
                }
            }
        }
    }

    private func addCallEvent(type: EventType, phoneCall: Call, callTime: Int, trip: Trip, latitude: Double, longitude: Double) {
        let event = TripEvent(type: type, date: trip.tripStartDate.addingTimeInterval(Double(callTime)), position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), value: 0, isForbidden: phoneCall.isForbidden, callDuration: Int(phoneCall.duration))
        self.events.append(event)
    }

    private func addStartAndEndEvents(trip: Trip) {
        if self.route != nil {
            addStartEvent(trip: trip)
            addEndEvent(trip: trip)
        }
    }

    private func addStartEvent(trip: Trip) {
        if let route = self.route {
            startEvent = TripEvent(type: .start, date: trip.tripStartDate, position: route.startLocation, value: 0)
            events.append(startEvent!)
        }
    }

    private func addEndEvent(trip: Trip) {
        if let route = self.route {
            endEvent = TripEvent(type: .end, date: trip.tripEndDate, position: route.endLocation, value: 0)
            events.append(endEvent!)
        }
    }

    public func setSelectedEvent(position: Int?){
        selection = position
        if let pos = position {
            delegate?.onEventSelected(event: events[pos], position: pos)
        }
    }
    
    public func getTripEvents() -> [TripEvent] {
        return events
    }
}

protocol TripDetailDelegate : AnyObject {
    func onDataAvailable(tripSyncStatus : TripSyncStatus, routeSync: Bool)
    func noRoute()
    func noData()
    func unScoredTrip(noRoute: Bool)
    func onEventSelected(event: TripEvent, position: Int)
}
