//
//  MovieViewModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 03/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Alamofire
import Foundation

protocol ProtocolMovieViewModel {
    func refresh()
    func countValue() -> Int
    func getAllResults() -> [MovieModel]
    func getResultOn(index: Int) -> MovieModel
    func nextPage()
    func filterResult(key: String)
}

class MovieViewModel{
    
    var api = APIs()
    var movieModels = [MovieModel]()
    var page = 1
    var max_page: Int?
    var viewController: ProtocolViewController!
    
    var filter = false
    var filteredModels = [MovieModel]()
    
    var loadingPage = true
        
    init(_ viewController: ProtocolViewController){
        self.viewController = viewController
        refresh()
    }
    
    func refresh() {
        page = 1
        loadingPage = true
        AF.request(api.indexMovies(page: page))
            .responseJSON { (response) in
                let statusCode = response.response?.statusCode ?? 500
                switch statusCode{
                    
                case 200...226:
                    print("\(self.api.indexMovies(page: self.page)), \(String.successWithStatusCode) \(statusCode)")
                    let value = response.value as? [String: Any]
                    if let results = value?["results"] as? [NSDictionary]{
                        self.movieModels.removeAll()
                        for result in results{
                            self.movieModels.append(MovieModel(response: result))
                        }
                        
                        self.page += 1
                        
                        self.loadingPage = false
                        self.viewController.success(message: String.success)
                    } else {
                        self.loadingPage = false
                        self.viewController.failed(message: String.failedGetResult)
                    }
                
                default:
                    let value = response.value as? [String: Any]
                    self.loadingPage = false
                    self.viewController.failed(message: value?["status_message"] as? String ?? "\(String.errorStatusCode) \(statusCode)")
                }
        }
    }
        
}

extension MovieViewModel: ProtocolMovieViewModel{
    
    func nextPage() {
        if !loadingPage{
            loadingPage = true
            AF.request(api.indexMovies(page: page))
                .responseJSON { (response) in
                    let statusCode = response.response?.statusCode ?? 500
                    switch statusCode{
                        
                    case 200...226:
                        let message = "\(self.api.indexMovies(page: self.page)), \(String.successWithStatusCode) \(statusCode)"
                        print(message)
                        let value = response.value as? [String: Any]
                        if let results = value?["results"] as? [NSDictionary]{
                            for result in results{
                                self.movieModels.append(MovieModel(response: result))
                            }
                            
                            self.page += 1
                            
                            self.loadingPage = false
                            self.viewController.success(message: String.success+", pagination")
                        } else {
                            self.loadingPage = false
                            self.viewController.failed(message: String.failedGetResult)
                        }
                    
                    default:
                        let value = response.value as? [String: Any]
                        self.loadingPage = false
                        self.viewController.failed(message: value?["status_message"] as? String ?? "\(String.errorStatusCode) \(statusCode)")
                    }
            }

        }
    }
    
    func countValue() -> Int {
        if filter{
            return filteredModels.count
        } else {
            print(movieModels.count)
            return movieModels.count
        }
    }
    
    func getAllResults() -> [MovieModel] {
        if filter{
            return filteredModels
        } else {
            return movieModels
        }
    }
    
    func getResultOn(index: Int) -> MovieModel {
        if filter{
            return filteredModels[index]
        } else {
            return movieModels[index]
        }
        
    }
    
    func filterResult(key: String) {
        if key.isEmpty{
            filter = false
        } else {
            filter = true
            filteredModels = self.movieModels.filter({ return $0.title?.range(of: key, options: .caseInsensitive) != nil})
        }
    }
}
