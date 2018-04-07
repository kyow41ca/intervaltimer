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
    let userDefaults = UserDefaults.standard
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // セルを保持しておく
    var currentCell: UITableViewCell = UITableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // CoreData呼び出し
        let context : NSManagedObjectContext = DataAccess.sharedInstance.managedObjectContext
        let freg = NSFetchRequest<NSFetchRequestResult>(entityName: "TimerEntity")
        freg.sortDescriptors = [NSSortDescriptor(key: "to", ascending: true)]
        
        // セルのデータを全行読み込む
        do {
            timerlist = try context.fetch(freg) as Array<AnyObject>
        } catch let error as NSError {
            print(error)
        }
        
        // テーブルビューを再読込みする
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 今のセルのチェックを外す
        currentCell.accessoryType = UITableViewCellAccessoryType.none
        
        // チェックをつける
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        cell.accessoryType = UITableViewCellAccessoryType.checkmark
        
        // セルの選択状態を解除する
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        // データを読み込む
        let rowData: [String : AnyObject] = Utility.rowDataFormat(data: timerlist[indexPath.row] as! NSManagedObject)
        let id: String = rowData[Utility.ID] as! String
        let _: String = rowData[Utility.TITLE] as! String
        
        // NSUSerDefaultsにApple Watch表示用idを保持する
        userDefaults.set(id, forKey: "WatchViewID")
        userDefaults.synchronize()
        
        // AppDelegateの値を更新する
        appDel.watchViewID = id
        
        // ダイアログ表示準備
        let alertController = UIAlertController(
            title: NSLocalizedString("settingWatchViewSaveDialogTitle", comment: ""),
            message: NSLocalizedString("settingWatchViewSaveDialogMessage", comment: ""),
            preferredStyle: .alert
        )
        
        // OKボタンの設定（押した時にモーダルを閉じる）
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.closeModalDialog() }))
        
        // ダイアログを画面に表示する
        present(alertController, animated: true, completion: nil)
    }
    
    // セルの行数を指定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerlist.count
    }
    
    // セルの値を設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの情報を取得する
        let cell: WatchSettingListCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! WatchSettingListCell
        
        // CoreDataから取得したデータのうち、今の行を読み込む
        let rowData: [String : AnyObject] = Utility.rowDataFormat(data: timerlist[indexPath.row] as! NSManagedObject)
        
        // カスタムセルにデータをセットする
        setTimerListData(rowData: rowData)
        cell.setCell(timerlist: timerLists[indexPath.row])
        
        // フラグが立っているものにチェックをつける
        let id: String = rowData[Utility.ID] as! String
        
        if (id == appDel.watchViewID) {
            currentCell = cell
            currentCell.accessoryType = UITableViewCellAccessoryType.checkmark
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
    
    @IBAction func closeModalDialog(_ sender: UIBarButtonItem) {
        closeModalDialog()
    }
    
    // モーダルを閉じる
    func closeModalDialog() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
