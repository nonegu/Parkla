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
import RealmSwift

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var annotationExist: Bool = false
    var realm = try! Realm()
    var locationManager = CLLocationManager()
    var locations: Results<Location>!
    var annotationTitle = ""
    
    @IBOutlet weak var pinSegment: UISegmentedControl!
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        updateAnnotations(for: pinSegment.selectedSegmentIndex)
        
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAnnotations()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        mapView.removeAnnotations(mapView.annotations)
        loadAnnotations()
        annotationExist = false
        annotationTitle = ""
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
    
    func loadAnnotations() {
        
        locations = realm.objects(Location.self)
        
        for location in locations {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.title = location.title
            mapView.addAnnotation(annotation)
        }
    }
    
    func addAnnotation(at coordinate: CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
        
        let annotationLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        CLGeocoder().reverseGeocodeLocation(annotationLocation) { (placemarks, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                if let placemark = placemarks?[0] {
                    
                    if placemark.subThoroughfare != nil {
                        self.annotationTitle += placemark.subThoroughfare! + " "
                    }
                    
                    if placemark.thoroughfare != nil {
                        self.annotationTitle += placemark.thoroughfare!
                    }
                    
                }
                
                annotation.title = self.annotationTitle
                self.saveRealm(at: coordinate, title: self.annotationTitle)
                
            }
            
        }
        
    }
    
    func removeSpecificAnnotation() {
        for annotation in self.mapView.annotations {
            if let title = annotation.title, title == annotationTitle {
                self.mapView.removeAnnotation(annotation)
                deleteRealm(at: annotation.coordinate, title: annotationTitle)
            }
        }
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touchPoint = gestureRecognizer.location(in: mapView)
            
            let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            if annotationExist {
                print(annotationTitle)
                removeSpecificAnnotation()
                annotationTitle = ""
                addAnnotation(at: newCoordinate)
            } else {
                addAnnotation(at: newCoordinate)
                annotationExist = true
            }
            
        }
        
    }
    
    func saveRealm(at coordinate: CLLocationCoordinate2D, title: String) {
        
        let location = Location()
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.title = title
        location.date = Date()
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(location)
            }
        } catch {
                print("Error initialising new realm, \(error)")
        }
            
    }
    
    func deleteRealm(at coordinate: CLLocationCoordinate2D, title: String) {
        
        let locationToDelete = realm.objects(Location.self).filter("title = %@", title)
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(locationToDelete)
            }
        } catch {
            print("Error deleting realm, \(error)")
        }
        
    }
        
        
}



