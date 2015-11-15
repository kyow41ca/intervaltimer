//
//  TimerListController.swift
//  Watch Extension
//
//  Created by YoshinagaYuuki on 2015/11/03.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import ClockKit

class TimerListController : WKInterfaceController, WCSessionDelegate, WKExtensionDelegate {
    
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
    
    let COUNTDOWN_NUM: String = "countDownNum"
    let COUNTDOWN_NUM_STR = "countDownNumStr"
    let COUNTDOWN_STATE = "countDownState"
    let PERCENT: String = "percent"
    
    let TODAY: String = "Today!!!"
    let PREV: String = "Previous"
    let TIMEOVER: String = "Time Over..."
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        loadData(0)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func reload() {
        self.errLbl.setText("Now Loading...")
        loadData(0)
    }
    
    func loadData(pageNo: Int) {
        if (WCSession.defaultSession().reachable) {
            let contents = ["val" : pageNo]
            let session = WCSession.defaultSession()
            
            session.sendMessage(contents, replyHandler: { (replyMessage) -> Void in
                // タイマーリストを取得する
                let delegate: ExtensionDelegate = WKExtension.sharedExtension().delegate as! ExtensionDelegate
                delegate.timerlist = replyMessage
                
                self.setData()
                }) { (error) -> Void in
                    print(error)
            }
        }
    }
    
    func setData() {
        // タイマーリストを取得する
        let delegate: ExtensionDelegate = WKExtension.sharedExtension().delegate as! ExtensionDelegate
        var timer: [String : AnyObject] = delegate.timerlist
        
        // タイマーリストがあるかどうかを判定する        
        if (timer["nodata"] as! Bool) {
            self.loadGroup.setHidden(false)
            self.mainGroup.setHidden(true)
            self.errLbl.setText(NSLocalizedString("timerListViewCaution", comment: ""))
        } else {
            self.mainGroup.setHidden(false)
            self.loadGroup.setHidden(true)
            self.titleLabel.setText(timer[self.TITLE] as? String)
            
            let countDownNumStr: String = (timer[self.COUNTDOWN_NUM_STR] as? String)!
            let countDownState: String = (timer[self.COUNTDOWN_STATE] as? String)!
            
            // 当日
            if (countDownState == self.TODAY) {
                self.countDownLbl.setTextColor(UIColor.redColor())
                self.countDownLbl.setText(countDownState)
            }
            // 開始日前
            else if (countDownState == self.PREV) {
                self.countDownLbl.setTextColor(UIColor.greenColor())
                self.countDownLbl.setText(countDownState)
            }
            // 過日
            else if (countDownState == self.TIMEOVER) {
                self.countDownLbl.setTextColor(UIColor.grayColor())
                self.countDownLbl.setText(countDownState)
            }
            else {
                self.countDownLbl.setTextColor(UIColor.greenColor())
                self.countDownLbl.setText(countDownNumStr + countDownState)
            }
            
            self.fromLabel.setText(timer[self.FROM_STR] as? String)
            self.toLabel.setText(timer[self.TO_STR] as? String)
            
            updateComplication()
        }

    }
    
    func updateComplication() {
        let server: CLKComplicationServer = CLKComplicationServer.sharedInstance()
        for var complication: CLKComplication in server.activeComplications {
            server.reloadTimelineForComplication(complication)
        }
    }
}
