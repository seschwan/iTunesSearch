//
//  SearchResultsViewController.swift
//  iTunesSearch
//
//  Created by Seschwan on 5/24/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    // Constants
    let searchResultsController = SearchResultController()
    
    // Outlets
    @IBOutlet weak var segmentBar: UISegmentedControl!
    @IBOutlet weak var searchBar:  UISearchBar!
    @IBOutlet weak var tableView:  UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        searchBar.delegate   = self
    }
    

    
}

extension SearchResultsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Getting the text in the searchBar
        guard let searchBarText = searchBar.text else { return }
        
        // Using our enum ResultType
        var resultType: ResultType!
        
        // Switching on our segment bar value
        switch segmentBar.selectedSegmentIndex {
        case 0:
            resultType = .software
        case 1:
            resultType = .musicTrack
        case 2:
            resultType = .movie
        default:
            resultType = .software
        }
        
        searchResultsController.performSearch(searchTerm: searchBarText, resultType: resultType) { (error) in
            if let error = error {
                NSLog("Error performing search: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsController.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) // as! customTableViewCell
        
        // Getting the value of an element in the tableView row
        let result = searchResultsController.searchResults[indexPath.row]
        
        // Setting the values of the cell
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.creator
        
        return cell
    }
    
    
    
    
}
