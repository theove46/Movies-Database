//
//  MovieCollectionResponse.swift
//  Movies Database
//
//  Created by BS1098 on 23/7/23.
//

import Foundation

struct MovieCollectionResponse: Codable {
    var page: Int
    var results: [Movie]
    let total_pages: Int
    let total_results: Int
}
