//
//  MovieModel.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 03/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation

class MovieModel{
    
    var poster_path: String?
    var popularity: String?
    var vote_count: String?
    var video: String?
    var media_type: String?
    var id: Int?
    var adult: Bool?
    var backdrop_path: String?
    var original_language: String?
    var original_title: String?
    var genre_ids = [Int]()
    var title: String?
    var vote_average: Double?
    var overview: String?
    var release_date: String?
    
    init(response: NSDictionary) {
        poster_path = response["poster_path"] as? String
        popularity = response["popularity"] as? String
        vote_count = response["vote_count"] as? String
        video = response["video"] as? String
        media_type = response["media_type"] as? String
        id = response["id"] as? Int
        adult = response["adult"] as? Bool
        backdrop_path = response["backdrop_path"] as? String
        original_language = response["original_language"] as? String
        if let dictionary_genre_id = response["genre_ids"] as? [Int]{
            genre_ids = dictionary_genre_id
        }
        title = response["title"] as? String
        vote_average = response["vote_average"] as? Double
        overview = response["overview"] as? String
        release_date = response["release_date"] as? String
    }
    
}
