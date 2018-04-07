//
//  TimerEditViewController.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/10/25.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//

import UIKit
import CoreData
import IntervalTimerKit
import iAd

class TimerEditViewController: UITableViewController, UITextFieldDelegate {
    
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
    //@IBOutlet weak var repeatsSwitch: UISwitch!
    
    // 前画面からもらった編集データを格納する
    var editData : NSManagedObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textField の情報を受け取るための delegate を設定
        titleField.delegate = self
        
        // リストからもらった編集データがNULLの場合＝新規登録
        if (editData == nil) {
            // ナビゲーションバーのタイトルを設定する
            self.navigationItem.title = NSLocalizedString("editViewNaviAdd", comment: "")
            
            // FromとToのラベルのデフォルト（本日）を設定する
            fromLabel.text = format(date: NSDate(), style: "yyyy/MM/dd")
            toLabel.text = format(date: NSDate(), style: "yyyy/MM/dd")
            
            // 通知時刻のデフォルト（12:00）を設定する
            let comp = NSDateComponents()
            comp.hour = 12
            comp.minute = 0
            //notifyTimeLabel.text = format(date: comp.date! as NSDate, style: "HH:mm")
            //notifyTimePicker.date = (comp.date! as NSDate) as Date
        }
        // リストからもらった編集データがNULLでない場合＝編集
        else {
            // ナビゲーションバーのタイトルを設定する
            self.navigationItem.title = NSLocalizedString("editViewNaviEdit", comment: "")
            
            // 取得したタイトルをセットする
            titleField.text = editData.value(forKeyPath: "title") as? String
            
            // 取得したFromとtoをセットする
            var fromDate: NSDate = editData.value(forKeyPath: "from") as! NSDate
            var toDate: NSDate = editData.value(forKeyPath: "to") as! NSDate

            // タイマーが時間切れなら新しい日付をセットしなおす
            // （期限切れの日にfrom、期限切れの日から前の設定日時のfrom-toの日数が経過した日にtoをセットしておく）
            if (-1 == Utility.dateCompare(date1: NSDate(), date2: toDate)) {
                let interval = Utility.dateDiff(interval: Utility.Interval.Day, date1: fromDate, date2: toDate)
                fromDate = Utility.dateAdd(interval: Utility.Interval.Day, number: interval, date: fromDate)
                toDate = Utility.dateAdd(interval: Utility.Interval.Day, number: interval, date: toDate)
            }
            
            fromLabel.text = format(date: fromDate, style: "yyyy/MM/dd")
            fromPicker.setDate(fromDate as Date, animated: false)

            toLabel.text = format(date: toDate, style: "yyyy/MM/dd")
            toPicker.setDate(toDate as Date, animated: false)
            
            // 取得した通知時刻をセットする
            let notifyDate: NSDate = editData.value(forKeyPath: "notify") as! NSDate
            notifyTimeLabel.text = format(date: notifyDate, style: "HH:mm")
            notifyTimePicker.setDate(notifyDate as Date, animated: false)
            
            // 取得したくり返しフラグをセットする
            //repeatsSwitch.on = editData.valueForKeyPath("repeats") as! Bool
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    var fromPickerHidden = true;
    var toPickerHidden = true;
    var notifyTimePickerHidden = true;
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        
        return super.tableView(tableView, heightForRowAt: indexPath)
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
    @IBAction func fromChanged(_ sender: UIDatePicker) {
        fromLabel.text = format(date: fromPicker.date as NSDate, style: "yyyy/MM/dd")
        
        // 開始日の最低日付を更新する
        toPicker.minimumDate = fromPicker.date
        
        // 開始日と終了日の差がマイナスなら
        if (0 > toPicker.date.timeIntervalSince(fromPicker.date)) {
            // 終了日ラベルを開始日と同様にする（デートピッカーは自動的に書き換わる）
            toLabel.text = format(date: fromPicker.date as NSDate, style: "yyyy/MM/dd")
        }
    }
    
    // 終了日デートピッカー値変更時処理
    @IBAction func toChanged(_ sender: UIDatePicker) {
        toLabel.text = format(date: toPicker.date as NSDate, style: "yyyy/MM/dd")
        
        // 開始日の最低日付を更新する
        toPicker.minimumDate = fromPicker.date
    }
    
    // 通知時刻デートピッカー変更時処理
    @IBAction func notifyChanged(_ sender: AnyObject) {
        notifyTimeLabel.text = format(date: notifyTimePicker.date as NSDate, style: "HH:mm")
    }
    
    // 保存ボタン押下時処理
    @IBAction func save(_ sender: AnyObject) {
        // 編集データがない＝新規登録
        if (editData == nil) {
            createSaveData()
        }
        // 編集データがある＝編集
        else {
            editSaveData()
        }
        
        // ダイアログ表示準備
        let alertController = UIAlertController(
            title: NSLocalizedString("editViewSaveDialogTitle", comment: ""),
            message: NSLocalizedString("editViewSaveDialogMessage", comment: ""),
            preferredStyle: .alert
        )
        
        // OKボタンの設定（押した時にモーダルを閉じる）
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.closeModalDialog() }))
        
        // ダイアログを画面に表示する
        present(alertController, animated: true, completion: nil)
    }
    
    // キャンセルボタン押下時処理
    @IBAction func closeModalDialog(_ sender: UIBarButtonItem) {
        closeModalDialog()
    }
    
    // モーダルを閉じる
    func closeModalDialog() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // キーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    // NSDateをStringに変換する
    func format(date : NSDate, style : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = style
        return dateFormatter.string(from: date as Date)
    }
    
    // 新規データをCoreDataにインサートする
    func createSaveData() {
        // CoreData呼び出し
        //let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let timerContext: NSManagedObjectContext = DataAccess.sharedInstance.managedObjectContext
        let timerEntity: NSEntityDescription! = NSEntityDescription.entity(forEntityName: "TimerEntity", in: timerContext)
        
        // 画面から取得したデータで挿入する
        let newData = IntervalTimer.TimerEntity(entity: timerEntity!, insertInto: timerContext)
        newData.id = NSUUID().uuidString
        newData.title = titleField.text!.isEmpty ? "New Timer" : titleField.text
        newData.from = Utility.cutTime(date: fromPicker.date as NSDate)
        newData.to = Utility.cutTime(date: toPicker.date as NSDate)
        newData.notify = Utility.createNotifyTime(toDate: newData.to!, notifyDate: notifyTimePicker.date as NSDate)
        //newData.repeats = repeatsSwitch.on
        newData.repeats = false // 繰り返し機能はつけないが、カラムは残しておくためすべてfalseにしておく
        
        do {
            try timerContext.save()
        } catch let error as NSError {
            print(error)
        }
        
        // 通知時刻を過ぎていない場合だけ、通知センターに登録する
        if (0 < newData.notify!.timeIntervalSince(NSDate() as Date)) {
            NotifyUtils.addNotifycation(data: newData)
        }
    }
    
    // 編集したデータをCoreDataにアップデートする
    func editSaveData() {
        // CoreData呼び出し
        //let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let timerContext: NSManagedObjectContext = DataAccess.sharedInstance.managedObjectContext
        let timerEntity = NSEntityDescription.entity(forEntityName: "TimerEntity", in: timerContext);
        
        // NSFetchRequest SQLのSelect文のようなイメージ
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>();
        fetchRequest.entity = timerEntity;
        
        // NSPredicate SQLのWhere句のようなイメージ
        let predicate = NSPredicate(format: "%K = %@", "id", (editData.value(forKeyPath: "id") as? String)!)
        fetchRequest.predicate = predicate
        
        do {
            // SELECTを実行して結果を取得する
            let results = try timerContext.fetch(fetchRequest)
            
            // 画面から取得したデータで更新する
            for managedObject in results {
                let editData = managedObject as! TimerEntity;
                
                // レコードの更新処理
                editData.title = titleField.text!.isEmpty ? "New Timer" : titleField.text
                editData.from = Utility.cutTime(date: fromPicker.date as NSDate)
                editData.to = Utility.cutTime(date: toPicker.date as NSDate)
                editData.notify = Utility.createNotifyTime(toDate: editData.to!, notifyDate: notifyTimePicker.date as NSDate)
                //newData.repeats = repeatsSwitch.on
                editData.repeats = false // 繰り返し機能はつけないが、カラムは残しておくためすべてfalseにしておく
                
                // もともとの通知センターをキャンセルする
                NotifyUtils.cancelNotifycation(notifyId: editData.id!)
                
                // 通知時刻を過ぎていない場合だけ、通知センターに登録する
                if (0 < editData.notify!.timeIntervalSince(NSDate() as Date)) {
                    NotifyUtils.addNotifycation(data: editData)
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
}
