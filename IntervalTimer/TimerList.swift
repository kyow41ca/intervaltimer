//
//  TimerList.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/11/12.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import Foundation
import UIKit

class TimerList : NSObject {
    var id: String
    var title: String
    var day: String
    var dayColor: UIColor
    var from: String
    var to: String
    var percent: Float
    
    init(id: String, title: String, day: String, dayColor:UIColor, from: String, to: String, percent: Float){
        self.id = id
        self.title = title
        self.day = day
        self.dayColor = dayColor
        self.from = from
        self.to = to
        self.percent = percent
    }
}