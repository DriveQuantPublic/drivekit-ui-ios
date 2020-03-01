//
//  UIView+DriveKit.swift
//  drivekit-test-app
//
//  Created by Jérémy Bayle on 20/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

extension UIView {
    
    func embedSubview(_ subview: UIView, margins: UIEdgeInsets = UIEdgeInsets.zero) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        let metrics = [
            "topMargin" : margins.top,
            "bottomMargin" : margins.bottom,
            "leftMargin" : margins.left,
            "rightMargin" : margins.right,
            ]
        let bindings = ["subview": subview]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(topMargin)-[subview]-(bottomMargin@999)-|",
                                                      options: [],
                                                      metrics: metrics,
                                                      views: bindings))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(leftMargin)-[subview]-(rightMargin)-|",
                                                      options: [],
                                                      metrics: metrics,
                                                      views: bindings))
    }
}

extension UIColor {
    
    static let dkGaugeGray = UIColor(hex: 0xE0E0E0)
    
    static let dkVeryBad = UIColor(hex: 0xff6e57)
    static let dkBad = UIColor(hex: 0xffa057)
    static let dkBadMean = UIColor(hex: 0xffd357)
    static let dkMean = UIColor(hex: 0xf9ff57)
    static let dkGoodMean = UIColor(hex: 0xc6ff57)
    static let dkGood = UIColor(hex: 0x94ff57)
    static let dkExcellent = UIColor(hex: 0x30c8fc)
    
    public static let dkMapTrace = UIColor(hex: 0x116ea9)
    public static let dkMapTraceWarning = UIColor(hex: 0xed4f3b)
    
    /*static let dkHighEvent = UIColor(hex: 0xf2a365)
    static let dkCriticalEvent = UIColor(hex: 0xef775f)*/
}

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}

extension UIStackView {
    func removeAllSubviews() {
        let subviews = self.arrangedSubviews
        if subviews.count > 0 {
            for view in subviews {
                self.removeArrangedSubview(view)
            }
        }
    }
}
