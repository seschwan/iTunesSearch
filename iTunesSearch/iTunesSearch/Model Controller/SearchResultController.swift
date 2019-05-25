//
//  SearchResultController.swift
//  iTunesSearch
//
//  Created by Seschwan on 5/24/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation

class SearchResultController {
    
    // Setting the raw values
    enum HTTPMethod: String {
        case get    = "GET"
        case put    = "PUT"
        case post   = "POST"
        case delete = "DELETE"
        
    }
    // Setting the BaseURL to build on top of
    let baseURL = URL(string: "https://itunes.apple.com/search")!
    
    // This will be the TableView's data source
    var searchResults: [SearchResult] = []
    
    // @Escaping allows the completion to exit the scope of the function?
    func performSearch(searchTerm: String, resultType: ResultType, completion: @escaping (Error?) -> Void) {
        
        // Create some urlComponets from the baseURL
        var urlComponets = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        // Creat the query items to add to the baseURL
        let searchTermQueryItem = URLQueryItem(name: "term", value: searchTerm)
        
        // Build the url based on the urlComponets and then add it to an array?
        urlComponets?.queryItems = [searchTermQueryItem]
        
        // Getting the newly built URL and checking to make sure it isn't nil.
        guard let requestURL = urlComponets?.url else { NSLog("Request is nil"); completion(NSError()); return }
        
        // Makes a request with the newly built URL
        var request = URLRequest(url: requestURL)
        
        // Setting the request type "GET"
        request.httpMethod = HTTPMethod.get.rawValue
        
        // Creating a session to try and get the data, reponse, and the error if any
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            // Checking to see if there is data
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(error)
                return
            }
            // Create a JSONDecoder Instance
            let jsonDecoder = JSONDecoder()
            
            do { // Decoding the results
                let results = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults = results.results
                completion(nil)
            } catch {
                NSLog("Error decoding search results: \(error)")
                completion(error)
            }
            
        }.resume()
    }
    
    
}
