//
//  TestPoint.swift
//  RealmGeoQueriesTests
//
//  Created by mhergon on 4/10/17.
//  Copyright © 2017 mhergon. All rights reserved.
//

import Realm
import RealmSwift

class TestPoint: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lng: Double = 0.0
    
}
