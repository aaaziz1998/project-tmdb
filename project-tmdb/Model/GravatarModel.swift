//
//  GravatarModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 04/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation

class GravatarModel{
    
    var hash: String?
    
    init(response: NSDictionary) {
        hash = response["hash"] as? String
    }
    
}
