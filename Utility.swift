//
//  Utility.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/10/31.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Utility {
    
    internal static let ID: String = "id"
    internal static let TITLE: String = "title"
    internal static let FROM: String = "from"
    internal static let TO: String = "to"
    
    internal static let FROM_STR: String = "fromStr"
    internal static let TO_STR: String = "toStr"
    
    internal static let COUNTDOWN_NUM: String = "countDownNum"
    internal static let COUNTDOWN_NUM_STR = "countDownNumStr"
    internal static let COUNTDOWN_STATE = "countDownState"
    internal static let PERCENT: String = "percent"
    
    internal static let TODAY: String = "Today!!!"
    internal static let PREV: String = "Previous"
    internal static let TIMEOVER: String = "Time Over..."

    // NSDateをStringに変換する
    internal static func dateString(date: NSDate, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?
        dateFormatter.dateFormat = format
        let dateString: String = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    // NSDateの日付だけを取り出してあとは捨てる
    internal static func cutTime(date: NSDate) -> NSDate {
        // カレンダーを取得
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        // 対象の NSDate から NSDateComponents を取得
        let dateComponents = calendar.components([.era, .year, .month, .day], from: date as Date)
        
        // NSDateComponents から NSDate を生成
        return calendar.date(from: dateComponents)! as NSDate
    }
    
    // Toと通知時刻から通知を行うNSDateを生成する
    internal static func createNotifyTime(toDate: NSDate, notifyDate: NSDate) -> NSDate {
        // カレンダーを取得
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        // 対象の NSDate から NSDateComponents を取得
        let toDateComps = calendar.components([.era, .year, .month, .day], from: toDate as Date)
        let notifyDateComps = calendar.components([.era, .year, .month, .day, .hour, .minute], from: notifyDate as Date)
        
        return calendar.date(era: 1, year: toDateComps.year!, month: toDateComps.month!, day: toDateComps.day!, hour: notifyDateComps.hour!, minute: notifyDateComps.minute!, second: 0, nanosecond: 0)! as NSDate
    }
    
    // UTCをシステムロケールのタイムゾーンに合わせてNSDateを返す
    internal static func conveSysLocaleDate(date: NSDate) -> NSDate {
        // カレンダーを取得
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        // 対象の NSDate から NSDateComponents を取得
        let dateComps = calendar.components([.era, .year, .month, .day, .hour, .minute], from: date as Date)
        
        return calendar.date(era: 1, year: dateComps.year!, month: dateComps.month!, day: dateComps.day!, hour: dateComps.hour!, minute: dateComps.minute!, second: dateComps.second!, nanosecond: 0)! as NSDate
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
        let calendar = NSCalendar.current
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
//        default:
//            comp.day = 0
        }
        //return calendar.dateByAddingComponents(comp, toDate: date, options: [])!
        return calendar.date(byAdding: comp as DateComponents, to: date as Date, wrappingComponents: false)! as NSDate
    }
    
    // 2つの日時の間隔を整数型の値で返します
    // パラメータ
    //  interval : 日時間隔の種類を Interval で指定します
    //  date1,date2 : 間隔を計算する2つの日時を指定します
    //           date1よりdate2が前なら負の値を返します
    //
    internal static func dateDiff(interval: Interval, date1: NSDate, date2: NSDate) -> Int {
        _ = NSCalendar.current
        /*
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
//        default:
//            return 0
        }
        */
        return 0
    }

    // date1とdate2を比較して同じなら0を、
    // date1が古ければ-1、date1が新しければ1を返す
    internal static func dateCompare(date1: NSDate, date2: NSDate) -> Int {
        if (date1.compare(date2 as Date) == ComparisonResult.orderedDescending){
            return -1
        } else if (date1.compare(date2 as Date) == ComparisonResult.orderedAscending){
            return 1
        } else {
            return 0
        }
    }
    
    // タイマーリストの行データを整理して返す
    internal static func rowDataFormat(data: NSManagedObject) -> [String : AnyObject] {
        var rowData: [String : AnyObject] = [:]
        
        // 基本データ変数化
        let id = data.value(forKeyPath: "id") as! String
        let title = data.value(forKeyPath: "title") as! String
        let from = data.value(forKeyPath: "from") as! NSDate
        let to = data.value(forKeyPath: "to") as! NSDate
        //let notify = data.valueForKeyPath("notify") as! NSDate
        //let repeats = data.valueForKeyPath("repeats") as! NSNumber
        
        // 基本データ
        rowData[ID] = id as AnyObject
        rowData[TITLE] = title as AnyObject
        rowData[FROM] = from
        rowData[TO] = to
        //rowData = ["notify" : notify]
        //rowData = ["repeats" : repeats]
        
        // 日付文字列
        rowData[FROM_STR] = Utility.dateString(date: from, format: "yyyy/MM/dd") as AnyObject
        rowData[TO_STR] = Utility.dateString(date: to, format: "yyyy/MM/dd") as AnyObject
        
        // 残日数文字
        rowData[COUNTDOWN_NUM] = Utility.dateDiff(interval: Utility.Interval.Day, date1: Utility.cutTime(date: NSDate()), date2: to) as AnyObject
        rowData[COUNTDOWN_NUM_STR] = to.stringForTimeIntervalSinceCreated() as AnyObject
        var countDownState: String = ""
        
        // 当日
        let calendar: NSCalendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        if (calendar.isDate(Utility.cutTime(date: NSDate()) as Date, inSameDayAs: to as Date)) {
            countDownState = Utility.TODAY
        }
        // 開始日前
        else if (0 > NSDate().timeIntervalSince(from as Date)) {
            countDownState = Utility.PREV
        }
        // 過日
        else if (0 > to.timeIntervalSince(Utility.cutTime(date: NSDate()) as Date)) {
            countDownState = Utility.TIMEOVER
        }
        // 当日まで
        else {
            countDownState = " away"
        }
        
        rowData[COUNTDOWN_STATE] = countDownState as AnyObject
        
        // 進捗バーのパーセンテージ
        let fromToSub: Double = to.timeIntervalSince(from as Date)
        let fromNowSub: Double = Utility.cutTime(date: NSDate()).timeIntervalSince(from as Date)
        let percent: Float = Float(fromNowSub / fromToSub)
        rowData[PERCENT] = percent as AnyObject
        
        return rowData
    }
    
    //UIntに16進で数値をいれるとUIColorが戻る関数
    internal static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
