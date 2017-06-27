//
//  Home+CoreDataProperties.swift
//  
//
//  Created by 王新克 on 2017/6/26.
//
//

import Foundation
import CoreData


extension Home {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Home> {
        return NSFetchRequest<Home>(entityName: "Home")
    }

    @NSManaged public var title: String?
    @NSManaged public var replyCount: String?
    @NSManaged public var imgsrc: String?
    @NSManaged public var source: String?
    @NSManaged public var ptime: NSDate??

}
