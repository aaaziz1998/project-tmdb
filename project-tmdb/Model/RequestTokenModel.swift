//
//  RequestTokenModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 04/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation

class RequestTokenModel{
    
    var success: Bool?
    var expired_at: String?
    var request_token: String?
    
    init(response: NSDictionary) {
        success = response["success"] as? Bool
        expired_at = response["expired_at"] as? String
        request_token = response["request_token"] as? String
    }
    
}
