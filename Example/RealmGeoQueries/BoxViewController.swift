//
//  BoxViewController.swift
//  RealmGeoQueries
//
//  Created by mhergon on 5/12/15.
//  Copyright © 2015 Marc Hervera. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

private let AnnotationIdentifier = "AnnotationIdentifier"


class BoxViewController: UIViewController, MKMapViewDelegate {

    //MARK:- Properties
    @IBOutlet weak var mapView: MKMapView!
    
    var results: Results<Point>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Methods
    func reloadData() {
        
        // Get results
        results = try! Realm().findInRegion(Point.self, region: mapView.region)
        
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
    
    //MARK:- MKMapViewDelegate
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        reloadData()
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // User location
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let a = annotation as? Annotation else {
            return nil
        }
        
        // Marinas
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(AnnotationIdentifier)
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationIdentifier)
            pin?.canShowCallout = true
        }
        
        pin?.annotation = a
        
        return pin
        
    }
    
}
