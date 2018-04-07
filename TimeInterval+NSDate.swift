//
//  TimeInterval+NSDate.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/10/31.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import Foundation

extension NSDate {
    func stringForTimeIntervalSinceCreated() -> String {
        return stringForTimeIntervalSinceCreated(nowDate: NSDate(), isDayPrint: true)
    }
    
    func stringForTimeIntervalSinceCreated(nowDate: NSDate, isDayPrint: Bool) -> String {
        //var MinInterval  :Int = 0
        //var HourInterval :Int = 0
        let dayPrint: String = isDayPrint ? " days" : ""
        var DayInterval  :Int = 0
        var DayModules   :Int = 0
        let interval = abs(Int(self.timeIntervalSince(nowDate as Date)))
        if (interval >= 86400) {
            DayInterval = interval/86400
            DayModules = interval%86400
            if (DayModules != 0) {
                if (DayModules>=3600) {
                    //HourInterval=DayModules/3600;
                    return String(DayInterval+1) + dayPrint
                } else {
                    if (DayModules >= 60) {
                        //MinInterval=DayModules/60;
                        return String(DayInterval+1) + dayPrint
                    } else {
                        return String(DayInterval+1) + dayPrint
                    }
                }
            } else {
                return String(DayInterval) + dayPrint
            }
        } else {
            // とりあえずdaysで返す
            return "1" + dayPrint
//            if (interval >= 3600) {
//                //HourInterval = interval/3600
//                //return String(HourInterval) + " hours"
//                return "1" + dayPrint
//            } else if (interval >= 60) {
//                //MinInterval = interval/60
//                //return String(MinInterval) + " minutes"
//                return "1" + dayPrint
//            } else if (0 > interval % 60) {
//                //return String(interval) + " sec"
//                return "1" + dayPrint
//            } else {
//                return "0" + dayPrint
//            }
        }
    }
}

extension NSDate {
    func toString(format:String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let dateStr = formatter.string(from: self as Date)
        return dateStr
    }
}

extension String {
    func toDate(format:String) -> NSDate? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = formatter.date(from: self)
        return date! as NSDate
    }
}
