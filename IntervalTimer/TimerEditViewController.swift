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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        fromLabel.text = format(NSDate(), style: "yyyy/MM/dd")
        toLabel.text = format(NSDate(), style: "yyyy/MM/dd")
        
        let comp = NSDateComponents()
        comp.hour = 12
        comp.minute = 0
        notifyTimeLabel.text = format(NSCalendar.currentCalendar().dateFromComponents(comp)!, style: "HH:mm")
        notifyTimePicker.date = NSCalendar.currentCalendar().dateFromComponents(comp)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            fromDatePicker()
        }
        else if(indexPath.section == 0 && indexPath.row == 3) {
            toDatePicker()
        }
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
        if (fromPickerHidden && indexPath.section == 0 && indexPath.row == 2) {
            return 0
        }
        else if (toPickerHidden && indexPath.section == 0 && indexPath.row == 4) {
            return 0
        }
        else if (notifyTimePickerHidden && indexPath.section == 1 && indexPath.row == 1) {
            return 0
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    func fromDatePicker() {
        fromPickerHidden = !fromPickerHidden
        toPickerHidden = true
        notifyTimePickerHidden = true
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toDatePicker() {
        toPickerHidden = !toPickerHidden
        fromPickerHidden = true
        notifyTimePickerHidden = true
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func notifyDatePicker() {
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
    
    
    @IBAction func notifyChanged(sender: AnyObject) {
        notifyTimeLabel.text = format(notifyTimePicker.date, style: "HH:mm")
    }
    
    func format(date : NSDate, style : String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = style
        return dateFormatter.stringFromDate(date)
    }
    
    @IBAction func save(sender: AnyObject) {
        let alertController = UIAlertController(title: "保存完了", message: "タイマーの保存が完了しました。", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        saveData()
    }
    
    func saveData() {
        // CoreDataへの書き込み処理.
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let timerContext: NSManagedObjectContext = appDel.managedObjectContext
        
        let timerEntity: NSEntityDescription! = NSEntityDescription.entityForName("TimerEntity", inManagedObjectContext: timerContext)
        
        let newData = IntervalTimer.TimerEntity(entity: timerEntity!, insertIntoManagedObjectContext: timerContext)
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

    // MARK: - Table view data source

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
