//
//  DKDatePattern.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 29/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public enum DKDatePattern : String {
    case weekLetter = "EEEE d MMMM",
    standardDate = "dd/MM/yyyy",
    hourMinute = "HH:mm",
    hourMinuteLetter = "HH'h'mm",
    fullDate = "EEEE d MMMM yyyy",
    dayMonth = "dd/MM",
    yearOnly = "E",
    year = "yyyy",
    day = "EEEE",
    month = "M"
}
