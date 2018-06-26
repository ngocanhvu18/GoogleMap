//
//  ViewController.swift
//  GoogleMap
//
//  Created by Student on 6/20/18.
//  Copyright © 2018 Student. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapViewController: UIViewController {
    var locationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        return locationManager
    }()
    
    var marker: GMSMarker!
    
    var currentLocation: CLLocation?
    @IBOutlet weak var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        placesClient = GMSPlacesClient.shared()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedPlace != nil {
            print(selectedPlace!.name)
        }
    }
    
    // danh sach dia diem lua chon
    func listLikelyPlaces() {
        likelyPlaces.removeAll()
        placesClient.currentPlace { (placesLikelihoods, error) -> Void in
            // xu li khi khong co dulieu
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            // xu li khi co du lieu
            if let likelihoodList = placesLikelihoods{
                for likelihood in likelihoodList.likelihoods {
                    let places = likelihood.place
                    self.likelyPlaces.append(places)
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // chuyen du lieu
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as? PlacesViewController
        nextViewController?.likeliPlaces = likelyPlaces
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        //        // Clear the map.
        mapView.clear()
        // Add a marker to the map.
        if selectedPlace != nil {
            let marker = GMSMarker(position: (self.selectedPlace?.coordinate)!)
            marker.icon = #imageLiteral(resourceName: "icons8-map_pin")
            marker.title = selectedPlace?.name
            marker.snippet = selectedPlace?.formattedAddress
            marker.map = mapView
            
        }
        
        listLikelyPlaces()
    }
    
}
extension MapViewController: CLLocationManagerDelegate {
    // xu ly vi tri
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation =  locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        
        
        // danh dau vi tri
        marker = nil
        mapView.clear()
        //        marker = GMSMarker()
        //        marker.position = location.coordinate
        //        marker.title = "Tao o day"
        //        marker.snippet = "Hiep tao di"
        //        marker.map = mapView
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        listLikelyPlaces()
        
    }
    // xu ly dieu kien xac dinh vi tri day
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch  status {
        case .restricted:
            print("Location access was restricted")
        case .denied :
            print("User denied access to location")
            // hienn thi vi tri mac dinh
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    // xu ly bi loi
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error:\(error)")
    }
}
