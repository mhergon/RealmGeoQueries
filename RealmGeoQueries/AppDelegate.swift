//
//  AppDelegate.swift
//  RealmGeoQueries
//
//  Created by mhergon on 4/10/17.
//  Copyright © 2017 mhergon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        // DB
        initialSetup()
        
        // Views
        let boxView = BoxViewController()
        boxView.tabBarItem = UITabBarItem(title: "Box query", image: UIImage(named: "box"), tag: 0)
        let radiusView = RadiusViewController()
        radiusView.tabBarItem = UITabBarItem(title: "Radius query", image: UIImage(named: "radius"), tag: 1)
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [boxView, radiusView]
        self.window?.rootViewController = tabBar
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
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
    
}

