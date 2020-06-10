//
//  DetailMovieViewModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 10/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation
import Alamofire

protocol ProtocolDetailMovieViewModel {
    func refresh()
}

class DetailMovieViewModel{
    
    var apis = APIs()
    var userDefaults = UserDefaults.standard
    var viewController: ProtocolViewController?
    
    init(_ viewController: ProtocolViewController) {
        self.viewController = viewController
    }
    
    func refresh(){
//        AF.request(apis.detailsAccount(),
//                   method: .get,
//                   parameters: ["session_id": session_id],
//                   headers: apis.header())

//        AF.request(<#T##convertible: URLConvertible##URLConvertible#>, method: .get, parameters: <#T##Encodable?#>, encoder: <#T##ParameterEncoder#>, headers: apis.header(), interceptor: <#T##RequestInterceptor?#>, requestModifier: <#T##Session.RequestModifier?##Session.RequestModifier?##(inout URLRequest) throws -> Void#>)
    }
    
}

extension DetailMovieViewModel: ProtocolDetailMovieViewModel{
    
}
