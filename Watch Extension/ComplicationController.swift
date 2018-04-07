//
//  ComplicationController.swift
//  Watch Extension
//
//  Created by YoshinagaYuuki on 2015/11/03.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import Foundation
import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource, WKExtensionDelegate {
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        
    }
    
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
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        let time = NSDate()
        handler(time)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        let time = NSDate(timeIntervalSinceNow: TimeInterval(60 * 60 * 24 * 30))
        handler(time)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        
        let delegate: ExtensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        let timer: [String : AnyObject] = delegate.timerlist as [String : AnyObject]
        
        if (!(timer["nodata"] as! Bool)) {
            let title = timer[TITLE] as! String
            _ = timer[FROM_STR] as! String
            let toStr = timer[TO_STR] as! String
            let countDownNum = timer[COUNTDOWN_NUM] as! Int
            let countDownNumStr = timer[COUNTDOWN_NUM_STR] as! String
            let countDownState = timer[COUNTDOWN_STATE] as! String
            var cnt: String = ""
            let percent = (1.0 as Float) - (timer[PERCENT] as! Float)
        
            // 当日
            if (countDownState == self.TODAY) {
                cnt = countDownState
            }
            // 開始日前
            else if (countDownState == self.PREV) {
                cnt = countDownState
            }
            // 過日
            else if (countDownState == self.TIMEOVER) {
                cnt = countDownState
            }
            else {
                cnt = countDownNumStr + countDownState
            }
        
            if (complication.family == .modularLarge) {
                let entry = createTimeLineEntryML(headerText: title, body1Text: cnt, body2Text: toStr, date: NSDate())
                handler(entry)
            }
            else if (complication.family == .modularSmall) {
                let entry = createTimeLineEntryMS(bodyText: String(countDownNum), fraction: percent, date: NSDate())
                handler(entry)
            }
            else if (complication.family == .circularSmall) {
                let entry = createTimeLineEntryCS(bodyText: String(countDownNum), fraction: percent, date: NSDate())
                handler(entry)
            }
            else if (complication.family == .utilitarianLarge) {
                let entry = createTimeLineEntryUL(bodyText: cnt, date: NSDate())
                handler(entry)
            }
            else if (complication.family == .utilitarianSmall) {
                let entry = createTimeLineEntryUS(bodyText: String(countDownNum), date: NSDate())
                handler(entry)
            }
            else {
                handler(nil)
            }
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        var timeLineEntryArray = [CLKComplicationTimelineEntry]()
        
        // 次の通知日時を設定
        var nextDate: NSDate = dateAdd(interval: Interval.Day, number: 1, date: cutTime(date: NSDate()))
        
        // データを取得する
        let delegate: ExtensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        let timer: [String : AnyObject] = delegate.timerlist
        
        if (!(timer["nodata"] as! Bool)) {
            let title: String = timer[TITLE] as! String
            //let fromStr = timer[FROM_STR] as! String
            let toStr: String = timer[TO_STR] as! String
            let from: NSDate = timer[FROM] as! NSDate
            let to: NSDate = timer[TO] as! NSDate
            let countDownNum: Int = timer[COUNTDOWN_NUM] as! Int
            //let countDownNumStr = timer[COUNTDOWN_NUM_STR] as! String
            //let countDownState = timer[COUNTDOWN_STATE] as! String
            //var cnt: String = ""
            //let percent = (1.0 as Float) - (timer[PERCENT] as! Float)
            
            // 翌日と翌々日のデータを作成する
            var day: Int = countDownNum
            var dayStrs: String = ""
            
            for _ in 1...30 {
                // 今日の日付からnumを引く＝その日の残り日数
                day = day - 1
                
                // 進捗バーのパーセンテージ
                let fromToSub: Double = to.timeIntervalSince(from as Date)
                let fromNowSub: Double = nextDate.timeIntervalSince(from as Date)
                let percent: Float = 1.0 - Float(fromNowSub / fromToSub)
                
                // 次の文言を決定する
                if (0 < day) {
                    if (0 > nextDate.timeIntervalSince(from as Date)) {
                        dayStrs = self.PREV
                    }
                    else {
                        dayStrs = String(day) + " days away"
                    }
                }
                else if (0 == day) {
                    dayStrs = self.TODAY
                }
                else if (0 > day) {
                    dayStrs = self.TIMEOVER
                }
                
                // コンプリケーション設定
                if (complication.family == .modularLarge) {
                    let entry = createTimeLineEntryML(headerText: title, body1Text: dayStrs, body2Text: toStr, date: nextDate)
                    timeLineEntryArray.append(entry)
                }
                else if (complication.family == .modularSmall) {
                    let entry = createTimeLineEntryMS(bodyText: String(day), fraction: percent, date: nextDate)
                    timeLineEntryArray.append(entry)
                }
                else if (complication.family == .circularSmall) {
                    let entry = createTimeLineEntryCS(bodyText: String(day), fraction: percent, date: nextDate)
                    timeLineEntryArray.append(entry)
                }
                else if (complication.family == .utilitarianLarge) {
                    let entry = createTimeLineEntryUL(bodyText: dayStrs, date: nextDate)
                    timeLineEntryArray.append(entry)
                }
                else if (complication.family == .utilitarianSmall) {
                    let entry = createTimeLineEntryUS(bodyText: String(day), date: nextDate)
                    timeLineEntryArray.append(entry)
                }
                else {
                    handler(nil)
                }
             
                // 次の通知日時を設定
                nextDate = dateAdd(interval: Interval.Day, number: 1, date: nextDate)
            }
            handler(timeLineEntryArray)
        }
    }
    
    // NSDateの日付だけを取り出してあとは捨てる
    func cutTime(date: NSDate) -> NSDate {
        // カレンダーを取得
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        // 対象の NSDate から NSDateComponents を取得
        let dateComponents = calendar.components([.era, .year, .month, .day], from: date as Date)
        
        // NSDateComponents から NSDate を生成
        return calendar.date(from: dateComponents)! as NSDate
    }
    
    // 日時間隔の列挙体
    enum Interval: String {
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
    func dateAdd(interval: Interval, number: Int, date: NSDate) -> NSDate {
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
    func dateDiff(interval: Interval, date1: NSDate, date2: NSDate) -> Int {
        /*
        let calendar = NSCalendar.current
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
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        let nextDate = NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 1)
        handler(nextDate);
    }
    
    func requestedUpdateBudgetExhausted() {
        //
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        if (complication.family == .modularLarge) {
            let templateML = CLKComplicationTemplateModularLargeStandardBody()
            
            templateML.headerTextProvider = CLKSimpleTextProvider(text: "LD Timer")
            templateML.body1TextProvider = CLKSimpleTextProvider(text: "SET")
            templateML.body2TextProvider = CLKSimpleTextProvider(text: "-")
            
            handler(templateML)
        }
        else if (complication.family == .modularSmall) {
            let templateMS = CLKComplicationTemplateModularSmallRingText()
            
            templateMS.textProvider = CLKSimpleTextProvider(text: "SET")
            templateMS.ringStyle = CLKComplicationRingStyle(rawValue: CLKComplicationRingStyle.closed.rawValue)!
            templateMS.fillFraction = 0.5 as Float
            
            handler(templateMS)
        }
        else if (complication.family == .circularSmall) {
            let templateCS = CLKComplicationTemplateCircularSmallRingText()
            
            templateCS.textProvider = CLKSimpleTextProvider(text: "SET")
            templateCS.ringStyle = CLKComplicationRingStyle(rawValue: CLKComplicationRingStyle.closed.rawValue)!
            templateCS.fillFraction = 0.5 as Float
            
            handler(templateCS)
        }
        else if (complication.family == .utilitarianLarge) {
            let templateUL = CLKComplicationTemplateUtilitarianLargeFlat()
            templateUL.textProvider = CLKSimpleTextProvider(text: "SET")
            
            handler(templateUL)
        }
        else if (complication.family == .utilitarianSmall) {
            let templateUS = CLKComplicationTemplateUtilitarianSmallFlat()            
            templateUS.textProvider = CLKSimpleTextProvider(text: "SET")
            
            handler(templateUS)
        }
        else {
            handler(nil)
        }
    }
    
    func createTimeLineEntryML(headerText: String, body1Text: String, body2Text: String, date: NSDate) -> CLKComplicationTimelineEntry {
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
        template.body1TextProvider = CLKSimpleTextProvider(text: body1Text)
        template.body2TextProvider = CLKSimpleTextProvider(text: "〜" + body2Text)
        
        let entry = CLKComplicationTimelineEntry(date: date as Date, complicationTemplate: template)
        
        return(entry)
    }
    
    func createTimeLineEntryMS(bodyText: String, fraction: Float, date: NSDate) -> CLKComplicationTimelineEntry {
        let template = CLKComplicationTemplateModularSmallRingText()
        
        template.textProvider = CLKSimpleTextProvider(text: bodyText)
        template.ringStyle = CLKComplicationRingStyle(rawValue: CLKComplicationRingStyle.closed.rawValue)!
        template.fillFraction = fraction
        
        let entry = CLKComplicationTimelineEntry(date: date as Date, complicationTemplate: template)
        
        return(entry)
    }
    
    func createTimeLineEntryCS(bodyText: String, fraction: Float, date: NSDate) -> CLKComplicationTimelineEntry {
        let template = CLKComplicationTemplateCircularSmallRingText()
        
        template.textProvider = CLKSimpleTextProvider(text: bodyText)
        template.ringStyle = CLKComplicationRingStyle(rawValue: CLKComplicationRingStyle.closed.rawValue)!
        template.fillFraction = fraction
        
        let entry = CLKComplicationTimelineEntry(date: date as Date, complicationTemplate: template)
        
        return(entry)
    }
    
    func createTimeLineEntryUL(bodyText: String, date: NSDate) -> CLKComplicationTimelineEntry {
        let template = CLKComplicationTemplateUtilitarianLargeFlat()
        template.textProvider = CLKSimpleTextProvider(text: bodyText)
        
        let entry = CLKComplicationTimelineEntry(date: date as Date, complicationTemplate: template)
        
        return(entry)
    }
    
    func createTimeLineEntryUS(bodyText: String, date: NSDate) -> CLKComplicationTimelineEntry {
        let template = CLKComplicationTemplateUtilitarianSmallFlat()
        template.textProvider = CLKSimpleTextProvider(text: bodyText)
        
        let entry = CLKComplicationTimelineEntry(date: date as Date, complicationTemplate: template)
        
        return(entry)
    }
    
}
