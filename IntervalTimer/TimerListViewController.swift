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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    }
    
    @IBAction func tapEdit(sender: AnyObject) {
        if editing {
            super.setEditing(false, animated: true)
            tableView.setEditing(false, animated: true)
        } else {
            super.setEditing(true, animated: true)
            tableView.setEditing(true, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            context.deleteObject(timerlist[indexPath.row] as! NSManagedObject)
            timerlist.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        // TableViewを再読み込み.
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // viewDidLoadは最初の一回しか呼ばれないので、viewWillAppearを使うよ
    override func viewWillAppear(animated: Bool) {
        
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        let freg = NSFetchRequest(entityName: "TimerEntity")
        
        do {
            timerlist = try context.executeFetchRequest(freg)
        } catch let error as NSError {
            print(error)
        }
        
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // セルの選択状態を解除する
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    // セルの行数を指定
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerlist.count
    }
    
    // セルの値を設定
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let data : NSManagedObject = timerlist[indexPath.row] as! NSManagedObject
        
        let title = data.valueForKeyPath("title") as! String
        let from = data.valueForKeyPath("from") as! NSDate
        let to = data.valueForKeyPath("to") as! NSDate
        let notify = data.valueForKeyPath("notify") as! NSDate
        let repeats = data.valueForKeyPath("repeats") as! NSNumber

        let lbl1 = tableView.viewWithTag(1) as! UILabel
        lbl1.text = title

        let lbl2 = tableView.viewWithTag(2) as! UILabel
        lbl2.text = dateString(from, format: "yyyy/MM/dd")
        
        let lbl3 = tableView.viewWithTag(3) as! UILabel
        lbl3.text = dateString(to, format: "yyyy/MM/dd")
        
        //let lbl5 = tableView.viewWithTag(5) as! UILabel
        //lbl5.text = dateString(String("\(from.timeIntervalSinceDate(to))"), format: "yyyy/MM/dd")
        
        return cell
    }
    
    private func dateString(date: NSDate, format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = format
        let dateString: String = dateFormatter.stringFromDate(date)
        return dateString
    }


}

