//
//  Tag+CoreDataProperties.swift
//  ImageViewer
//
//  Created by Gavin Butler on 06-11-2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        let request = NSFetchRequest<Tag>(entityName: "Tag")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var name: String?
    @NSManaged public var photos: Set<Photo>

}

extension Tag {

    static var entityName: String {
        return String(describing: Tag.self)
    }
    
    @nonobjc class func withName(_ name: String, in context: NSManagedObjectContext) -> Tag {
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", name)
        request.predicate = predicate
        
        if let tag = try! context.fetch(request).first {
            return tag
        } else {
            let tag = NSEntityDescription.insertNewObject(forEntityName: Tag.entityName, into: context) as! Tag
            tag.name = name
            tag.photos = []
            return tag
        }
    }

}
