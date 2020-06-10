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
    func getMovie() -> MovieModel?
    func refresh()
}

class DetailMovieViewModel{
    
    var apis = APIs()
    var userDefaults = UserDefaults.standard
    var viewController: ProtocolViewController?
    
    var movie_id: Int!
    var movie: MovieModel?
    
    init(_ viewController: ProtocolViewController, movie_id: Int) {
        self.viewController = viewController
        self.movie_id = movie_id
        refresh()
    }
    
    func refresh(){
        print(apis.detailMovie(movie_id: movie_id))
        AF.request(apis.detailMovie(movie_id: movie_id),
                   method: .get,
                   parameters: ["movie_id": movie_id],
//                   encoder: JSONParameterEncoder.default,
                   headers: apis.header())
            .responseJSON { (response) in
                let statusCode = response.response?.statusCode ?? 500
                switch statusCode{
                case 200...226:
                    let message = "\(self.apis.createSession()), \(String.successWithStatusCode) \(statusCode)"
                    print(message)
                    print(response.value)
                    if let value = response.value as? NSDictionary{
                        self.movie = MovieModel(response: value)
                        self.viewController?.success(message: message)
                    } else {
                        let value = response.value as? [String: Any]
                        self.viewController?.failed(message: value?["status_message"] as? String ?? "\(String.errorStatusCode) \(statusCode)")
                    }
                default:
                    if let value = response.value as? NSDictionary{
                        let message = MessageModel(response: value)
                        self.viewController?.failed(message: message.status_message ?? "Failed \(statusCode)")
                    } else {
                        self.viewController?.failed(message: "Failed \(statusCode)")
                    }
                }
        }
    }
    
}

extension DetailMovieViewModel: ProtocolDetailMovieViewModel{
    
    func getMovie() -> MovieModel? {
        return movie
    }
    
}
