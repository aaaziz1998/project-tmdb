//
//  AccountViewModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 04/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Alamofire
import Foundation

protocol ProtocolAccountViewModel {
    func getValue() -> AccountModel?
}

class AccountViewModel{
    
    private var accountModel: AccountModel?
    private var apis = APIs()
    private var userDefaults = UserDefaults.standard
    
    init(_ viewController: ProtocolViewController) {
        let session_id = userDefaults.getStringValue(identifier: .session_id)
        print(session_id as Any)
        AF.request(apis.detailsAccount(),
                   method: .get,
                   parameters: ["session_id": session_id],
                   headers: apis.header())
            .responseJSON { (response) in
                let statusCode = response.response?.statusCode ?? 500
                switch statusCode{
                case 200...226:
                    let message = "\(self.apis.detailsAccount()), \(String.successWithStatusCode) \(statusCode)"
                    print(message)
                    print(response.value as Any)
                    if let value = response.value as? NSDictionary{
                        self.accountModel = AccountModel(response: value)
                        self.saveValue()
                        viewController.success(message: message, response: .detailAccount)
                    } else {
                        viewController.failed(message: String.failedGetResult, response: .detailAccount)
                    }
                default:
                    let value = response.value as? [String: Any]
                    viewController.failed(message: value?["status_message"] as? String ?? "\(String.errorStatusCode) \(statusCode)", response: .detailAccount)
                }
        }
    }
    
    private func saveValue(){
        userDefaults.setValueForKey(value: "\(accountModel?.id ?? 0)", identifer: .account_id)
    }
    
}

extension AccountViewModel: ProtocolAccountViewModel{
    
    func getValue() -> AccountModel? {
        return accountModel
    }
    
    
}
