//
//  Settings.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/11/09.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import UIKit
import CoreData
import IntervalTimerKit
import iAd

class SettingsController : UITableViewController {
    
    @IBOutlet weak var appVerLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appVerLbl.text = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
        
        // iAd(バナー)の自動表示
        self.canDisplayBannerAds = true
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Fromのセルが選択されたら
        if (indexPath.section == 0 && indexPath.row == 0) {
            // Apple Watch設定画面に遷移するためのセグエを取得する
            performSegueWithIdentifier("toSettingAppleWatch", sender: nil)
        }
        
        // セルの選択状態を解除する
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
}
