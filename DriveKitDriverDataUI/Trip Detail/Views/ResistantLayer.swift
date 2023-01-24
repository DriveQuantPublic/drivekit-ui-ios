// swiftlint:disable all
//
//  ResistantLayer.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 17/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import DriveKitCommonUI

class ResistantLayer: CALayer {
    
    override var zPosition: CGFloat {
        get { return super.zPosition }
        set {}
    }
    var resistantZPosition: CGFloat {
        get { return super.zPosition }
        set { super.zPosition = newValue }
    }
}

class ResistantAnnotationView: MKAnnotationView {
    
    override class var layerClass: AnyClass {
        return ResistantLayer.self
    }
    var resistantLayer: ResistantLayer {
        return self.layer as! ResistantLayer
    }
}

extension ResistantAnnotationView {
    
    func setupAsTripEventCallout(with event: TripEvent, location: String) {
        guard canShowCallout else {
            return
        }
        
        let calloutView = CalloutView.viewFromNib
        calloutView.configure(viewModel: TripEventCalloutViewModel(event: event, location: location))
        detailCalloutAccessoryView = calloutView
        
        switch event.type {
        case .adherence, .acceleration, .brake, .unlock, .lock, .pickUp, .hangUp:
            let image = DKImages.info.image
            let imageButton = UIButton(type: .custom)
            imageButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            let img = image?.resizeImage(30, opaque: false).withRenderingMode(.alwaysTemplate)
            imageButton.setImage(img, for: .normal)
            imageButton.tintColor = DKUIColors.secondaryColor.color
            rightCalloutAccessoryView = imageButton
        case .start, .end:
            rightCalloutAccessoryView = nil
        }
    }
    
}
