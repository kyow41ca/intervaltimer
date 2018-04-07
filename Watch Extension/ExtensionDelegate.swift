//
//  ExtensionDelegate.swift
//  Watch Extension
//
//  Created by YoshinagaYuuki on 2015/11/03.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {

    var timerlist: [String : AnyObject] = ["nodata" : true as AnyObject]
    
    let wcSession = WCSession.default
    var timer: Timer = Timer()

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func applicationDidFinishLaunching() {
        
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self;
            session.activate()
        }
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func loadData() {
        if (wcSession.isReachable) {
            let _: [String : Any] = ["val" : 0 as Any]
            
            /*
            wcSession.sendMessage(contents, replyHandler: { (replyMessage) -> Void in
                // タイマーリストを取得する
                self.timerlist = replyMessage
            }) { (error) -> Void in
                print(error)
            }
            */
        }
    }
}
