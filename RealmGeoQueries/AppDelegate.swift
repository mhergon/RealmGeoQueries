//
//  AppDelegate.swift
//  RealmGeoQueries
//
//  Created by mhergon on 5/12/15.
//  Copyright © 2015 Marc Hervera. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()

        // DB
        initialSetup()
        
        // Views
        let boxView = BoxViewController(nibName: "BoxViewController", bundle: nil)
        boxView.tabBarItem = UITabBarItem(title: "Box query", image: UIImage(named: "box"), tag: 0)
        let radiusView = RadiusViewController(nibName: "RadiusViewController", bundle: nil)
        radiusView.tabBarItem = UITabBarItem(title: "Radius query", image: UIImage(named: "radius"), tag: 0)
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [boxView, radiusView]
        self.window?.rootViewController = tabBar
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK:- Methods
    func initialSetup() {

        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        let filePath = path.appendingPathComponent("default.realm")
        
        let fileManager = FileManager.default
        guard !fileManager.fileExists(atPath: filePath) else {
            return
        }
        
        if let db = Bundle.main.path(forResource: "RealmGeoQueriesPoints", ofType: "realm") {
            try! fileManager.copyItem(atPath: db, toPath: filePath)
        }
        
    }
    
    // Only for testing
    /*
    func generateRandom() {
        
        func randInRange(range: Range<Int>) -> Int {
            // arc4random_uniform(_: UInt32) returns UInt32, so it needs explicit type conversion to Int
            // note that the random number is unsigned so we don't have to worry that the modulo
            // operation can have a negative output
            return  Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex))) + range.startIndex
        }
        
        try! Realm().write({ () -> Void in
            
            for _ in 1...50000 {
                
                let lat = Double(randInRange(-9000000...9000000)) / 100000.0
                let lng = Double(randInRange(-18000000...18000000)) / 100000.0
                let p = Point()
                p.name = "\(lat), \(lng)"
                p.lat = lat
                p.lng = lng
                try! Realm().add(p)
                
            }
            
        })
        
    } */
    
}

