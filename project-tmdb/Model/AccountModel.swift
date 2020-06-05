//
//  AccountModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 04/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation

class AccountModel{
    
    var avatar: AvatarModel?
    var id: Int?
    var iso_639_1: String?
    var iso_3166_1: String?
    var name: String?
    var include_adult: String?
    var username: String?
    
    init(response: NSDictionary) {
        if let dictionary_avatar = response["avatar"] as? NSDictionary{
            avatar = AvatarModel(response: dictionary_avatar)
        }
        id = response["id"] as? Int
        iso_639_1 = response["iso_639_1"] as? String
        iso_3166_1 = response["iso_3166_1"] as? String
        name = response["name"] as? String
        include_adult = response["include_adult"] as? String
        username = response["username"] as? String
    }
    
}
