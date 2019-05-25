//
//  SearchResult.swift
//  iTunesSearch
//
//  Created by Seschwan on 5/24/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    var title:   String
    var creator: String
    
    enum CodingKeys: String, CodingKey {
        case title   = "trackName"
        case creator = "artistName"
    }
}

struct SearchResults: Codable {
    let results: [SearchResult]
    
}
