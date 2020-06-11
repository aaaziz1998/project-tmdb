//
//  RequestTokenViewModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 04/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Alamofire
import Foundation

protocol ProtocolAuthorizationViewModel{
    func createSession()
}

class AuthorizationViewModel{
    
    private var requestTokenModel: RequestTokenModel?
    private var sessionModel: SessionModel?
    private var apis = APIs()
    private var userDefaults = UserDefaults.standard
    private var viewController: ProtocolViewController?
    
    init(_ viewController: ProtocolViewController) {
        self.viewController = viewController
        AF.request(apis.requestToken())
            .responseJSON { (response) in
                let statusCode = response.response?.statusCode ?? 500
                switch statusCode{
                case 200...226:
                    print("\(self.apis.requestToken()), \(String.successWithStatusCode) \(statusCode)")
                    if let value = response.value as? NSDictionary{
                        self.requestTokenModel = RequestTokenModel(response: value)
                        self.saveValue()
                        if let url = URL(string: self.apis.authenticateToken(token: self.userDefaults.getStringValue(identifier: .request_token) ?? "")){
                            self.userDefaults.setBoolValue(value: true, identifer: .isOpenURL)
                            UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: false]) { (success) in
                            }
                        }
                        
                    } else {
                        self.viewController?.failed(message: String.failedGetResult, response: .requestToken)
                    }
                default:
                    let value = response.value as? [String: Any]
                    self.viewController?.failed(message: value?["status_message"] as? String ?? "\(String.errorStatusCode) \(statusCode)", response: .requestToken)
                }
        }
    }
    
    private func saveValue(){
        userDefaults.setValueForKey(value: requestTokenModel?.request_token ?? "", identifer: .request_token)
    }
    
    private func saveSession(){
        userDefaults.setBoolValue(value: true, identifer: .isLogin)
        userDefaults.setValueForKey(value: sessionModel?.session_id ?? "", identifer: .session_id)
    }
    
}

extension AuthorizationViewModel: ProtocolAuthorizationViewModel{
    
    func createSession(){
        let parameter = ["request_token": self.requestTokenModel?.request_token ?? ""]
        print(parameter)
        print(apis.header())
                
        AF.request(apis.createSession(),
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: self.apis.header())
            
            
            .responseJSON { (response) in
                let statusCode = response.response?.statusCode ?? 500
                switch statusCode{
                case 200...226:
                    let message = "\(self.apis.createSession()), \(String.successWithStatusCode) \(statusCode)"
                    print(message)
                    print(response.value as Any)
                    if let value = response.value as? NSDictionary{
                        self.sessionModel = SessionModel(response: value)
                        self.saveSession()
                        self.viewController?.success(message: message, response: .createSession)
                    } else {
                        let value = response.value as? [String: Any]
                        self.viewController?.failed(message: value?["status_message"] as? String ?? "\(String.errorStatusCode) \(statusCode)", response: .createSession)
                    }
                default:
                    if let value = response.value as? NSDictionary{
                        let message = MessageModel(response: value)
                        self.viewController?.failed(message: message.status_message ?? "Failed \(statusCode)", response: .createSession)
                    } else {
                        self.viewController?.failed(message: "Failed \(statusCode)", response: .createSession)
                    }
                    
                    
                }
        }
    }

    
}

