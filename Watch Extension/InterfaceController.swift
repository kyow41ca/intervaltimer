//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by YoshinagaYuuki on 2015/11/03.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var fromLabel: WKInterfaceLabel!
    @IBOutlet var toLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
            
            if (session.reachable) {
                
                let contents = ["body" : "sendInteractiveMessaging"]
                
                session.sendMessage(contents, replyHandler: { (replyMessage) -> Void in
                    //iOSからのデータを受信した時の処理
                    print("receive::\replyMessage")
                    let timerlist = replyMessage["data"] as! Array<Array<AnyObject>>
                    //let str = replyMessage["data"] as! String
                    //self.titleLabel.setText(str)
                    let timer: Array<AnyObject> = timerlist[0]
                    self.titleLabel.setText(timer[0] as? String)
                    self.fromLabel.setText(self.dateString(timer[1] as! NSDate))
                    self.toLabel.setText(self.dateString(timer[2] as! NSDate))
                    }) { (error) -> Void in
                        print(error)
                }
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func dateString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateString: String = dateFormatter.stringFromDate(date)
        return dateString
    }

}
