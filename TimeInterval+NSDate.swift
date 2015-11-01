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
        return stringForTimeIntervalSinceCreated(nowDate:NSDate())
    }
    
    func stringForTimeIntervalSinceCreated(nowDate nowDate:NSDate) -> String {
        var MinInterval  :Int = 0
        var HourInterval :Int = 0
        var DayInterval  :Int = 0
        var DayModules   :Int = 0
        let interval = abs(Int(self.timeIntervalSinceDate(nowDate)))
        if (interval >= 86400) {
            DayInterval = interval/86400
            DayModules = interval%86400
            if (DayModules != 0) {
                if (DayModules>=3600) {
                    //HourInterval=DayModules/3600;
                    return String(DayInterval) + " days"
                } else {
                    if (DayModules >= 60) {
                        //MinInterval=DayModules/60;
                        return String(DayInterval) + " days"
                    } else {
                        return String(DayInterval) + " days"
                    }
                }
            } else {
                return String(DayInterval) + " days"
            }
        } else {
            // とりあえず1daysを返す
            return "1 days"
//            if (interval >= 3600) {
//                HourInterval = interval/3600
//                return String(HourInterval) + " hours"
//            } else if (interval >= 60) {
//                MinInterval = interval/60
//                return String(MinInterval) + " minutes"
//            } else {
//                return String(interval) + " sec"
//            }
        }
    }
}

extension NSDate {
    func toString(format format:String) -> String? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        let dateStr = formatter.stringFromDate(self)
        return dateStr
    }
}

extension String {
    func toDate(format format:String) -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        let date = formatter.dateFromString(self)
        return date
    }
}