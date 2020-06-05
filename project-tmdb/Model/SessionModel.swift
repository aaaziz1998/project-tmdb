//
//  SessionModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 04/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation

class SessionModel{
    
    var success: Bool?
    var session_id: String?
    
    init(response: NSDictionary) {
        success = response["success"] as? Bool
        session_id = response["session_id"] as? String
    }
    
}
