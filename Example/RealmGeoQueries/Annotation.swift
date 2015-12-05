//
//  Annotation.swift
//  Geohash-Mapbox
//
//  Created by mhergon on 21/5/15.
//  Copyright (c) 2015 mhergon. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Annotation: NSObject, MKAnnotation {
   
    let coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(location coordinate: CLLocationCoordinate2D, name: String?) {
        self.coordinate = coordinate
        self.title = name
    }

}
