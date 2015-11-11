//
//  NotifyUtils.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/11/01.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import UIKit
import Foundation

class NotifyUtils {
    
    // 通知登録処理
    internal static func addNotifycation(data: TimerEntity) {
        let notification = UILocalNotification()
        notification.fireDate = data.notify
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = data.title!
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["notifyId" : data.id!]
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    // 通知キャンセル処理
    internal static func cancelNotifycation(notifyId: String) {
        for notification: UILocalNotification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if (notifyId == notification.userInfo!["notifyId"] as! String) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                //break
            }
        }
    }
    
}