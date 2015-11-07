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

class TimerListController : WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var mainGroup: WKInterfaceGroup!
    @IBOutlet var loadGroup: WKInterfaceGroup!
    @IBOutlet var errLbl: WKInterfaceLabel!
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var countDownLbl: WKInterfaceLabel!
    @IBOutlet var fromLabel: WKInterfaceLabel!
    @IBOutlet var toLabel: WKInterfaceLabel!
    
    let TITLE: String = "title"
    let FROM: String = "from"
    let TO: String = "to"
    
    let FROM_STR: String = "fromStr"
    let TO_STR: String = "toStr"
    
    let COUNTDOWN: String = "countDown"
    let PERCENT: String = "percent"
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        loadData(0)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func reload() {
        loadData(0)
    }
    
    private func loadData(pageNo: Int) {
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
            
            if (session.reachable) {
                
                let contents = ["val" : pageNo]
                
                session.sendMessage(contents, replyHandler: { (replyMessage) -> Void in
                    // タイマーリストを取得する
                    let timer: [String : AnyObject] = replyMessage
                    
                    // タイマーリストがあるかどうかを判定する
                    if (timer["nodata"] as! Bool) {
                        self.loadGroup.setHidden(false)
                        self.mainGroup.setHidden(true)
                        self.errLbl.setText("iPhoneアプリでタイマーをセットしてください。")
                    } else {
                        self.mainGroup.setHidden(false)
                        self.loadGroup.setHidden(true)
                        self.titleLabel.setText(timer[self.TITLE] as? String)
                        self.countDownLbl.setText(timer[self.COUNTDOWN] as? String)
                        self.fromLabel.setText(timer[self.FROM_STR] as? String)
                        self.toLabel.setText(timer[self.TO_STR] as? String)
                    }
                    
                    }) { (error) -> Void in
                        print(error)
                }
            }
        }
    }
}
