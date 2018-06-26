//
//  DeveloperGuideViewController.swift
//  GoogleMap
//
//  Created by Student on 6/22/18.
//  Copyright © 2018 Student. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

typealias DICT = Dictionary<AnyHashable, Any>

class DeveloperGuideViewController: UIViewController, AutoCompleteControllerDelegate {
    
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var sourceButton: UIButton!
    @IBOutlet weak var destinationButton: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    var checkIdentifer: Bool = true
    var source: GMSPlace?
    var destination: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func locationData(){
        getPolylineRoute(from: source!.coordinate, to: destination!.coordinate)
    }
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
         let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        
        let task = URLSession.shared.dataTask(with: url,completionHandler: { (data, reponse, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let objectData = data else {return}
            do{
                guard let reuslts = try JSONSerialization.jsonObject(with: objectData, options: .mutableContainers) as? DICT else {return}
                guard let routes = reuslts["routes"] as? [DICT] else{ return}
                guard let overview_polyline = routes[0]["overview_polyline"] as? DICT else {return}
                guard let points = overview_polyline["points"] as? String else {return}
                DispatchQueue.main.async {
                    self.showPath(polyStr: points)
                }
            }
            catch{
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    func showPath(polyStr :String){
        
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = UIColor.black
        polyline.map = mapView // Your map view
    }

    
    func passingData(place: GMSPlace) {
        if checkIdentifer == true {
            source = place
            sourceTextField.text = "\(place.formattedAddress ?? "")"
            
        } else {
            destination = place
            destinationTextField.text = "\(place.formattedAddress ?? "")"
            
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15)
        
        mapView.camera = camera

        if source != nil && destination != nil {
            locationData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        checkIdentifer = segue.identifier == "goAdd"
        let nextViewController = segue.destination as? AutoCompleteController
        nextViewController?.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
