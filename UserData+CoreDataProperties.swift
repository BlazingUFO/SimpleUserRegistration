//
//  UserData+CoreDataProperties.swift
//  SimpleUserRegistration
//
//  Created by Peter Zeman on 28.6.17.
//  Copyright © 2017 Procus s.r.o. All rights reserved.
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var id: String?
    @NSManaged public var birthday: String?
    @NSManaged public var lattitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var surname: String?
    @NSManaged public var time: String?

}
