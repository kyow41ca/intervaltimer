//
//  TimerListCell.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/11/12.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import UIKit

class TimerListCell: UITableViewCell {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var dayLbl: UILabel!
    @IBOutlet var fromLbl: UILabel!
    @IBOutlet var toLbl: UILabel!
    @IBOutlet var percentProg: UIProgressView!
    
    func setCell(timerlist: TimerList) {
        self.titleLbl.text = timerlist.title
        self.dayLbl.text = timerlist.day
        self.dayLbl.textColor = timerlist.dayColor
        self.fromLbl.text = timerlist.from
        self.toLbl.text = timerlist.to
        self.percentProg.progress = timerlist.percent
    }
    
}