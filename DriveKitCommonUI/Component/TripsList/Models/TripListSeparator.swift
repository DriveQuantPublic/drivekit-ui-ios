//
//  TripListSeparator.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 10/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

class TripListSeparator: UIView {
    
    var color: UIColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        
        let radius = rect.size.width / 3
        
        // First Fill circle
        let centerOfFirstCircle = CGPoint(x: bounds.size.width / 2, y: radius)
        addFillCircle(color: color, center: centerOfFirstCircle, radius: radius)
        
        // Add a dashed line
        let originPoint = CGPoint(x: centerOfFirstCircle.x, y: radius * 2)
        let destinationPoint = CGPoint(x: centerOfFirstCircle.x, y: rect.size.height - radius * 2)
        addDashedLine(originPoint: originPoint, destinationPoint: destinationPoint, color: color )
        
        // Second Fill circle
        addFillCircle(color: color, center: CGPoint(x: bounds.size.width / 2, y: rect.size.height - radius), radius: radius)
    }
}

fileprivate extension UIView {
    func addFillCircle(color: UIColor, center: CGPoint, radius: CGFloat) {
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = color.cgColor
        shapeLayer.strokeColor = color.cgColor
        layer.addSublayer(shapeLayer)
    }
    
    func addDashedLine(originPoint: CGPoint, destinationPoint: CGPoint, color: UIColor) {
        let cgColor = color.cgColor
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = bounds
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [1, 1]
        let path: CGMutablePath = CGMutablePath()
        path.move(to: originPoint)
        path.addLine(to: destinationPoint)
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
