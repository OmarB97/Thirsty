//
//  MapViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 4/24/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    private typealias `Self` = MapViewController

    static var waterReports: [[Int: Dictionary<String, Any>]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
//        var locManager = CLLocationManager()
//        locManager.delegate = self
//        locManager.requestWhenInUseAuthorization()
//        var currentLocation: CLLocation!
//        
//        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
//            
//            currentLocation = locManager.location
        let locationManager = CLLocationManager()
        var currentLocation: CLLocation?
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        currentLocation = locationManager.location
        
        let locationMarker = GMSMarker()
        locationMarker.icon = GMSMarker.markerImage(with: .blue)
        locationMarker.position = CLLocationCoordinate2D(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
        locationMarker.title = "Your current location"
        locationMarker.map = mapView
        
        // Creates a marker in the center of the map.
        for (index, rep) in (Self.waterReports).enumerated() {
            let marker = GMSMarker()
            let report = rep[index + 1]
            let reportNum = rep.keys.first!
            let reporter = String(describing: (report?["reporter"])!)
            let latitude = report?["latitude"]! as! Double!
            let longitude = report?["longitude"]! as! Double!
            let waterType = String(describing: (report?["waterType"])!)
            let waterCondition = String(describing: (report?["waterCondition"])!)
            marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            marker.title = "Report #\(reportNum)"
            marker.snippet = "Reporter: \(reporter)\nWater Type: \(waterType)\nWater Condition: \(waterCondition)"
            marker.map = mapView
        }
        
    }

}
