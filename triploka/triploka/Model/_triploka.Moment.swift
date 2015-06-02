// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to triploka.Moment.swift instead.

import CoreData

enum triploka.MomentAttributes: String {
    case category = "category"
    case comment = "comment"
    case geoTag = "geoTag"
    case index = "index"
}

enum triploka.MomentRelationships: String {
    case photoAlbum = "photoAlbum"
    case trip = "trip"
}

@objc
class _triploka.Moment: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Moment"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _triploka.Moment.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var category: NSNumber?

    // func validateCategory(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var comment: String?

    // func validateComment(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var geoTag: AnyObject?

    // func validateGeoTag(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var index: NSNumber?

    // func validateIndex(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var photoAlbum: NSSet

    @NSManaged
    var trip: triploka.Trip?

    // func validateTrip(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

}

extension _triploka.Moment {

    func addPhotoAlbum(objects: NSSet) {
        let mutable = self.photoAlbum.mutableCopy() as NSMutableSet
        mutable.unionSet(objects)
        self.photoAlbum = mutable.copy() as NSSet
    }

    func removePhotoAlbum(objects: NSSet) {
        let mutable = self.photoAlbum.mutableCopy() as NSMutableSet
        mutable.minusSet(objects)
        self.photoAlbum = mutable.copy() as NSSet
    }

    func addPhotoAlbumObject(value: triploka.Photo!) {
        let mutable = self.photoAlbum.mutableCopy() as NSMutableSet
        mutable.addObject(value)
        self.photoAlbum = mutable.copy() as NSSet
    }

    func removePhotoAlbumObject(value: triploka.Photo!) {
        let mutable = self.photoAlbum.mutableCopy() as NSMutableSet
        mutable.removeObject(value)
        self.photoAlbum = mutable.copy() as NSSet
    }

}
