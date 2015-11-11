//
//  WatchListCell.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/11/12.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import UIKit

class WatchSettingListCell: UITableViewCell {
    
    @IBOutlet var titleLbl: UILabel!
    
    func setCell(timerlist: WatchSettingList) {
        self.titleLbl.text = timerlist.title
    }
    
}