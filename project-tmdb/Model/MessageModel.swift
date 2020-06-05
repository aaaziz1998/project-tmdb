//
//  MessageModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 05/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation

class MessageModel{
    
    var status_code: Int?
    var status_message: String?
    
    init(response: NSDictionary) {
        status_code = response["status_code"] as? Int
        status_message = response["status_message"] as? String
    }
    
}
