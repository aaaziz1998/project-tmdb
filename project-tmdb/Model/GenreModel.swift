//
//  GenreModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 10/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation

class GenreModel{
    
    var id: Int?
    var name: String?
    
    init(response: NSDictionary) {
        id = response["id"] as? Int
        name = response["name"] as? String
    }
    
}
