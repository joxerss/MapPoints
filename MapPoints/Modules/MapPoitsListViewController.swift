//
//  MapPoitsListViewController.swift
//  MapPoints
//
//  Created by Artem on 02.01.2020.
//  Copyright © 2020 Artem. All rights reserved.
//

import UIKit

class MapPoitsListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareViews()
        self.setupAppearances()
        self.prepareNavigationBar()
        self.observeNotifications()
        self.tableView.reloadData()
    }
    
    // MARK: - Appearances
    
     func observeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(needUpdateCounteiners(_:)), name: .kMapPointsChanged, object: nil)
    }
    
    func prepareViews() {
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
    }
    
    func prepareNavigationBar() {
        navigationController?.navigationBar.largeContentTitle = "map_points.title".localized()
        
        
        let img = UIImage(systemName: "trash")
        let button = UIButton(frame: .init(origin: .zero, size: .init(width: 25, height: 30)))
        button.setImage(img?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(removeAll(_:)), for: .touchUpInside)

        let removeAllPoints  = UIBarButtonItem(customView: button)
        
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true


        let img2 = UIImage(systemName: "arrow.up.circle")
        let button2 = UIButton(frame: .init(origin: .zero, size: .init(width: 25, height: 30)))
        button2.setImage(img2?.withRenderingMode(.alwaysTemplate), for: .normal)
        button2.addTarget(self, action: #selector(restoreAll(_:)), for: .touchUpInside)
        

        let restorePoints = UIBarButtonItem(customView: button2)
        
        button2.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        navigationItem.rightBarButtonItems = [restorePoints, removeAllPoints]
    }
    
    func setupAppearances() {
        view.backgroundColor = .firebaseLogoFrontColor
    }
    
    // MARK: - Navigation Actions
    
    @objc func removeAll(_ sender: Any) {
        FirebaseDatastore.shared.removeLocations()
    }
    
    @objc func restoreAll(_ sender: Any) {
        FirebaseDatastore.shared.removeLocations()
        FirebaseDatastore.shared.restorePoints()
    }
    
    // MARK: - Notifications
    
    @objc func needUpdateCounteiners(_ notification: Notification?) {
        self.showAnimatedLoader()
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hideAnimatedLoader()
        FirebaseDatastore.shared.locationCount == 0 ? showAnimatedSearchEmpty() : hideAnimatedSearchEmpty()
        return FirebaseDatastore.shared.locationCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PointTableViewCell = tableView.dequeueReusableCell(withIdentifier: PointTableViewCell.kPointTableViewCell, for: indexPath) as! PointTableViewCell

        // Configure the cell...
        cell.name.text = FirebaseDatastore.shared.listLocations?.list?[indexPath.row].name
        cell.lat.text = FirebaseDatastore.shared.listLocations?.list?[indexPath.row].point?.lat?.stringValue
        cell.long.text = FirebaseDatastore.shared.listLocations?.list?[indexPath.row].point?.long?.stringValue
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let location = FirebaseDatastore.shared.listLocations?.list?[indexPath.row] else {
            return
        }
        MainCoordinator.shared.navigateToMapPoint(location)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
