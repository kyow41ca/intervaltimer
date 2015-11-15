//
//  AppDelegate.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/10/25.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import UIKit
import CoreData
import IntervalTimerKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    
    // NSUserDefaults のインスタンス
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var watchViewID: String = ""

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // ２回目以降の起動時
        if (userDefaults.boolForKey("FirstLaunch"))
        {
            // 値を読み込む
            self.watchViewID = userDefaults.objectForKey("WatchViewID") as! String
        }
        // 初回起動時
        else
        {
            // 初回起動
            userDefaults.setBool(true, forKey: "FirstLaunch")
            userDefaults.synchronize()
            
            // Apple Watch表示フラグの初期値をセットする
            userDefaults.registerDefaults(["WatchViewID" : ""])
            
            // 通知許可設定を行う
            let types : UIUserNotificationType =
            [UIUserNotificationType.Badge,
                UIUserNotificationType.Alert,
                UIUserNotificationType.Sound]
            let settins : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settins)
        }
        
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
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
        DataAccess.sharedInstance.saveContext()
    }
    
    internal func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        // Apple Watch表示用データのIDを取得する
        // IDを元にApple Watch表示用データを呼び出し
        let context : NSManagedObjectContext = DataAccess.sharedInstance.managedObjectContext
        let freg = NSFetchRequest(entityName: "TimerEntity")
        freg.predicate = NSPredicate(format: "id = %@", self.watchViewID)
        
        // セルのデータを全行読み込む
        var timerlist: Array<AnyObject> = []
        
        do {
            timerlist = try context.executeFetchRequest(freg)
        } catch let error as NSError {
            print(error)
        }
        
        // リストがなければノーデータを返す
        if (0 == timerlist.count) {
            var replyMessage: [String : AnyObject] = [:]
            replyMessage["nodata"] = true
            replyHandler(replyMessage)
            return
        }
        
        let val: Int = message["val"] as! Int
        
        // 指定の番号のリストのみを返す
        var replyMessage: [String : AnyObject] = Utility.rowDataFormat(timerlist[val] as! NSManagedObject)
        replyMessage["nodata"] = false
        
        replyHandler(replyMessage)
    }

}

