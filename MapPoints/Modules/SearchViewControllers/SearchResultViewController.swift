//
//  SearchResultViewController.swift
//  MapPoints
//
//  Created by Artem Syritsa on 08.05.2020.
//  Copyright © 2020 Artem. All rights reserved.
//

import UIKit

class SearchResultViewController: UITableViewController {
    
    var filteredResults: [Location]?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        prepareViews()
        setupAppearances()
    }
    
    func prepareViews() {
        self.extendedLayoutIncludesOpaqueBars = true
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.searchResultCell)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setupAppearances() {
        self.view.backgroundColor = UIColor.red
    }
    
    // MARK: - UITableViewDataSourse
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.filteredResults?.count ?? 0
        
        count == 0 ? showAnimatedSearchEmpty() : hideAnimatedSearchEmpty()
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.searchResultCell, for: indexPath)
        
        let location = self.filteredResults![indexPath.row]
        
        cell.textLabel?.text = location.name
        
        return cell
    }
}

extension SearchResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text,
            searchString.count > 0 else {
            return;
        }
        print("👩🏼‍💻 Search substring \(searchString)")
        
        let location = FirebaseDatastore.shared.listLocations?.list
        let filteredResults = location?.filter({ ($0.name?.localized().range(of: searchString, options: .caseInsensitive) != nil) })
        self.filteredResults = filteredResults
        
        self.tableView.reloadData()
    }
}
