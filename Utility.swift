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
    
    // 日時間隔の列挙体
    internal enum Interval: String {
        case Year = "yyyy"
        case Month = "MM"
        case Day = "dd"
        case Hour = "HH"
        case Minute = "mm"
        case Second = "ss"
    }
    
    // 指定した間隔を加算した日時(NSDate)を返します
    // パラメータ
    //  interval : 日時間隔の種類を Interval で指定します
    //  number : 追加する日時間隔を整数で指定します
    //           正の数を指定すれば未来の日時を取得できます
    //           負の数を指定すれば過去の日時を取得できます
    //  date : 元の日時を NSDate で指定します
    //
    internal static func dateAdd(interval: Interval, number: Int, date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let comp = NSDateComponents()
        switch interval {
        case .Year:
            comp.year = number
        case .Month:
            comp.month = number
        case .Day:
            comp.day = number
        case .Hour:
            comp.hour = number
        case .Minute:
            comp.minute = number
        case .Second:
            comp.second = number
        default:
            comp.day = 0
        }
        return calendar.dateByAddingComponents(comp, toDate: date, options: [])!
    }
    
    // 2つの日時の間隔を整数型の値で返します
    // パラメータ
    //  interval : 日時間隔の種類を Interval で指定します
    //  date1,date2 : 間隔を計算する2つの日時を指定します
    //           date1よりdate2が前なら負の値を返します
    //
    internal static func dateDiff(interval: Interval, date1: NSDate, date2: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        switch interval {
        case .Year:
            let comp: NSDateComponents =
            calendar.components(NSCalendarUnit.Year,
                fromDate: date1, toDate: date2, options:[])
            return comp.year
        case .Month:
            let comp: NSDateComponents =
            calendar.components(NSCalendarUnit.Month,
                fromDate: date1, toDate: date2, options:[])
            return comp.month
        case .Day:
            let comp: NSDateComponents =
            calendar.components(NSCalendarUnit.Day,
                fromDate: date1, toDate: date2, options:[])
            return comp.day
        case .Hour:
            let comp: NSDateComponents =
            calendar.components(NSCalendarUnit.Hour,
                fromDate: date1, toDate: date2, options:[])
            return comp.hour
        case .Minute:
            let comp: NSDateComponents =
            calendar.components(NSCalendarUnit.Minute,
                fromDate: date1, toDate: date2, options:[])
            return comp.minute
        case .Second:
            let comp: NSDateComponents =
            calendar.components(NSCalendarUnit.Second,
                fromDate: date1, toDate: date2, options:[])
            return comp.second
        default:
            return 0
        }
    }

    // date1とdate2を比較して同じなら0を、
    // date1が古ければ-1、date1が新しければ1を返す
    internal static func dateCompare(date1: NSDate, date2: NSDate) -> Int {
        if (date1.compare(date2) == NSComparisonResult.OrderedDescending){
            return -1
        } else if (date1.compare(date2) == NSComparisonResult.OrderedAscending){
            return 1
        } else {
            return 0
        }
    }
    
}