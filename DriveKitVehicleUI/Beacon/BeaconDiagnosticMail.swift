//
//  BeaconDiagnosticMail.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 26/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public protocol DKBeaconDiagnosticMail {
    func getRecipients() -> [String]
    func getBccRecipients() -> [String]
    func getSubject() -> String
    func getMailBody() -> String
}
