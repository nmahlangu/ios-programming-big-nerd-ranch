//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Nicholas Mahlangu on 1/18/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var trackingLocation = false
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        
        // Set it as *the* view of this view controller
        self.view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: "mapTypeChanged:", forControlEvents: .ValueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 8)
        let margins = self.view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
    }
    
    override func viewDidLoad() {
        // always call super
        super.viewDidLoad()
        
        // location auth stuff
        locationManager.requestAlwaysAuthorization()    // ask for authorization from user
        locationManager.requestWhenInUseAuthorization() // for use in foreground
        
        // add a button
        let button = UIButton()
        button.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 90, UIScreen.mainScreen().bounds.height - 100, 70, 30)
        button.setTitle("Locate", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.blueColor()
        button.addTarget(self, action: "locationButtonWasPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func locationButtonWasPressed(sender:UIButton!) {
        if !self.trackingLocation {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
                self.trackingLocation = true
            }
        }
        else {
            if CLLocationManager.locationServicesEnabled() {
                let region: MKCoordinateRegion = MKCoordinateRegionMake(mapView.centerCoordinate, MKCoordinateSpanMake(180, 360))
                mapView.setRegion(region, animated: true)
                self.locationManager.stopUpdatingLocation()
                mapView.showsUserLocation = false
                self.trackingLocation = false
            }
        }
    }
    
    func mapTypeChanged(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            break
        }
    }
    
    // delegate that does all location management
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
}
