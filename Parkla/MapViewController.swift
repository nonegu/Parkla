//
//  FirstViewController.swift
//  Parkla
//
//  Created by Ender Güzel on 20.02.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var locations = [Location]()

    @IBOutlet weak var pinSegment: UISegmentedControl!
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        updateAnnotations(for: pinSegment.selectedSegmentIndex)
        
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //longpress recognizer to add annotations
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longpress(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 1.0
        
        mapView.addGestureRecognizer(uilpgr)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //showing user location in the center of the map
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        mapView.showsUserLocation = true
    }
    
    // MARK: - requestLocation() immediately returns the function below.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let userLocation: CLLocation = locations[locations.count-1]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.02
        let longDelta: CLLocationDegrees = 0.02

        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)

        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)

        mapView.setRegion(region, animated: true)

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location could not be received \(error)")
    }
    
    // MARK: a function to change the annonations to be shown on the map
    func updateAnnotations(for segment: Int) {
        
        print(segment)
        
    }
    
    func addAnnotation(at coordinate: CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
        
        var annotationTitle = ""
        let annotationLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        CLGeocoder().reverseGeocodeLocation(annotationLocation) { (placemarks, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                if let placemark = placemarks?[0] {
                    
                    if placemark.subThoroughfare != nil {
                        annotationTitle += placemark.subThoroughfare! + " "
                    }
                    
                    if placemark.thoroughfare != nil {
                        annotationTitle += placemark.thoroughfare!
                    }
                    
                }
                
                annotation.title = annotationTitle
                self.locations.append(Location(latitude: coordinate.latitude, longitude: coordinate.longitude, title: annotation.title ?? "", date: Date()))
                print(self.locations)
            }
            
        }
        
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touchPoint = gestureRecognizer.location(in: mapView)
            
            let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            addAnnotation(at: newCoordinate)
            
        }
        
    }

}

