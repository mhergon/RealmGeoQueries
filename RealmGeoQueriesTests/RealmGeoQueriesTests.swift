//
//  RealmGeoQueriesTests.swift
//  RealmGeoQueriesTests
//
//  Created by mhergon on 4/10/17.
//  Copyright © 2017 mhergon. All rights reserved.
//

import XCTest
import RealmSwift
import GeoQueries
import CoreLocation
import MapKit

class RealmGeoQueriesTests: XCTestCase {
    
    // MARK: - Properties
    fileprivate var realm: Realm?
    fileprivate let centerCoordinate = CLLocationCoordinate2DMake(43.0, 2.0)
    
    // MARK: - Setup methods
    override func setUp() {
        super.setUp()
        
        // Setup Realm
        realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "testRealm"))
        
        // Setup test points
        try! realm?.write {
        
            var point = TestPoint()
            point.lat = 43.5837
            point.lng = 2.43782
            realm?.add(point)
            
            point = TestPoint()
            point.lat = 43.5237
            point.lng = 2.93782
            realm?.add(point)
            
            point = TestPoint()
            point.lat = 42.5237
            point.lng = 3.93782
            realm?.add(point)
            
            point = TestPoint()
            point.lat = 43.1237
            point.lng = 2.90782
            realm?.add(point)
            
        }

    }
    
    override func tearDown() {
        
        try! realm?.write {
            realm?.deleteAll()
        }
        realm = nil
        
        super.tearDown()
    }
    
    // MARK: - General methods
    func testFindInRegionSomePoints() {

        let region = MKCoordinateRegion.init(center: centerCoordinate, span: MKCoordinateSpan.init(latitudeDelta: 2.0, longitudeDelta: 2.0))
        let count = try! realm?.findInRegion(type: TestPoint.self, region: region).count ?? 0
        XCTAssertGreaterThan(count, 0)
        
    }
    
    func testFindInBoxSomePoints() {
        
        let count = try! realm?.findInBox(type: TestPoint.self, box: centerCoordinate.geoBox(radius: 200000)).count ?? 0
        XCTAssertGreaterThan(count, 0)
        
    }
    
    func testFindNearbySomePoints() {
        
        let count = try! realm?.findNearby(type: TestPoint.self, origin: centerCoordinate, radius: 100000, sortAscending: true).count ?? 0
        XCTAssertGreaterThan(count, 0)
        
    }
    
    func testFindNearbyMinimumRadius() {
        
        let count = try! realm?.findNearby(type: TestPoint.self, origin: centerCoordinate, radius: 100, sortAscending: true).count ?? 0
        XCTAssertEqual(count, 0)
        
    }
    
    // MARK: - Results methods
    func testFilterGeoRegion() {
        
        let all = realm?.objects(TestPoint.self)
        
        let region = MKCoordinateRegion.init(center: centerCoordinate, span: MKCoordinateSpan.init(latitudeDelta: 2.0, longitudeDelta: 2.0))
        
        do {
        
            let count = try all?.filterGeoRegion(region: region).count ?? 0
            XCTAssertGreaterThan(count, 0)
            
        } catch {
            
            XCTFail("\(error)")
            
        }
        
    }
    
    // MARK: - List methods
    func testFilterGeoRegionWithoutRealm() {
        
        let list = List<TestPoint>()
        
        let point = TestPoint()
        point.lat = 43.5837
        point.lng = 2.43782
        list.append(point)
        
        let region = MKCoordinateRegion.init(center: centerCoordinate, span: MKCoordinateSpan.init(latitudeDelta: 2.0, longitudeDelta: 2.0))
        
        do {

            let count = try list.filterGeoRegion(region: region).count
            XCTAssertEqual(count, 0)
            XCTFail()
            
        } catch {
            
            XCTAssertNotNil(error)
            
        }
        
        
    }
    
    
}
