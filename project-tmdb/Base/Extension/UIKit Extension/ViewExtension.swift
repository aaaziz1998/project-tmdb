//
//  ViewExtension.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 04/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func setToCurve(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func setToCurveByRadius(radius: CGFloat){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func setToRound(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }
    
    func addBorder(color: UIColor){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
    }
    
    func shapeCircularLayer(center: CGPoint, radius: CGFloat, color: UIColor) -> CAShapeLayer{
        let shapeLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi/2 , endAngle: CGFloat.pi*2, clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
//        To create progressive 0 (no indicator)
        //        shapeLayer.strokeEnd = 0
        
//        To create progressive 100% (full indicator)
        //        shapeLayer.strokeEnd = 1
        
        return shapeLayer
    }
    
}
