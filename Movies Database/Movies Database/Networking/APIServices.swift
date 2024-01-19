//
//  APIServices.swift
//  Movies Database
//
//  Created by BS1098 on 23/7/23.
//

import Foundation

class APIService {
    //singleton object
    static let API = APIService()
    
    //genre list api
    public func getGenreList(completionHandler: @escaping (GenreResponse)-> Void){
        let task = URLSession.shared.dataTask(with: URL(string: Constants.genreURL)!, completionHandler: {
            (data, response, error) in
            
            var result: GenreResponse?
            do {
                result = try JSONDecoder().decode(GenreResponse.self, from: data!)
                guard let json = result else {
                    return
                }
                completionHandler(json)
                
            } catch {
                print(error)
            }
            
        })
        
        task.resume()
    }
    
    //movie collection api
    public func getMoviesByGenre(_ id: Int, completionHandler: @escaping (MovieCollectionResponse)->Void){
        let task = URLSession.shared.dataTask(with: URL(string: Constants.getMovieCollectionURL(byGenre: id ))!, completionHandler: {
            (data, response, error) in
            
            var result: MovieCollectionResponse?
            do {
                result = try JSONDecoder().decode(MovieCollectionResponse.self, from: data!)
                guard let json = result else {
                    return
                }
                
                completionHandler(json)
            } catch {
                print(error)
            }
            
        })
        
        task.resume()
    }
    
    
    //fetch movie collection with page api
    public func getMoviesByPage(_ id: Int, _ page: Int, completionHandler: @escaping (MovieCollectionResponse)->Void){
        let task = URLSession.shared.dataTask(with: URL(string: Constants.getMovieCollectionByPageURL(genre: id, page: page))!, completionHandler: {
            (data, response, error) in
            
            var result: MovieCollectionResponse?
            guard let data = data else { return }
            do {
                result = try JSONDecoder().decode(MovieCollectionResponse.self, from: data)
                guard let json = result else {
                    return
                }
                
                completionHandler(json)
            } catch {
                print(error)
            }
            
        })
        task.resume()
    }
    
}

