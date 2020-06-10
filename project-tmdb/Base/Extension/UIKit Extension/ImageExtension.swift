//
//  Extension.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 04/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    static func getImageToFollowTintColor(named: String) -> UIImage{
        return (UIImage(named: named)?.withRenderingMode(.alwaysTemplate))!
    }
    
    static func getImageToFollowTintColor(image: UIImage) -> UIImage{
        return image.withRenderingMode(.alwaysTemplate)
    }
    
    static func getImageToFollowOriginalColor(named: String) -> UIImage{
        return (UIImage(named: named)?.withRenderingMode(.alwaysOriginal))!
    }
    
    static func getImageToFollowOriginalColor(image: UIImage) -> UIImage{
        return image.withRenderingMode(.alwaysTemplate)
    }

    static let favorite = UIImage(named: "favorite")!
    static let milkyWay = UIImage(named: "milky_way")!
    static let back = UIImage(named: "back")!
    
}
