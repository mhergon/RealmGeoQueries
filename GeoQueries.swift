//
//  GeoQueries.swift
//  GeoQueries
//
//  Created by mhergon on 30/11/15.
//  Copyright © 2015 mhergon. All rights reserved.
//

import RealmSwift
import CoreLocation
import MapKit

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
            .filterGeoBox(region.geoBox, latitudeKey: latitudeKey, longitudeKey: longitudeKey)
        
    }

    /**
     Find objects inside GeoBox
     
     - parameter type:         Realm object type
     - parameter box:          GeoBox struct
     - parameter latitudeKey:  Set to use different latitude key in query (default: "lat")
     - parameter longitudeKey: Set to use different longitude key in query (default: "lng")
     
     - returns: Found objects inside GEoBox
     */
    func findInBox<T: Object>(type: T.Type, box: GeoBox, latitudeKey: String = "lat", longitudeKey: String = "lng") -> Results<T> {
        
        // Query
        return self
            .objects(type)
            .filterGeoBox(box, latitudeKey: latitudeKey, longitudeKey: longitudeKey)
        
    }

    /**
     Find objects from center and distance radius
     
     - parameter type:         Realm object type
     - parameter center:       Center coordinate
     - parameter radius:       Radius in meters
     - parameter order:        Sort by distance (optional)
     - parameter latitudeKey:  Set to use different latitude key in query (default: "lat")
     - parameter longitudeKey: Set to use different longitude key in query (default: "lng")
     - parameter distanceKey:  Set to fill distance property
     
     - returns: Found objects inside radius around the center coordinate
     */
    func findNearby<T: Object>(type: T.Type, origin center: CLLocationCoordinate2D, radius: Double, sortAscending sort: Bool?, latitudeKey: String = "lat", longitudeKey: String = "lng", distanceKey: String = "") -> [T] {

        // Query
        return self
            .objects(type)
            .filterGeoBox(center.geoBox(radius), latitudeKey: latitudeKey, longitudeKey: longitudeKey)
            .filterGeoRadius(center, radius: radius, sortAscending: sort, latitudeKey: latitudeKey, longitudeKey: longitudeKey, distanceKey: distanceKey)

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
     - parameter sort:         Sort by distance (optional)
     - parameter latitudeKey:  Set to use different latitude key in query (default: "lat")
     - parameter longitudeKey: Set to use different longitude key in query (default: "lng")
     - parameter distanceKey:  Set to fill distance property
     
     - returns: Found objects inside radius around the center coordinate
     */
    func filterGeoRadius(center: CLLocationCoordinate2D, radius: Double, sortAscending sort: Bool?, latitudeKey: String = "lat", longitudeKey: String = "lng", distanceKey: String = "") -> [T] {
        
        // Get box
        let inBox = self.filterGeoBox(center.geoBox(radius), latitudeKey: latitudeKey, longitudeKey: longitudeKey)
        
        // Query & filter
        let results = inBox.filter { (obj: Object) -> Bool in
            
            // Calculate distance
            let location = CLLocation(latitude: obj.valueForKey(latitudeKey) as! CLLocationDegrees, longitude: obj.valueForKey(longitudeKey) as! CLLocationDegrees)
            let center = CLLocation(latitude: center.latitude, longitude: center.longitude)
            obj.objDist = location.distanceFromLocation(center)
            
            // Save distance if property exists
            if distanceKey != "" {
                
                if let _ = obj.valueForKey(distanceKey) {
                    
                    obj.setValue(obj.objDist, forKey: distanceKey)
                    
                }
                
            }
            
            return obj.objDist <= radius
            
        }
        
        // Sort results
        guard let sort = sort else {
            return results
        }
        
        return results.sortByDistance(sort)
        
    }

}

//MARK:- Public core extensions
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

//MARK: Private core extensions
private extension Array where Element:Object {
    
    /**
     Sorting function
     
     - parameter ascending: Ascending/Descending
     
     - returns: Array of [Object] sorted by distance
     */
    func sortByDistance(ascending: Bool = true) -> [Generator.Element] {
        
        return self.sort({ (a: Object, b: Object) -> Bool in
            
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
    
    private var objDist: Double {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.DistanceKey) as? Double else { return 0.0 }
            return value
        }
        set (value) { objc_setAssociatedObject(self, &AssociatedKeys.DistanceKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
}
