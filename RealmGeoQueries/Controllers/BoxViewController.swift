//
//  BoViewController.swift
//  RealmGeoQueries
//
//  Created by mhergon on 4/10/17.
//  Copyright © 2017 mhergon. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

fileprivate let AnnotationIdentifier = "AnnotationIdentifier"

class BoxViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate var results: Results<Point>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        
    }

    //MARK:- Methods
    func reloadData() {
        
        // Get results
        results = try! Realm().findInRegion(type: Point.self, region: mapView.region)
        
        // Add to map
        guard let r = results else { return }
        
        // Remove previous annotations
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        // Marina services
        var annotations = [Annotation]()
        for p in r {
            
            let coordinate = CLLocationCoordinate2D(latitude: p.lat, longitude: p.lng)
            let a = Annotation(location: coordinate, name: p.name)
            annotations.append(a)
            
        }
        
        // Add new annotations
        self.mapView.addAnnotations(annotations)
        
    }
    
}

// MARK: - MKMapViewDelegate
extension BoxViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        reloadData()
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // User location
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let a = annotation as? Annotation else {
            return nil
        }
        
        // Marinas
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationIdentifier)
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationIdentifier)
            pin?.canShowCallout = true
        }
        
        pin?.annotation = a
        
        return pin
        
    }
    
}
