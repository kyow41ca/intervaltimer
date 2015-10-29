//
//  TimerEditViewController.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/10/25.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import UIKit
import CoreData

class TimerEditViewController: UITableViewController {
    
    // タイトル
    @IBOutlet weak var titleField: UITextField!
    
    // 開始日
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromPicker: UIDatePicker!
    
    // 終了日
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toPicker: UIDatePicker!
    
    // 通知時刻
    @IBOutlet weak var notifyTimeLabel: UILabel!
    @IBOutlet weak var notifyTimePicker: UIDatePicker!
    
    // くり返し
    @IBOutlet weak var repeatsSwitch: UISwitch!
    
    // 前画面からもらった編集データを格納する
    var editData : NSManagedObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // リストからもらった編集データがNULLの場合＝新規登録
        if (editData == nil) {
            // ナビゲーションバーのタイトルを設定する
            self.navigationItem.title = "タイマー追加"
            
            // FromとToのラベルのデフォルト（本日）を設定する
            fromLabel.text = format(NSDate(), style: "yyyy/MM/dd")
            toLabel.text = format(NSDate(), style: "yyyy/MM/dd")
            
            // 通知時刻のデフォルト（12:00）を設定する
            let comp = NSDateComponents()
            comp.hour = 12
            comp.minute = 0
            notifyTimeLabel.text = format(NSCalendar.currentCalendar().dateFromComponents(comp)!, style: "HH:mm")
            notifyTimePicker.date = NSCalendar.currentCalendar().dateFromComponents(comp)!
        }
        // リストからもらった編集データがNULLでない場合＝編集
        else {
            // ナビゲーションバーのタイトルを設定する
            self.navigationItem.title = "タイマー編集"
            
            // 取得したタイトルをセットする
            titleField.text = editData.valueForKeyPath("title") as? String
            
            // 取得したFromをセットする
            fromLabel.text = format(editData.valueForKeyPath("from") as! NSDate, style: "yyyy/MM/dd")
            fromPicker.setDate(editData.valueForKeyPath("from") as! NSDate, animated: false)
            
            // 取得したToをセットする
            toLabel.text = format(editData.valueForKeyPath("to") as! NSDate, style: "yyyy/MM/dd")
            toPicker.setDate(editData.valueForKeyPath("to") as! NSDate, animated: false)
            
            // 取得した通知時刻をセットする
            notifyTimeLabel.text = format(editData.valueForKeyPath("to") as! NSDate, style: "HH:mm")
            notifyTimePicker.setDate(editData.valueForKeyPath("to") as! NSDate, animated: false)
            
            // 取得したくり返しフラグをセットする
            repeatsSwitch.on = editData.valueForKeyPath("repeats") as! Bool
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Fromのセルが選択されたら
        if (indexPath.section == 0 && indexPath.row == 1) {
            fromDatePicker()
        }
        // Toのセルが選択されたら
        else if(indexPath.section == 0 && indexPath.row == 3) {
            toDatePicker()
        }
        // 通知時刻のセルが選択されたら
        else if(indexPath.section == 1 && indexPath.row == 0) {
            notifyDatePicker()
        }
        
        // セルの選択状態を解除する
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    var fromPickerHidden = true;
    var toPickerHidden = true;
    var notifyTimePickerHidden = true;
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Fromデートピッカーのセルを閉じる
        if (fromPickerHidden && indexPath.section == 0 && indexPath.row == 2) {
            return 0
        }
        // Toデートピッカーのセルを閉じる
        else if (toPickerHidden && indexPath.section == 0 && indexPath.row == 4) {
            return 0
        }
        // 通知時刻のデートピッカーのセルを閉じる
        else if (notifyTimePickerHidden && indexPath.section == 1 && indexPath.row == 1) {
            return 0
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    // Fromデートピッカー選択時処理
    func fromDatePicker() {
        // Fromデートピッカーだけを開けて後はすべて閉じる
        fromPickerHidden = !fromPickerHidden
        toPickerHidden = true
        notifyTimePickerHidden = true
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    // Toデートピッカー選択時処理
    func toDatePicker() {
        // Toデートピッカーだけを開けて後はすべて閉じる
        toPickerHidden = !toPickerHidden
        fromPickerHidden = true
        notifyTimePickerHidden = true
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // 通知時刻デートピッカー選択時処理
    func notifyDatePicker() {
        // 通知時刻デートピッカーだけを開けて後はすべて閉じる
        notifyTimePickerHidden = !notifyTimePickerHidden
        toPickerHidden = true
        fromPickerHidden = true
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // 開始日デートピッカー値変更時処理
    @IBAction func fromChanged(sender: UIDatePicker) {
        fromLabel.text = format(fromPicker.date, style: "yyyy/MM/dd")
        
        // 開始日の最低日付を更新する
        toPicker.minimumDate = fromPicker.date
        
        // 開始日と終了日の差がマイナスなら
        if (0 > toPicker.date.timeIntervalSinceDate(fromPicker.date)) {
            // 終了日ラベルを開始日と同様にする（デートピッカーは自動的に書き換わる）
            toLabel.text = format(fromPicker.date, style: "yyyy/MM/dd")
        }
    }
    
    // 終了日デートピッカー値変更時処理
    @IBAction func toChanged(sender: UIDatePicker) {
        toLabel.text = format(toPicker.date, style: "yyyy/MM/dd")
        
        // 開始日の最低日付を更新する
        toPicker.minimumDate = fromPicker.date
    }
    
    // 通知時刻デートピッカー変更時処理
    @IBAction func notifyChanged(sender: AnyObject) {
        notifyTimeLabel.text = format(notifyTimePicker.date, style: "HH:mm")
    }
    
    // 保存ボタン押下時処理
    @IBAction func save(sender: AnyObject) {
        // 編集データがない＝新規登録
        if (editData == nil) {
            createSaveData()
        }
        // 編集データがある＝編集
        else {
            editSaveData()
        }
        
        // ダイアログ表示準備
        let alertController = UIAlertController(title: "保存完了", message: "タイマーの保存が完了しました。", preferredStyle: .Alert)
        
        // OKボタンの設定（押した時にモーダルを閉じる）
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in self.closeModalDialog()}))
        
        // ダイアログを画面に表示する
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // キャンセルボタン押下時処理
    @IBAction func closeModalDialog(sender: UIBarButtonItem) {
        closeModalDialog()
    }
    
    // モーダルを閉じる
    func closeModalDialog() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // キーボードを閉じる
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    // NSDateをStringに変換する
    func format(date : NSDate, style : String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = style
        return dateFormatter.stringFromDate(date)
    }
    
    // 新規データをCoreDataにインサートする
    func createSaveData() {
        // CoreData呼び出し
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let timerContext: NSManagedObjectContext = appDel.managedObjectContext
        let timerEntity: NSEntityDescription! = NSEntityDescription.entityForName("TimerEntity", inManagedObjectContext: timerContext)
        
        // 画面から取得したデータで挿入する
        let newData = IntervalTimer.TimerEntity(entity: timerEntity!, insertIntoManagedObjectContext: timerContext)
        newData.id = NSUUID().UUIDString
        newData.title = titleField.text!.isEmpty ? "New Timer" : titleField.text
        newData.from = fromPicker.date
        newData.to = toPicker.date
        newData.notify = notifyTimePicker.date
        newData.repeats = repeatsSwitch.on
        
        do {
            try timerContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    // 編集したデータをCoreDataにアップデートする
    func editSaveData() {
        // CoreData呼び出し
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let timerContext: NSManagedObjectContext = appDel.managedObjectContext
        let timerEntity = NSEntityDescription.entityForName("TimerEntity", inManagedObjectContext: timerContext);
        
        // NSFetchRequest SQLのSelect文のようなイメージ
        let fetchRequest = NSFetchRequest();
        fetchRequest.entity = timerEntity;
        
        // NSPredicate SQLのWhere句のようなイメージ
        let predicate = NSPredicate(format: "%K = %@", "id", (editData.valueForKeyPath("id") as? String)!)
        fetchRequest.predicate = predicate
        
        do {
            // SELECTを実行して結果を取得する
            let results = try timerContext.executeFetchRequest(fetchRequest)
            
            // 画面から取得したデータで更新する
            for managedObject in results {
                let editData = managedObject as! TimerEntity;
                
                // レコードの更新処理
                editData.title = titleField.text!.isEmpty ? "New Timer" : titleField.text
                editData.from = fromPicker.date
                editData.to = toPicker.date
                editData.notify = notifyTimePicker.date
                editData.repeats = repeatsSwitch.on
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
}
