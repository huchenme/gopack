//
//  AppDelegate.swift
//  GoPack
//
//  Created by Hu Chen on 1/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import UIKit
import RealmSwift

var realm: Realm!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let config = Realm.Configuration(
        schemaVersion: 6,
        migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 4 {
                migration.enumerate(Category.className()) { oldObject, newObject in
                    newObject!["id"] = NSUUID().UUIDString
                }
                migration.enumerate(Item.className()) { oldObject, newObject in
                    newObject!["id"] = NSUUID().UUIDString
                }
            }
            if oldSchemaVersion < 5 {
                var categoryOrder = 0
                migration.enumerate(Category.className()) { oldObject, newObject in
                    newObject!["order"] = categoryOrder
                    categoryOrder++
                }
            }
        }
    )
    
    func populateDefaultItems() {
        try! realm.write() {
            realm.deleteAll()
            
            realm.add(Item(value: ["title" : "test title", "order": 0]))
            realm.add(Item(value: ["title" : "test long long title with some long text and it should be long", "order": 1, "note": "test long long title with some long text and it should be long", "hidden": true]))
            realm.add(Item(value: ["title" : "Battery", "order": 2, "completed": true]))
            
            realm.add(Category(value: ["title" : "category A", "order": 0]))
            realm.add(Category(value: ["title" : "category B", "order": 1]))
            realm.add(Category(value: ["title" : "category C", "order": 2]))
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        realm = try! Realm()
        
        //FIXME: remove in production
//        populateDefaultItems()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
}

