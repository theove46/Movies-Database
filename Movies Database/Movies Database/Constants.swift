//
//  Constants.swift
//  Movies Database
//
//  Created by BS1098 on 23/7/23.
//

import Foundation

struct Constants {
    static let genreURL = "https://api.themoviedb.org/3/genre/movie/list?api_key=9668456c0edeb826baf3cc60c32c4878&language=en-US"
    static let posterBaseURL = "https://image.tmdb.org/t/p/w342/"
    
    static func getMovieCollectionURL(byGenre: Int) -> String{
        return "https://api.themoviedb.org/3/discover/movie?api_key=9668456c0edeb826baf3cc60c32c4878&with_genres=\(byGenre)&sort_by=vote_average.desc&vote_count.gte=1000"
    }
    
    static func getMovieCollectionByPageURL (genre: Int, page: Int) -> String {
        return "https://api.themoviedb.org/3/discover/movie?api_key=9668456c0edeb826baf3cc60c32c4878&with_genres=\(genre)&sort_by=vote_average.desc&vote_count.gte=1000&page=\(page)"
    }
}
