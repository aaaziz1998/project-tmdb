//
//  UserDefaults.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 03/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation

extension UserDefaults{
    
    enum BoolIdentifier: String{
        case isLogin
        case isOpenURL
    }
    
    enum UserDefaultIdentifier: String {
        case api_key
        case access_token
        case account_id
        case session_id
        case request_token
        case authorization
    }
    
    func setBoolValue(value: Bool, identifer: BoolIdentifier){
        set(value, forKey: identifer.rawValue)
    }
    
    func setValueForKey(value: Any, identifer: UserDefaultIdentifier){
        setValue(value, forKey: identifer.rawValue)
    }
    
    func getBoolValue(identifier: BoolIdentifier) -> Bool{
        return bool(forKey: identifier.rawValue)
    }
    
    func getStringValue(identifier: UserDefaultIdentifier) -> String?{
        return object(forKey: identifier.rawValue) as? String
    }
    
    func getIntegerValue(identifier: UserDefaultIdentifier) -> Int?{
        return object(forKey: identifier.rawValue) as? Int
    }
    
    func getAnyValue(identifer: UserDefaultIdentifier) -> Any{
        return object(forKey: identifer.rawValue) as Any
    }
    
}
