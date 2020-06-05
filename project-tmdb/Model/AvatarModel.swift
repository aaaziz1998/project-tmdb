//
//  AvatarModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 04/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation

class AvatarModel{
    
    var gravatar: GravatarModel?
    
    init(response: NSDictionary) {
        if let dictionary_gravatar = response["gravatar"] as? NSDictionary{
            gravatar = GravatarModel(response: dictionary_gravatar)
        }
    }
    
}
