//
//  GenresViewModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 10/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation
import Alamofire

protocol ProtocolGenresViewModel {
    func getListGenres() -> [GenreModel]
    func getGenreAt(index: Int) -> GenreModel
    func getGenresCount() -> Int
    func refresh()
}

class GenresViewModel{
    
    var apis = APIs()
    var userDefaults = UserDefaults.standard
    var viewController: ProtocolViewController!
    var genres = [GenreModel]()
    
    init(_ viewController: ProtocolViewController) {
        self.viewController = viewController
        refresh()
    }
    
}

extension GenresViewModel: ProtocolGenresViewModel{
    func getGenresCount() -> Int {
        return genres.count
    }
    
    func getListGenres() -> [GenreModel] {
        return genres
    }
    
    func getGenreAt(index: Int) -> GenreModel {
        return genres[index]
    }
    
    func refresh() {
        AF.request(apis.indexGenre())
            .responseJSON { (response) in
                
                let statusCode = response.response?.statusCode ?? 500
                switch statusCode{
                    
                case 200...226:
                    print("\(self.apis.indexGenre()), \(String.successWithStatusCode) \(statusCode)")
                    let value = response.value as? [String: Any]
                    if let results = value?["genres"] as? [NSDictionary]{
                        self.genres.removeAll()
                        for result in results{
                            self.genres.append(GenreModel(response: result))
                        }
                    
                        self.viewController.success(message: String.success, response: .indexGenre)
                    } else {
                        self.viewController.failed(message: String.failedGetResult, response: .indexGenre)
                    }
                
                default:
                    let value = response.value as? [String: Any]
                    self.viewController.failed(message: value?["status_message"] as? String ?? "\(String.errorStatusCode) \(statusCode)", response: .indexGenre)
                }
                
        }
    }
    
    
}
