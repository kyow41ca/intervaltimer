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
    
    // Tableで使用する配列を設定する.
    var timerlist: Array<TimerEntity>=[]
    var str: String = ""

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
//        if (WCSession.isSupported()) {
//            let session = WCSession.defaultSession()
//            session.delegate = self;
//            session.activateSession()
//            
//            if (session.reachable) {
//                
//                let contents = ["body" : "sendInteractiveMessaging"]
//                
//                session.sendMessage(contents, replyHandler: { (replyMessage) -> Void in
//                    //iOSからのデータを受信した時の処理
//                    print("receive::\replyMessage")
//                    //self.timerlist = replyMessage["data"] as! Array<TimerEntity>
//                    self.str = replyMessage["data"] as! String
//                    //self.titleLabel.setText(str)
//                    }) { (error) -> Void in
//                        print(error)
//                }
//            }
//        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}
