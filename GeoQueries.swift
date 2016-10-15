//
//  GeoQueries.swift
//  GeoQueries
//
//  Created by mhergon on 15/10/16.
//  Copyright © 2016 mhergon. All rights reserved.
//

import RealmSwift
import CoreLocation
import MapKit

// MARK: - Public extensions
public extension Realm {
    
    /**
     Find objects inside MKCoordinateRegion. Useful for use in conjunction with MapKit
     
     - parameter type:         Realm object type
     - parameter region:       Region that fits MapKit view
     - parameter latitudeKey:  Set to use different latitude key in query (default: "lat")
     - parameter longitudeKey: Set to use different longitude key in query (default: "lng")
     
     - returns: Found objects inside MKCoordinateRegion
     */
    func findInRegion<T: Object>(type: T.Type, region: MKCoordinateRegion, latitudeKey: String = "lat", longitudeKey: String = "lng") -> Results<T> {
        
        // Query
        return self
            .objects(type)
            .filterGeoBox(box: region.geoBox, latitudeKey: latitudeKey, longitudeKey: longitudeKey)
        
    }
    
    /**
     Find objects inside GeoBox
     
     - parameter type:         Realm object type
     - parameter box:          GeoBox struct
     - parameter latitudeKey:  Set to use different latitude key in query (default: "lat")
     - parameter longitudeKey: Set to use different longitude key in query (default: "lng")
     
     - returns: Found objects inside GeoBox
     */
    func findInBox<T: Object>(type: T.Type, box: GeoBox, latitudeKey: String = "lat", longitudeKey: String = "lng") -> Results<T> {
        
        // Query
        return self
            .objects(type)
            .filterGeoBox(box: box, latitudeKey: latitudeKey, longitudeKey: longitudeKey)
        
    }
    
    /**
     Find objects from center and distance radius
     
     - parameter type:         Realm object type
     - parameter center:       Center coordinate
     - parameter radius:       Radius in meters
     - parameter order:        Sort by distance (optional)
     - parameter latitudeKey:  Set to use different latitude key in query (default: "lat")
     - parameter longitudeKey: Set to use different longitude key in query (default: "lng")
     
     - returns: Found objects inside radius around the center coordinate
     */
    func findNearby<T: Object>(type: T.Type, origin center: CLLocationCoordinate2D, radius: Double, sortAscending sort: Bool?, latitudeKey: String = "lat", longitudeKey: String = "lng") -> [T] {
        
        // Query
        return self
            .objects(type)
            .filterGeoBox(box: center.geoBox(radius: radius), latitudeKey: latitudeKey, longitudeKey: longitudeKey)
            .filterGeoRadius(center: center, radius: radius, sortAscending: sort, latitudeKey: latitudeKey, longitudeKey: longitudeKey)
        
    }
    
}

public extension Results {
    
    /**
     Filter results from Realm query using MKCoordinateRegion
     
     - parameter region:       Region that fits MapKit view
     - parameter latitudeKey:  Set to use different latitude key in query (default: "lat")
     - parameter longitudeKey: Set to use different longitude key in query (default: "lng")
     
     - returns: Filtered objects inside MKCoordinateRegion
     */
    func filterGeoRegion(region: MKCoordinateRegion, latitudeKey: String = "lat", longitudeKey: String = "lng") -> Results<T> {
        
        let box = region.geoBox
        
        let topLeftPredicate = NSPredicate(format: "%K <= %f AND %K >= %f", latitudeKey, box.topLeft.latitude, longitudeKey, box.topLeft.longitude)
        let bottomRightPredicate = NSPredicate(format: "%K >= %f AND %K <= %f", latitudeKey, box.bottomRight.latitude, longitudeKey, box.bottomRight.longitude)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [topLeftPredicate, bottomRightPredicate])
        
        return self.filter(compoundPredicate)
        
    }
    
    /**
     Filter results from Realm query using GeoBox
     
     - parameter box:          GeoBox struct
     - parameter latitudeKey:  Set to use different latitude key in query (default: "lat")
     - parameter longitudeKey: Set to use different longitude key in query (default: "lng")
     
     - returns: Filtered objects inside GeoBox
     */
    func filterGeoBox(box: GeoBox, latitudeKey: String = "lat", longitudeKey: String = "lng") -> Results<T> {
        
        let topLeftPredicate = NSPredicate(format: "%K <= %f AND %K >= %f", latitudeKey, box.topLeft.latitude, longitudeKey, box.topLeft.longitude)
        let bottomRightPredicate = NSPredicate(format: "%K >= %f AND %K <= %f", latitudeKey, box.bottomRight.latitude, longitudeKey, box.bottomRight.longitude)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [topLeftPredicate, bottomRightPredicate])
        
        return self.filter(compoundPredicate)
        
    }
    
    /**
     Filter results from center and distance radius
     
     - parameter center:       Center coordinate
     - parameter radius:       Radius in meters
     - parameter sort:         Sort by distance (optionl)
     - parameter latitudeKey:  Set to use different latitude key in query (default: "lat")
     - parameter longitudeKey: Set to use different longitude key in query (default: "lng")
     
     - returns: Found objects inside radius around the center coordinate
     */
    func filterGeoRadius(center: CLLocationCoordinate2D, radius: Double, sortAscending sort: Bool?, latitudeKey: String = "lat", longitudeKey: String = "lng") -> [T] {
        
        // Get box
        let inBox = self.filterGeoBox(box: center.geoBox(radius: radius), latitudeKey: latitudeKey, longitudeKey: longitudeKey)
        
        // add distance
        let distance = inBox.addDistance(center: center, latitudeKey: latitudeKey, longitudeKey: longitudeKey)
        
        // Inside radius
        let radius = distance.filter { (obj: Object) -> Bool in
            
            return obj.objDist <= radius
            
        }
        
        // Sort results
        guard let s = sort else {
            return radius
        }
        
        return radius.sort(ascending: s)
        
    }
    
    func sortByDistance(center: CLLocationCoordinate2D, ascending: Bool, latitudeKey: String = "lat", longitudeKey: String = "lng") -> [T] {
        
        return self
            .addDistance(center: center, latitudeKey: latitudeKey, longitudeKey: longitudeKey)
            .sort(ascending: ascending)
        
    }
    
}

// MARK: - Public core extensions
/**
 *  GeoBox struct. Set top-left and bottom-right coordinate to create a box
 */
public struct GeoBox {
    
    var topLeft: CLLocationCoordinate2D
    var bottomRight: CLLocationCoordinate2D
    
    init(topLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D) {
        self.topLeft = topLeft
        self.bottomRight = bottomRight
    }
    
}

public extension CLLocationCoordinate2D {
    
    /**
     Accessory function to convert CLLocationCoordinate2D to GeoBox
     
     - parameter radius: Radius in meters
     
     - returns: GeoBox struct
     */
    func geoBox(radius: Double) -> GeoBox {
        
        return MKCoordinateRegionMakeWithDistance(self, radius * 2.0, radius * 2.0).geoBox
        
    }
    
}

public extension MKCoordinateRegion {
    
    // Accessory function to convert MKCoordinateRegion to GeoBox
    var geoBox: GeoBox {
        
        let maxLat = self.center.latitude + (self.span.latitudeDelta / 2.0)
        let minLat = self.center.latitude - (self.span.latitudeDelta / 2.0)
        let maxLng = self.center.longitude + (self.span.longitudeDelta / 2.0)
        let minLng = self.center.longitude - (self.span.longitudeDelta / 2.0)
        
        return GeoBox(
            topLeft: CLLocationCoordinate2D(latitude: maxLat, longitude: minLng),
            bottomRight: CLLocationCoordinate2D(latitude: minLat, longitude: maxLng)
        )
        
    }
    
}

// MARK: - Private core extensions
private extension Results {
    
    /**
     Add distance to sort results
     
     - parameter center:       Center coordinate
     - parameter latitudeKey:  Set to use different latitude key in query (default: "lat")
     - parameter longitudeKey: Set to use different longitude key in query (default: "lng")
     
     - returns: Array of results sorted
     */
    func addDistance(center: CLLocationCoordinate2D, latitudeKey: String = "lat", longitudeKey: String = "lng") -> [T] {
        
        return self.map { (obj) -> T in
            
            // Calculate distance
            let location = CLLocation(latitude: obj.value(forKeyPath: latitudeKey) as! CLLocationDegrees, longitude: obj.value(forKeyPath: longitudeKey) as! CLLocationDegrees)
            let center = CLLocation(latitude: center.latitude, longitude: center.longitude)
            let distance = location.distance(from: center)
            
            // Save
            obj.objDist = distance
            
            return obj
            
        }
        
    }
    
}

private extension Array where Element:Object {
    
    /**
     Sorting function
     
     - parameter ascending: Ascending/Descending
     
     - returns: Array of [Object] sorted by distance
     */
    func sort(ascending: Bool = true) -> [Iterator.Element] {
        
        return self.sorted(by: { (a: Object, b: Object) -> Bool in
            
            if ascending {
                
                return a.objDist < b.objDist
                
            } else {
                
                return a.objDist > b.objDist
                
            }
            
        })
        
    }
    
}

private extension Object {
    
    private struct AssociatedKeys {
        static var DistanceKey = "DistanceKey"
    }
    
    var objDist: Double {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.DistanceKey) as? Double else { return 0.0 }
            return value
        }
        set (value) { objc_setAssociatedObject(self, &AssociatedKeys.DistanceKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
}
