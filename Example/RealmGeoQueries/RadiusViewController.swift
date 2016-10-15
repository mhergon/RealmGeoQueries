//
//  RadiusViewController.swift
//  RealmGeoQueries
//
//  Created by mhergon on 5/12/15.
//  Copyright © 2015 Marc Hervera. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

private let AnnotationIdentifier = "AnnotationIdentifier"


class RadiusViewController: UIViewController {

    //MARK:- Properties
    @IBOutlet weak var mapView: MKMapView!
    
    var results: [Point]?
    
    
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
        let radius = 450000.0 // 450 km
        results = try! Realm().findNearby(type: Point.self, origin: mapView.centerCoordinate, radius: radius, sortAscending: true)
        
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
        
        // Add circle
        mapView.removeOverlays(mapView.overlays)
        let circle = MKCircle(center: mapView.centerCoordinate, radius: radius)
        mapView.add(circle)
        
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
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationIdentifier)
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationIdentifier)
            pin?.canShowCallout = true
        }
        
        pin?.annotation = a
        
        return pin
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = UIColor.red
        circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
        circle.lineWidth = 1
        return circle
        
    }

}
