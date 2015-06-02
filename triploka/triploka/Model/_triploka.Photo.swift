// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to triploka.Photo.swift instead.

import CoreData

enum triploka.PhotoAttributes: String {
    case image = "image"
}

enum triploka.PhotoRelationships: String {
    case moment = "moment"
}

@objc
class _triploka.Photo: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Photo"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _triploka.Photo.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var image: AnyObject?

    // func validateImage(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var moment: triploka.Moment?

    // func validateMoment(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

}

