//
//  Photo.swift
//  ImageViewer
//
//  Created by Pasan Premaratne on 9/26/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import CoreData
import UIKit

//Managed Object subclass
public class Photo: NSManagedObject {
    @NSManaged public var imageData: NSData
    @NSManaged public var creationDate: NSDate
    @NSManaged public var caption: String?
    @NSManaged public var tags: Set<Tag>        //Relationship is modeled as a property!
}

extension Photo {
    static var entityName: String {
        return String(describing: Photo.self)
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    class func with(_ image: UIImage, in context: NSManagedObjectContext) -> Photo {
        let photo = NSEntityDescription.insertNewObject(forEntityName: Photo.entityName, into: context) as! Photo
        photo.creationDate = Date() as NSDate
        photo.imageData = UIImageJPEGRepresentation(image, 1.0)! as NSData
        return photo
    }
}

extension Photo {
    var image: UIImage {
        return UIImage(data: self.imageData as Data)!
    }
}
