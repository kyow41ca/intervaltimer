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
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        
        // 対象の NSDate から NSDateComponents を取得
        let dateComponents = calendar.components([.Era, .Year, .Month, .Day], fromDate: date)
        
        // NSDateComponents から NSDate を生成
        return calendar.dateFromComponents(dateComponents)!
    }
    
    // Toと通知時刻から通知を行うNSDateを生成する
    internal static func createNotifyTime(toDate: NSDate, notifyDate: NSDate) -> NSDate {
        // カレンダーを取得
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        
        // 対象の NSDate から NSDateComponents を取得
        let toDateComps = calendar.components([.Era, .Year, .Month, .Day], fromDate: toDate)
        let notifyDateComps = calendar.components([.Era, .Year, .Month, .Day, .Hour, .Minute], fromDate: notifyDate)
        
        return calendar.dateWithEra(1, year: toDateComps.year, month: toDateComps.month, day: toDateComps.day, hour: notifyDateComps.hour, minute: notifyDateComps.minute, second: 0, nanosecond: 0)!
    }
    
    // UTCをシステムロケールのタイムゾーンに合わせてNSDateを返す
    internal static func conveSysLocaleDate(date: NSDate) -> NSDate {
        // カレンダーを取得
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        
        // 対象の NSDate から NSDateComponents を取得
        let dateComps = calendar.components([.Era, .Year, .Month, .Day, .Hour, .Minute], fromDate: date)
        
        return calendar.dateWithEra(1, year: dateComps.year, month: dateComps.month, day: dateComps.day, hour: dateComps.hour, minute: dateComps.minute, second: dateComps.second, nanosecond: 0)!
    }
    
}