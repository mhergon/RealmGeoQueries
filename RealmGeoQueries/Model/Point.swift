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
    
    @objc dynamic var name = ""
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lng: Double = 0.0
    
}
