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
    
}
