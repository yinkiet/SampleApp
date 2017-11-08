//
//  ViewController.swift
//  SampleApp
//
//  Created by Alfred Cheok on 08/11/2017.
//  Copyright © 2017 SampleApp. All rights reserved.
//

import UIKit

import GoogleMaps

class ViewController: UIViewController {
    // A default location to use when location permission is not granted.
    var location = CLLocation(latitude: 3.151008, longitude: 101.594401)
    var locationManager = CLLocationManager()
    var currentLocationMarker: GMSMarker?
    
    let zoomLevel: Float = 14.0
    let originalMapInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    let mapViewPadding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 173.0, right: 0.0)
    
    let latLng = CLLocationCoordinate2D(latitude: 2.6903, longitude: 101.9077)
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBAction func withPaddingOnPress(_ sender: UIButton) {
        var bounds = GMSCoordinateBounds()
        
        bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        bounds = bounds.includingCoordinate(latLng)
        
        let camera = self.mapView.camera(for: bounds, insets: UIEdgeInsets(top: 120, left: 50, bottom: 30, right: 90))!
        self.mapView.animate(to: camera)
    }
    
    @IBAction func withoutPaddingOnPress(_ sender: UIButton) {
        var bounds = GMSCoordinateBounds()
        
        bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        bounds = bounds.includingCoordinate(latLng)
        
        let camera = self.mapView.camera(for: bounds, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))!
        self.mapView.animate(to: camera)
    }
    
    @IBAction func mapViewWithPaddingOnPress(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.mapView.padding = self.mapViewPadding
        })
    }
    
    @IBAction func mapViewWithoutPaddingOnPress(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.mapView.padding = self.originalMapInsets
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        
        mapView.isHidden = true
        
        let marker1 = GMSMarker()
        marker1.position = latLng
        marker1.map = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: CLLocationManagerDelegate {
    
    //Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //location = locations.last!
        
        print("Location: \(location)")
        
        if mapView.isHidden {
            mapView.isHidden = false
            let startingCoordinate = CLLocationCoordinate2D(latitude: self.location.coordinate.latitude, longitude: self.location.coordinate.longitude)
            
            let camera = GMSCameraPosition.camera(withLatitude: startingCoordinate.latitude,
                                                  longitude: startingCoordinate.longitude,
                                                  zoom: zoomLevel)
            
            currentLocationMarker = GMSMarker()
            currentLocationMarker!.position = startingCoordinate
            currentLocationMarker!.map = mapView
            mapView.camera = camera
        }
    }
    
    //Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    //Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

