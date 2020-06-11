//
//  FavoriteMovieViewModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 04/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Alamofire
import Foundation

protocol ProtocolFavoriteMovieViewModel {
    func searchFavoriteStatus(movie: MovieModel) -> Bool
    func refresh()
    func countValue() -> Int
    func getAllResults() -> [MovieModel]
    func getValueFor(index: Int) -> MovieModel
    func addFavorite(movie: MovieModel)
    
    func filter(key: String)
}

class FavoriteMovieViewModel{
    
    private var api = APIs()
    private var movieModels = [MovieModel]()
    private var page = 1
    private var viewController: ProtocolViewController!
    private var userDefaults = UserDefaults.standard
    
    var filter = false
    var filteredModels = [MovieModel]()
    
    init(_ viewController: ProtocolViewController) {
        self.viewController = viewController
        refresh()
    }
    
}

extension FavoriteMovieViewModel: ProtocolFavoriteMovieViewModel{
    
    func filter(key: String) {
        if key.isEmpty{
            filter = false
        } else {
            filter = true
            filteredModels = self.movieModels.filter({ return $0.title?.range(of: key, options: .caseInsensitive) != nil})
        }
    }
    
    func getValueFor(index: Int) -> MovieModel {
        if filter{
            return filteredModels[index]
        }
        return movieModels[index]
    }
    
    func addFavorite(movie: MovieModel) {
        
        var parameter = AddFavoriteParameter(media_type: "movie", media_id: "\(movie.id ?? 0)", favorite: nil)
        
        if searchFavoriteStatus(movie: movie){
            parameter.favorite = false
        } else {
            parameter.favorite = true
        }
        
        let apiURLString = api.markAsFavorite(account_id: userDefaults.getStringValue(identifier: .account_id) ?? "",
                                               session_id: userDefaults.getStringValue(identifier: .session_id) ?? "")
        AF.request(apiURLString,
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: api.header())
            .responseJSON { (response) in
                let statusCode = response.response?.statusCode ?? 500
                switch statusCode{
                case 200...226:
                    let messageStatusCode = "\(apiURLString), \(String.successWithStatusCode) \(statusCode), addFavorite"
                    print(response.value as Any)
                    
                    if let value = response.value as? NSDictionary{
                        let message = MessageModel(response: value)
                        self.refresh()
                        self.viewController?.success(message: message.status_message ?? messageStatusCode, response: .markAsFavorite)
                    } else {
                        self.viewController?.failed(message: "\(String.failedGetResult)", response: .markAsFavorite)
                    }
                default:
                    if let value = response.value as? NSDictionary{
                        let messageModel = MessageModel(response: value)
                        self.viewController?.failed(message: messageModel.status_message ?? "", response: .markAsFavorite)
                    } else {
                        self.viewController?.failed(message: "\(String.errorStatusCode) \(statusCode)", response: .markAsFavorite)
                    }
                }
        }
    }
    
    func searchFavoriteStatus(movie: MovieModel) -> Bool {
        guard let movie_title = movie.title else {return false}
        let filteredModels = self.movieModels.filter({ return $0.title?.range(of: movie_title, options: .caseInsensitive) != nil})
        if filteredModels.count > 0{
            return true
        } else {
            return false
        }
    }
    
    func refresh() {
        AF.request(api.indexFavoriteMovies(session_id: userDefaults.getStringValue(identifier: .session_id) ?? "", account_id: userDefaults.getStringValue(identifier: .account_id) ?? ""))
            .responseJSON { (response) in
                let statusCode = response.response?.statusCode ?? 500
                switch statusCode{
                    
                case 200...226:
                    let message = "\(self.api.indexFavoriteMovies(session_id: self.userDefaults.getStringValue(identifier: .session_id) ?? "", account_id: self.userDefaults.getStringValue(identifier: .account_id) ?? "")), \(String.successWithStatusCode) \(statusCode)"
                    print(message)
                    let value = response.value as? [String: Any]
                    
                    if let results = value?["results"] as? [NSDictionary]{
                        self.movieModels.removeAll()
                        for result in results{
                            self.movieModels.append(MovieModel(response: result))
                        }
                        
                        self.page += 1
                        
                        self.viewController.success(message: message, response: .indexFavoriteMovies)
                    } else {
                        self.viewController.failed(message: String.failedGetResult, response: .indexFavoriteMovies)
                    }
                
                default:
                    let value = response.value as? [String: Any]
                    self.viewController.failed(message: value?["status_message"] as? String ?? "\(String.errorStatusCode) \(statusCode)", response: .indexFavoriteMovies)
                }
        }
    }
    
    func countValue() -> Int {
        if filter{
            return filteredModels.count
        }
        return movieModels.count
    }
    
    func getAllResults() -> [MovieModel] {
        if filter{
            return filteredModels
        }
        return movieModels
    }
    
}

struct AddFavoriteParameter: Encodable {
    var media_type: String?
    var media_id: String?
    var favorite: Bool?
    
    init(media_type: String?, media_id: String?, favorite: Bool?) {
        self.media_type = media_type ?? ""
        self.media_id = media_id ?? ""
        self.favorite = favorite ?? false
    }
}
