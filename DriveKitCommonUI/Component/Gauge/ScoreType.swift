//
//  ScoreType.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 02/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public enum ScoreType: String {
    case safety, ecoDriving, distraction, speeding
    
    public func image() -> UIImage? {
        switch self {
        case .ecoDriving:
            return DKImages.ecoDriving.image
        case .safety:
            return DKImages.safety.image
        case .distraction:
            return DKImages.distraction.image
        case .speeding:
            return DKImages.speeding.image
        }
    }
    
    public func getSteps() -> [Double] {
        switch self {
        case .ecoDriving:
            let mean : Double = 7.63
            let sigma : Double = 0.844
            let steps = [mean - (2 * sigma),
                         mean - sigma,
                         mean - (0.25 * sigma),
                         mean,
                         mean + (0.25 * sigma),
                         mean + sigma,
                         mean + (2 * sigma)]
            return steps
        case .safety:
            return [0, 5.5, 6.5, 7.5, 8.5, 9.5, 10]
        case .distraction:
            return [1 ,7 ,8 , 8.5, 9 ,9.5 , 10]
        case .speeding:
            return [1 ,3 ,5, 7, 8, 9 ,9.5 , 10]
        }
    }
    
    public func stringValue() -> String {
        switch self {
        case .ecoDriving:
            return DKCommonLocalizable.ecodriving.text()
        case .safety:
            return  DKCommonLocalizable.safety.text()
        case .distraction:
            return DKCommonLocalizable.distraction.text()
        case .speeding:
            return DKCommonLocalizable.speeding.text()
        }
    }
}
