//
//  ViewController.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/10/25.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import UIKit
import CoreData
import IntervalTimerKit
import iAd

class TimerListViewController: UITableViewController {
    
    // Tableで使用する配列を設定する.
    var timerlist:Array<AnyObject> = []
    var timerLists = [TimerList]()
    
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
        //let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = DataAccess.sharedInstance.managedObjectContext
        let freg = NSFetchRequest(entityName: "TimerEntity")
        freg.sortDescriptors = [NSSortDescriptor(key: "to", ascending: true)]
        
        // セルのデータを全行読み込む
        do {
            timerlist = try context.executeFetchRequest(freg)
        } catch let error as NSError {
            print(error)
        }
        
        // テーブルビューを再読込みする
        tableView.reloadData()
        
        // iAd(バナー)の自動表示
        self.canDisplayBannerAds = true
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
        //let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = DataAccess.sharedInstance.managedObjectContext
        
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
        let cell: TimerListCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TimerListCell
        
        // CoreDataから取得したデータのうち、今の行を読み込む
        let rowData: [String : AnyObject] = Utility.rowDataFormat(timerlist[indexPath.row] as! NSManagedObject)

        // カスタムセルにデータをセットする
        setTimerListData(rowData)
        cell.setCell(timerLists[indexPath.row])
        
        return cell
    }
    
    func setTimerListData (rowData: [String : AnyObject]) {
        // タイトル
        let title: String = rowData[Utility.TITLE] as! String
        
        // From
        let from: String = rowData[Utility.FROM_STR] as! String
        
        // To
        let to: String = rowData[Utility.TO_STR] as! String
        
        // 進捗バー
        let percent: Float = rowData[Utility.PERCENT] as! Float
        
        // 残日数
        var day: String = ""
        var dayColor: UIColor = Utility.UIColorFromRGB(0x008782)
        
        let countDownNumStr: String = (rowData[Utility.COUNTDOWN_NUM_STR] as? String)!
        let countDownState: String = (rowData[Utility.COUNTDOWN_STATE] as? String)!
        
        // 当日
        if (countDownState == Utility.TODAY) {
            day = countDownState
            dayColor = UIColor.redColor()
        }
        // 開始日前
        else if (countDownState == Utility.PREV) {
            day = countDownState
            dayColor = Utility.UIColorFromRGB(0x008782)
        }
        // 過日
        else if (countDownState == Utility.TIMEOVER) {
            day = countDownState
            dayColor = UIColor.grayColor()
        }
        else {
            day = countDownNumStr + countDownState
            dayColor = Utility.UIColorFromRGB(0x008782)
        }

        let timer = TimerList(title: title, day: day, dayColor: dayColor, from: from, to: to, percent: percent)
        
        timerLists.append(timer)
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

