//
//  Point.swift
//  TestGeoQuery
//
//  Created by mhergon on 30/11/15.
//  Copyright © 2015 mhergon. All rights reserved.
//

import Realm
import RealmSwift

class Point: Object {
    dynamic var name = ""
    dynamic var lat: Double = 0.0
    dynamic var lng: Double = 0.0
    
    required internal init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.lat = latitude
        self.lng = longitude
        super.init()
    }

    required init() {
        super.init()
    }
    
    required override init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
}
