//
//  SettiingAppleWatch.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/11/09.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import UIKit
import CoreData
import IntervalTimerKit
import iAd

class SettiingAppleWatchController : UITableViewController {
    
    // Tableで使用する配列を設定する.
    var timerlist: Array<AnyObject> = []
    var timerLists = [WatchSettingList]()
    
    // NSUserDefaults のインスタンス
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {        
        // CoreData呼び出し
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
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // チェックをつける
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        // セルの選択状態を解除する
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // データを読み込む
        let rowData: [String : AnyObject] = Utility.rowDataFormat(timerlist[indexPath.row] as! NSManagedObject)
        let id: String = rowData[Utility.ID] as! String
        let title: String = rowData[Utility.TITLE] as! String

        // NSUSerDefaultsにApple Watch表示用idを保持する
        userDefaults.setObject(id, forKey: "WatchViewID")
        userDefaults.synchronize()
        
        // AppDelegateの値を更新する
        appDel.watchViewID = id
        
        // ダイアログ表示準備
        let alertController = UIAlertController(title: "設定完了", message: title + "のApple Watchの表示設定が完了しました。", preferredStyle: .Alert)
        
        // OKボタンの設定（押した時にモーダルを閉じる）
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in self.closeModalDialog() }))
        
        // ダイアログを画面に表示する
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // セルの行数を指定
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerlist.count
    }
    
    // セルの値を設定
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルの情報を取得する
        let cell: WatchSettingListCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! WatchSettingListCell
        
        // CoreDataから取得したデータのうち、今の行を読み込む
        let rowData: [String : AnyObject] = Utility.rowDataFormat(timerlist[indexPath.row] as! NSManagedObject)

        // カスタムセルにデータをセットする
        setTimerListData(rowData)
        cell.setCell(timerLists[indexPath.row])
        
        // フラグが立っているものにチェックをつける
        let id: String = rowData[Utility.ID] as! String

        if (id == appDel.watchViewID) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }
    
    func setTimerListData (rowData: [String : AnyObject]) {
        var title: String = rowData[Utility.TITLE] as! String
        let from: String = rowData[Utility.FROM_STR] as! String
        let to: String = rowData[Utility.TO_STR] as! String
        
        // タイトル（From〜To）
        title = title + "　(" + from + "〜" + to + ")"
        let timer = WatchSettingList(title: title)
        
        timerLists.append(timer)
    }
    
    @IBAction func closeModalDialog(sender: UIBarButtonItem) {
        closeModalDialog()
    }
    
    // モーダルを閉じる
    func closeModalDialog() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
