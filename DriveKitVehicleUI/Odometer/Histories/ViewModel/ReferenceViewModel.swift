////
////  ReferenceViewModel.swift
////  DriveKitVehicleUI
////
////  Created by Meryl Barantal on 09/08/2019.
////  Copyright © 2019 DriveQuant. All rights reserved.
////
//
//import Foundation
//import UIKit
//import DriveKitDBVehicleAccessModule
//
//enum ReferenceCellType {
//    case distance
//    case date
//    case vehicle(DKVehicle)
//
//    var isEditable: Bool {
//        switch self {
//        case .distance, .date:
//            return true
//        case .vehicle:
//            return false
//        }
//    }
//
//    var image: UIImage? {
//        switch self {
//        case .distance :
//            return UIImage(named: "speedometer")
//        case .date:
//            return UIImage(named: "Calendar")
//        case .vehicle(let vehicle):
//            let name = "DQ_vehicle_" + vehicle.vehicleId
//            if let image = UIImage(named: name) {
//                return image
//            } else {
//                if vehicle.isTruck() {
//                    return UIImage(named: "default_truck")
//                } else {
//                    return UIImage(named: "default_car")
//                }
//            }
//        }
//    }
//
//    var placeholder: String {
//        switch self {
//        case .distance :
//            return "mileage_kilometer".keyLocalized()
//        case .date:
//            return "date".keyLocalized()
//        case .vehicle:
//            return ""
//        }
//    }
//}
//
//class ReferenceViewModel {
//    var vehicle: DKVehicle
//    var histories: [DKVehicleOdometerHistory] = []
//    var odometer: DKVehicleOdometer?
//    var index: Int = 0
//    var cellsReferences: [ReferenceCellType]
//    var selectedRef: DKVehicleOdometerHistory? = nil
//    var prevRef: DKVehicleOdometerHistory? = nil
//    var isWritable: Bool = false
//
//    var updatedRefDate: Date? = nil
//    var updatedValue: Double? = nil
//
//    init(vehicle: DKVehicle){
//        self.vehicle = vehicle
//        cellsReferences = [.distance, .date, .vehicle(vehicle)]
//        configureOdometer(vehicle: vehicle)
//    }
//
//    func configureOdometer(vehicle: DKVehicle) {
//        self.vehicle = vehicle
//        self.odometer = vehicle.odometer
//        if let history = vehicle.odometerHistories {
//            self.histories = history.sorted(by: {$0.updateDate ?? Date() > $1.updateDate ?? Date()})
//        }
//    }
//}
