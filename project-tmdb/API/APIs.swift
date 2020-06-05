//
//  API.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 03/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation
import Alamofire

class APIs{

    private let mainURLImage = "https://image.tmdb.org/t/p/w500"
    private let mainURL = "https://api.themoviedb.org"
    private let mainHomeURL = "https://www.themoviedb.org"
    private let userDefaults = UserDefaults.standard
    private let api_key = "ea402baef04c187b22620b725ad51cae"
    private let read_access_token_v4 = ""
    
    private let endpoints = APIEndpoints()
    private let parameters = APIParameters()
    
    func header() -> HTTPHeaders{
        return ["Content-Type": "application/json;charset=utf-8",
                "Accept": "application/json",
                "Authorization": userDefaults.getStringValue(identifier: .authorization) ?? ""]
    }
    
//    Create a temporary request token that can be used to validate a TMDb user login.
    func requestToken() -> String{
        return "\(mainURL)/\(endpoints.version3)/\(endpoints.authentication)/\(endpoints.token)/\(endpoints.new)?\(parameters.api_key)=\(api_key)"
    }
    
    func authenticateToken(token: String) -> String{
        return "\(mainHomeURL)/\(endpoints.authenticate)/\(token)"
    }
    
//    You can use this method to create a fully valid session ID once a user has validated the request token.
    func createSession() -> String{
        return "\(mainURL)/\(endpoints.version3)/\(endpoints.authentication)/\(endpoints.session)/\(endpoints.new)?\(parameters.api_key)=\(api_key)"
    }
    
    func detailsAccount() -> String{
        return "\(mainURL)/\(endpoints.version3)/\(endpoints.account)?\(parameters.api_key)=\(api_key)"
    }
    
    func indexMovies(page: Int?) -> String{
        return "\(mainURL)/\(endpoints.version4)/\(endpoints.list)/\(endpoints.moviesId)?\(parameters.page)=\(page ?? 1)&\(parameters.api_key)=\(api_key)"
    }
    
    func indexFavoriteMovies(session_id: String, account_id: String) -> String{
        return "\(mainURL)/\(endpoints.version3)/\(endpoints.account)/\(account_id)/\(endpoints.favorite)/\(endpoints.movies)?\(parameters.api_key)=\(api_key)&\(parameters.session_id)=\(session_id)"
    }
    
    func markAsFavorite(account_id: String, session_id: String) -> String{
        return "\(mainURL)/\(endpoints.version3)/\(endpoints.account)/\(account_id)/\(endpoints.favorite)?\(parameters.api_key)=\(api_key)&\(parameters.session_id)=\(session_id)"
    }
    
    func getImage(path: String) -> String{
        return "\(mainURLImage)\(path)"
    }
    
}

class APIEndpoints{
    let version4 = "4"
    let version3 = "3"
    let moviesId = "1"
    let list = "list"
    let auth = "auth"
    let authentication = "authentication"
    let access_token = "access_token"
    let account = "account"
    let movie = "movie"
    let movies = "movies"
    let favorites = "favorites"
    let favorite = "favorite"
    let token = "token"
    let new = "new"
    let session = "session"
    let authenticate = "authenticate"
}

class APIParameters{
    let api_key = "api_key"
    let page = "page"
    let session_id = "session_id"
}
