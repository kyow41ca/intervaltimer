//
//  Utility.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/10/31.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import Foundation

class Utility {

    // NSDateをStringに変換する
    internal static func dateString(date: NSDate, format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = format
        let dateString: String = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    // NSDateの日付だけを取り出してあとは捨てる
    internal static func cutTime(date: NSDate) -> NSDate {
        // カレンダーを取得
        let calendar = NSCalendar.currentCalendar()
        
        // 対象の NSDate から NSDateComponents を取得
        let dateComponents = calendar.components([.Era, .Year, .Month, .Day], fromDate: date)
        
        // NSDateComponents から NSDate を生成
        return calendar.dateFromComponents(dateComponents)!
    }
    
}