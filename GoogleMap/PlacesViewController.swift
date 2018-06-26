//
//  TableViewController.swift
//  GoogleMap
//
//  Created by Student on 6/20/18.
//  Copyright © 2018 Student. All rights reserved.
//

import UIKit
import GooglePlaces

class PlacesViewController: UITableViewController {
    
    var likeliPlaces :[GMSPlace] = []
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return likeliPlaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let collectionItem = likeliPlaces[indexPath.row]
        cell.textLabel?.text = collectionItem.name
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            selectedPlace = likeliPlaces[indexPath.row]
            let nextVIewController = segue.destination as? MapViewController
            nextVIewController?.selectedPlace = selectedPlace
        }
       
    }
}
