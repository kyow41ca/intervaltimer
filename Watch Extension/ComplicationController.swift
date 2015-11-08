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
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        let time = NSDate(timeIntervalSinceNow: NSTimeInterval(-60 * 60 * 48))
        handler(time)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        let time = NSDate(timeIntervalSinceNow: NSTimeInterval(60 * 60 * 48))
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
        
        //        let title: String = "tit!!"
        //        let fromStr: String = "2000/01/01"
        //        let toStr: String = "2000/01/01"
        //        let countDown: String = "326"
        //        let countDownStr: String = " days away"
        //        var cnt: String = ""
        //        let percent: Float = 0.75
        
        if (!(timer["nodata"] as! Bool)) {
            let title = timer[TITLE] as! String
            let fromStr = timer[FROM_STR] as! String
            let toStr = timer[TO_STR] as! String
            let countDownNum = timer[COUNTDOWN_NUM] as! String
            let countDownNumStr = timer[COUNTDOWN_NUM_STR] as! String
            let countDownState = timer[COUNTDOWN_STATE] as! String
            var cnt: String = ""
            let percent = timer[PERCENT] as! Float
        
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
                let entry = createTimeLineEntryMS(countDownNum, fraction: percent, date: NSDate())
                handler(entry)
            }
            else if (complication.family == .CircularSmall) {
                let entry = createTimeLineEntryCS(countDownNum, fraction: percent, date: NSDate())
                handler(entry)
            }
            else if (complication.family == .UtilitarianLarge) {
                let entry = createTimeLineEntryUL(cnt, date: NSDate())
                handler(entry)
            }
            else if (complication.family == .UtilitarianSmall) {
                let entry = createTimeLineEntryUS(countDownNum, date: NSDate())
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
//        // Call the handler with the timeline entries after to the given date
//        var timeLineEntryArray = [CLKComplicationTimelineEntry]()
//        var nextDate = NSDate(timeIntervalSinceNow: 1 * 60 * 60)
//        
//        for index in 1...3 {
//            
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "hh:mm"
//            
//            let timeString = dateFormatter.stringFromDate(nextDate)
//            
//            let entry = createTimeLineEntry(timeString, bodyText: timeLineText[index], date: nextDate)
//            
//            timeLineEntryArray.append(entry)
//            
//            nextDate = nextDate.dateByAddingTimeInterval(1 * 60 * 60)
//        }
//        handler(timeLineEntryArray)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        let nextDate = NSDate(timeIntervalSinceNow: 1 * 60 * 60)
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
            templateML.headerTextProvider = CLKSimpleTextProvider(text: "TimerTitle")
            templateML.body1TextProvider = CLKSimpleTextProvider(text: "CountDown")
            templateML.body2TextProvider = CLKSimpleTextProvider(text: "ToDate")
            
            handler(templateML)
        }
        else if (complication.family == .ModularSmall) {
            let templateMS = CLKComplicationTemplateModularSmallRingText()
            
            templateMS.textProvider = CLKSimpleTextProvider(text: "999")
            templateMS.ringStyle = CLKComplicationRingStyle(rawValue: CLKComplicationRingStyle.Open.rawValue)!
            templateMS.fillFraction = 0.5 as Float
            
            handler(templateMS)
        }
        else if (complication.family == .CircularSmall) {
            let templateCS = CLKComplicationTemplateCircularSmallRingText()
            
            templateCS.textProvider = CLKSimpleTextProvider(text: "999")
            templateCS.ringStyle = CLKComplicationRingStyle(rawValue: CLKComplicationRingStyle.Open.rawValue)!
            templateCS.fillFraction = 0.5 as Float
            
            handler(templateCS)
        }
        else if (complication.family == .UtilitarianLarge) {
            let timerImg2 = UIImage(named: "tab_timerlist_off")
            let templateUL = CLKComplicationTemplateUtilitarianLargeFlat()
            
            templateUL.imageProvider = CLKImageProvider(onePieceImage: timerImg2!)
            templateUL.textProvider = CLKSimpleTextProvider(text: "TimerTitle")
            
            handler(templateUL)
        }
        else if (complication.family == .UtilitarianSmall) {
            let timerImg3 = UIImage(named: "tab_timerlist_off")
            let templateUS = CLKComplicationTemplateUtilitarianSmallFlat()
            
            templateUS.imageProvider = CLKImageProvider(onePieceImage: timerImg3!)
            templateUS.textProvider = CLKSimpleTextProvider(text: "999")
            
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
        template.ringStyle = CLKComplicationRingStyle(rawValue: CLKComplicationRingStyle.Open.rawValue)!
        template.fillFraction = fraction
        
        let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        
        return(entry)
    }
    
    func createTimeLineEntryCS(bodyText: String, fraction: Float, date: NSDate) -> CLKComplicationTimelineEntry {
        let template = CLKComplicationTemplateCircularSmallRingText()
        
        template.textProvider = CLKSimpleTextProvider(text: bodyText)
        template.ringStyle = CLKComplicationRingStyle(rawValue: CLKComplicationRingStyle.Open.rawValue)!
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
