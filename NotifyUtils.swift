//
//  NotifyUtils.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/11/01.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications

class NotifyUtils {
    
    // 通知登録処理
    internal static func addNotifycation(data: TimerEntity) {
        let content = UNMutableNotificationContent()
        content.body = data.title!;
        content.sound = UNNotificationSound.default()
        content.userInfo = ["notifyId" : data.id!]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notifyId", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    // 通知キャンセル処理
    internal static func cancelNotifycation(notifyId: String) {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [notifyId])
    }
    
}
