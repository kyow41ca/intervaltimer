//
//  ComplicationController.swift
//  Watch Extension
//
//  Created by YoshinagaYuuki on 2015/11/03.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource, WKExtensionDelegate {
    
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
        handler([.Forward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        let time = NSDate()
        handler(time)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        let time = NSDate(timeIntervalSinceNow: NSTimeInterval(60 * 60 * 24 * 30))
        handler(time)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        
        let delegate: ExtensionDelegate = WKExtension.sharedExtension().delegate as! ExtensionDelegate
        let timer: [String : AnyObject] = delegate.timerlist
        
        if (!(timer["nodata"] as! Bool)) {
            let title = timer[TITLE] as! String
            let fromStr = timer[FROM_STR] as! String
            let toStr = timer[TO_STR] as! String
            var countDownNum = timer[COUNTDOWN_NUM] as! Int
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
        
            if (complication.family == .ModularLarge) {
                let entry = createTimeLineEntryML(title, body1Text: cnt, body2Text: toStr, date: NSDate())
                handler(entry)
            }
            else if (complication.family == .ModularSmall) {
                let entry = createTimeLineEntryMS(String(countDownNum), fraction: percent, date: NSDate())
                handler(entry)
            }
            else if (complication.family == .CircularSmall) {
                let entry = createTimeLineEntryCS(String(countDownNum), fraction: percent, date: NSDate())
                handler(entry)
            }
            else if (complication.family == .UtilitarianLarge) {
                let entry = createTimeLineEntryUL(cnt, date: NSDate())
                handler(entry)
            }
            else if (complication.family == .UtilitarianSmall) {
                let entry = createTimeLineEntryUS(String(countDownNum), date: NSDate())
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
        var nextDate: NSDate = dateAdd(Interval.Day, number: 1, date: cutTime(NSDate()))
        
        // データを取得する
        let delegate: ExtensionDelegate = WKExtension.sharedExtension().delegate as! ExtensionDelegate
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
                let fromToSub: Double = to.timeIntervalSinceDate(from)
                let fromNowSub: Double = nextDate.timeIntervalSinceDate(from)
                let percent: Float = 1.0 - Float(fromNowSub / fromToSub)
                
                // 次の文言を決定する
                if (0 < day) {
                    if (0 > nextDate.timeIntervalSinceDate(from)) {
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
                if (complication.family == .ModularLarge) {
                    let entry = createTimeLineEntryML(title, body1Text: dayStrs, body2Text: toStr, date: nextDate)
                    timeLineEntryArray.append(entry)
                }
                else if (complication.family == .ModularSmall) {
                    let entry = createTimeLineEntryMS(String(day), fraction: percent, date: nextDate)
                    timeLineEntryArray.append(entry)
                }
                else if (complication.family == .CircularSmall) {
                    let entry = createTimeLineEntryCS(String(day), fraction: percent, date: nextDate)
                    timeLineEntryArray.append(entry)
                }
                else if (complication.family == .UtilitarianLarge) {
                    let entry = createTimeLineEntryUL(dayStrs, date: nextDate)
                    timeLineEntryArray.append(entry)
                }
                else if (complication.family == .UtilitarianSmall) {
                    let entry = createTimeLineEntryUS(String(day), date: nextDate)
                    timeLineEntryArray.append(entry)
                }
                else {
                    handler(nil)
                }
             
                // 次の通知日時を設定
                nextDate = dateAdd(Interval.Day, number: 1, date: nextDate)
            }
            handler(timeLineEntryArray)
        }
    }
    
    // NSDateの日付だけを取り出してあとは捨てる
    func cutTime(date: NSDate) -> NSDate {
        // カレンダーを取得
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        
        // 対象の NSDate から NSDateComponents を取得
        let dateComponents = calendar.components([.Era, .Year, .Month, .Day], fromDate: date)
        
        // NSDateComponents から NSDate を生成
        return calendar.dateFromComponents(dateComponents)!
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
            //        default:
            //            comp.day = 0
        }
        return calendar.dateByAddingComponents(comp, toDate: date, options: [])!
    }
    
    // 2つの日時の間隔を整数型の値で返します
    // パラメータ
    //  interval : 日時間隔の種類を Interval で指定します
    //  date1,date2 : 間隔を計算する2つの日時を指定します
    //           date1よりdate2が前なら負の値を返します
    //
    func dateDiff(interval: Interval, date1: NSDate, date2: NSDate) -> Int {
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
            //        default:
            //            return 0
        }
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
        if (complication.family == .ModularLarge) {
            let timerImg1 = UIImage(named: "tab_timerlist_off")
            let templateML = CLKComplicationTemplateModularLargeStandardBody()
            
            templateML.headerImageProvider = CLKImageProvider(onePieceImage: timerImg1!)
            templateML.headerTextProvider = CLKSimpleTextProvider(text: "LD Timer")
            templateML.body1TextProvider = CLKSimpleTextProvider(text: "SET")
            templateML.body2TextProvider = CLKSimpleTextProvider(text: "-")
            
            handler(templateML)
        }
        else if (complication.family == .ModularSmall) {
            let templateMS = CLKComplicationTemplateModularSmallRingText()
            
            templateMS.textProvider = CLKSimpleTextProvider(text: "SET")
            templateMS.ringStyle = CLKComplicationRingStyle(rawValue: CLKComplicationRingStyle.Closed.rawValue)!
            templateMS.fillFraction = 0.5 as Float
            
            handler(templateMS)
        }
        else if (complication.family == .CircularSmall) {
            let templateCS = CLKComplicationTemplateCircularSmallRingText()
            
            templateCS.textProvider = CLKSimpleTextProvider(text: "SET")
            templateCS.ringStyle = CLKComplicationRingStyle(rawValue: CLKComplicationRingStyle.Closed.rawValue)!
            templateCS.fillFraction = 0.5 as Float
            
            handler(templateCS)
        }
        else if (complication.family == .UtilitarianLarge) {
            let timerImg2 = UIImage(named: "tab_timerlist_off")
            let templateUL = CLKComplicationTemplateUtilitarianLargeFlat()
            
            templateUL.imageProvider = CLKImageProvider(onePieceImage: timerImg2!)
            templateUL.textProvider = CLKSimpleTextProvider(text: "SET")
            
            handler(templateUL)
        }
        else if (complication.family == .UtilitarianSmall) {
            let timerImg3 = UIImage(named: "tab_timerlist_off")
            let templateUS = CLKComplicationTemplateUtilitarianSmallFlat()
            
            templateUS.imageProvider = CLKImageProvider(onePieceImage: timerImg3!)
            templateUS.textProvider = CLKSimpleTextProvider(text: "SET")
            
            handler(templateUS)
        }
        else {
            handler(nil)
        }
    }
    
    func createTimeLineEntryML(headerText: String, body1Text: String, body2Text: String, date: NSDate) -> CLKComplicationTimelineEntry {
        let timerImg = UIImage(named: "tab_timerlist_off")
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        template.headerImageProvider = CLKImageProvider(onePieceImage: timerImg!)
        template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
        template.body1TextProvider = CLKSimpleTextProvider(text: body1Text)
        template.body2TextProvider = CLKSimpleTextProvider(text: "〜" + body2Text)
        
        let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        
        return(entry)
    }
    
    func createTimeLineEntryMS(bodyText: String, fraction: Float, date: NSDate) -> CLKComplicationTimelineEntry {
        let template = CLKComplicationTemplateModularSmallRingText()
        
        template.textProvider = CLKSimpleTextProvider(text: bodyText)
        template.ringStyle = CLKComplicationRingStyle(rawValue: CLKComplicationRingStyle.Closed.rawValue)!
        template.fillFraction = fraction
        
        let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        
        return(entry)
    }
    
    func createTimeLineEntryCS(bodyText: String, fraction: Float, date: NSDate) -> CLKComplicationTimelineEntry {
        let template = CLKComplicationTemplateCircularSmallRingText()
        
        template.textProvider = CLKSimpleTextProvider(text: bodyText)
        template.ringStyle = CLKComplicationRingStyle(rawValue: CLKComplicationRingStyle.Closed.rawValue)!
        template.fillFraction = fraction
        
        let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        
        return(entry)
    }
    
    func createTimeLineEntryUL(bodyText: String, date: NSDate) -> CLKComplicationTimelineEntry {
        let timerImg = UIImage(named: "tab_timerlist_off")
        let template = CLKComplicationTemplateUtilitarianLargeFlat()
        
        template.imageProvider = CLKImageProvider(onePieceImage: timerImg!)
        template.textProvider = CLKSimpleTextProvider(text: bodyText)
        
        let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        
        return(entry)
    }
    
    func createTimeLineEntryUS(bodyText: String, date: NSDate) -> CLKComplicationTimelineEntry {
        let timerImg = UIImage(named: "tab_timerlist_off")
        let template = CLKComplicationTemplateUtilitarianSmallFlat()
        
        template.imageProvider = CLKImageProvider(onePieceImage: timerImg!)
        template.textProvider = CLKSimpleTextProvider(text: bodyText)
        
        let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        
        return(entry)
    }
    
}
