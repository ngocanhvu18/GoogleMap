//
//  AutoCompleteController.swift
//  GoogleMap
//
//  Created by Student on 6/21/18.
//  Copyright © 2018 Student. All rights reserved.
//

import UIKit
import GooglePlaces
protocol AutoCompleteControllerDelegate :class {
    func passingData(place: GMSPlace)
}
class AutoCompleteController: UIViewController {
    
    var resultViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    @IBOutlet weak var resultView: UITextView!
    weak var delegate: AutoCompleteControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultViewController = GMSAutocompleteResultsViewController()
        resultViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultViewController!)
        searchController?.searchResultsUpdater = resultViewController

        searchController?.searchBar.frame = CGRect(x: 0, y: 0, width: 250.0, height: 44.0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchController!.searchBar)
        definesPresentationContext = true
        
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.modalPresentationStyle = .popover
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AutoCompleteController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        
        delegate?.passingData(place: place)
        navigationController?.popViewController(animated: true)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
