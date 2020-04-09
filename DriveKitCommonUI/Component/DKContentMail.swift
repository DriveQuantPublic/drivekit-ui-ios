//
//  BeaconDiagnosticMail.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 26/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public protocol DKContentMail {
    func getRecipients() -> [String]
    func getBccRecipients() -> [String]
    func getSubject() -> String
    func getMailBody() -> String
}
