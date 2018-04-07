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
        appVerLbl.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Fromのセルが選択されたら
        if (indexPath.section == 0 && indexPath.row == 0) {
            // Apple Watch設定画面に遷移するためのセグエを取得する
            performSegue(withIdentifier: "toSettingAppleWatch", sender: nil)
        }
        
        // セルの選択状態を解除する
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
}
