//
//  ViewController.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/10/25.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import UIKit
import CoreData

class TimerListViewController: UITableViewController {
    
    // Tableで使用する配列を設定する.
    var timerlist:Array<AnyObject>=[]
    
    // 編集データを編集画面に持っていくための箱
    var editData : NSManagedObject!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // セル選択時の編集データが残っていたらNULL参照する
        // ※一回編集した時に「＋」ボタンを押下すると、セグエがその情報を持って行ってしまうため
        if (editData != nil) {
            editData = nil
        }
        
        // CoreData呼び出し
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        let freg = NSFetchRequest(entityName: "TimerEntity")
        
        // セルのデータを全行読み込む
        do {
            timerlist = try context.executeFetchRequest(freg)
        } catch let error as NSError {
            print(error)
        }
        
        // テーブルビューを再読込みする
        tableView.reloadData()
    }
    
    // 編集ボタン押下時処理
    @IBAction func tapEdit(sender: AnyObject) {
        // 今編集モードなら、編集モードを解除する
        if editing {
            super.setEditing(false, animated: true)
            tableView.setEditing(false, animated: true)
        }
        // 編集モードでなければ、編集モードにする
        else {
            super.setEditing(true, animated: true)
            tableView.setEditing(true, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // CoreData呼び出し
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        // 編集モードの時に選択された行のインデックスを取得して、その行のデータを削除する
        if editingStyle == .Delete {
            // idを取得しておく
            let notifyId = timerlist[indexPath.row].valueForKeyPath("id") as! String
            
            // 削除する
            context.deleteObject(timerlist[indexPath.row] as! NSManagedObject)
            timerlist.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
            // 通知センターもキャンセルする
            NotifyUtils.cancelNotifycation(notifyId)
        }
        // インサートモード？
        else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // セルの行数を指定
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerlist.count
    }
    
    // セルの値を設定
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルの情報を取得する
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // CoreDataから取得したデータのうち、今の行を読み込む
        let data : NSManagedObject = timerlist[indexPath.row] as! NSManagedObject
        
        let title = data.valueForKeyPath("title") as! String
        let from = data.valueForKeyPath("from") as! NSDate
        let to = data.valueForKeyPath("to") as! NSDate
        //let notify = data.valueForKeyPath("notify") as! NSDate
        let repeats = data.valueForKeyPath("repeats") as! NSNumber

        // タイトル
        let lbl1 = tableView.viewWithTag(1) as! UILabel
        lbl1.text = title

        // From
        let lbl2 = tableView.viewWithTag(2) as! UILabel
        lbl2.text = Utility.dateString(from, format: "yyyy/MM/dd")
        
        // To
        let lbl3 = tableView.viewWithTag(3) as! UILabel
        lbl3.text = Utility.dateString(to, format: "yyyy/MM/dd")
        
        // 進捗バー
        let prog4 = tableView.viewWithTag(4) as! UIProgressView
        let fromToSub: Double = to.timeIntervalSinceDate(from)
        let fromNowSub: Double = Utility.cutTime(NSDate()).timeIntervalSinceDate(from)
        let percent: Float = Float(fromNowSub / fromToSub)
        prog4.progress = percent
        
        // 残日数
        let aw: String = " away"
        let lbl5 = tableView.viewWithTag(5) as! UILabel
        let calendar: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        if (calendar.isDate(to, inSameDayAsDate: from)) {
            lbl5.text = "Time Over"
        }
        else {
            lbl5.text = to.stringForTimeIntervalSinceCreated() + aw
        }
        
        let img6 = tableView.viewWithTag(6) as! UIImageView
        if (1 == repeats) {
            img6.image = UIImage(named: "RepIcon.png")
        } else {
            img6.image = UIImage(named: "UnRepIcon.png")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 押されたセルの編集データを取得する
        editData = timerlist[indexPath.row] as! NSManagedObject
        
        // 編集画面に遷移するためのセグエを取得する
        performSegueWithIdentifier("toTimerEditView", sender: nil)
        
        // セルの選択状態（タップした時の背景灰色）を解除する
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Segue 準備
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // セグエを特定する
        if (segue.identifier == "toTimerEditView") {
            // 編集データを編集画面に渡す
            let navigationController = segue.destinationViewController as! UINavigationController
            let editVc = navigationController.viewControllers[0] as! TimerEditViewController
            editVc.editData = editData
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        // 画面遷移時に編集モードだった場合には編集モードを解除する
        if editing {
            super.setEditing(false, animated: true)
            tableView.setEditing(false, animated: true)
        }
    }


}

