//
//  VehicleDetailViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccess

protocol VehicleDetailDelegate {
    func didUpdateVehicle()
    func didUpdateField()
}

class VehicleDetailViewModel {
    var fields: [VehicleGroupField] = []
    var vehicleDisplayName: String
    var vehicle: DKVehicle
    var updatedName: String = ""
    var hasError: Bool = false
    var delegate : VehicleDetailDelegate? = nil
    var vehicleImage : String = ""
    
    init(vehicle: DKVehicle, vehicleDisplayName: String) {
        self.vehicle = vehicle
        self.vehicleDisplayName = vehicleDisplayName
        self.vehicleImage = "DQ_vehicle_" + vehicle.vehicleId
        let groupFields = VehicleGroupField.allCases
        for groupField in groupFields {
            if groupField.isDisplayable(vehicle: vehicle) {
                fields.append(groupField)
            }
        }
    }
    
    func getVehicleImage() -> UIImage? {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentPath = documentsURL.path
        let filePath = documentsURL.appendingPathComponent("\(vehicleImage).jpeg")
        var image = UIImage(named: "dk_vehicle_default", in: Bundle.vehicleUIBundle, compatibleWith: nil)
               do {
                   let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                   for file in files {
                       if "\(documentPath)/\(file)" == filePath.path {
                           image = UIImage(contentsOfFile: filePath.path)
                       }
                   }
               } catch {
                   print("Could not add image from document directory: \(error)")
               }

       return image
    }
    
}
