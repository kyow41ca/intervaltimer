//
//  TimerEntity+CoreDataProperties.swift
//  IntervalTimer
//
//  Created by YoshinagaYuuki on 2015/10/25.
//  Copyright © 2015年 Yuki Yoshinaga. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TimerEntity {

    @NSManaged var title: String?
    @NSManaged var from: NSDate?
    @NSManaged var to: NSDate?
    @NSManaged var notify: NSDate?
    @NSManaged var repeats: NSNumber?

}
