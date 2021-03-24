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

    let itinId: String
    private let mapItems: [DKMapItem]

    private var internalTrip: Trip? = nil
    var trip: Trip? {
        get {
            internalTrip = internalTrip?.attachedTrip(itinId: self.itinId)
            return internalTrip
        }
        set {
            internalTrip = newValue
            self.calls = self.trip?.sortedCalls
        }
    }
    var route: Route? = nil
    private var calls: [Call]? = nil
    private var routeSync: Bool? = nil
    private var tripSyncStatus: TripSyncStatus? = nil
    
    var events: [TripEvent] = []
    
    var configurableMapItems : [DKMapItem] = []
    var displayMapItem: DKMapItem? = nil
    
    private(set) var startEvent: TripEvent? = nil
    private(set) var endEvent: TripEvent? = nil
    private(set) var safetyEvents: [TripEvent] = []
    private(set) var distractionEvents: [TripEvent] = []
    private(set) var phoneCallEvents: [TripEvent] = []
    
    private var selection: Int? = nil
    private var selectedMapTrace: DKMapTraceType = .unlockScreen
    
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

    func getCallFromIndex(_ index: Int) -> Call? {
        if let calls = self.calls, index < 2 * calls.count {
            return calls[index / 2]
        }
        return nil
    }
    
    private func fetchTripData() {
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
                addStartAndEndEvents(trip: trip)
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
                            let screenLockedIndexValue = screenLockedIndex[i]
                            let lastIndex = route.lastIndex
                            if screenLockedIndexValue != 0 && screenLockedIndexValue != lastIndex {
                                let eventType: EventType = screenStatus[i] == 1 ? .unlock : .lock
                                events.append(TripEvent(type: eventType, date: trip.tripStartDate.addingTimeInterval(Double(screenLockedTime[i])), position: CLLocationCoordinate2D(latitude: latitude[screenLockedIndexValue], longitude: longitude[screenLockedIndexValue]), value: 0))
                            }
                        }
                    }
                    if let callIndex = route.callIndex, let callTime = route.callTime, let calls = self.calls, callIndex.count == 2 * calls.count, callTime.count == 2 * calls.count {
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
                events = events.sorted(by: { $0.date.compare($1.date) == .orderedAscending})
                safetyEvents = events.filter({
                    $0.type == .acceleration || $0.type == .adherence || $0.type == .brake
                })
                distractionEvents = events.filter({
                    $0.type == .lock || $0.type == .unlock
                })
                phoneCallEvents = events.filter({
                    $0.type == .pickUp || $0.type == .hangUp
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
        let event = TripEvent(type: type, date: trip.tripStartDate.addingTimeInterval(Double(callTime)), position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), value: Double(phoneCall.duration), isForbidden: phoneCall.isForbidden)
        self.events.append(event)
    }

    private func addStartAndEndEvents(trip: Trip) {
        if let route = self.route {
            let startEvent = TripEvent(type: .start, date: trip.tripStartDate, position: route.startLocation, value: 0)
            self.events.append(startEvent)
            self.startEvent = startEvent

            let endEvent = TripEvent(type: .end, date: trip.tripEndDate, position: route.endLocation, value: 0)
            self.events.append(endEvent)
            self.endEvent = endEvent
        }
    }

    public func setSelectedEvent(position: Int?) {
        selection = position
        if let pos = position {
            delegate?.onEventSelected(event: events[pos], position: pos)
        }
    }

    public func setSelectedMapTrace(_ mapTrace: DKMapTraceType) {
        self.selectedMapTrace = mapTrace
        self.delegate?.onMapTraceSelected(mapTrace)
    }

    public func getSelectedMapTrace() -> DKMapTraceType {
        return self.selectedMapTrace
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
    func onMapTraceSelected(_ mapTrace: DKMapTraceType)
}
