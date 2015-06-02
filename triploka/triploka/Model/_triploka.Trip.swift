// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to triploka.Trip.swift instead.

import CoreData

enum triploka.TripAttributes: String {
    case beginDate = "beginDate"
    case destination = "destination"
    case endDate = "endDate"
    case presentationImage = "presentationImage"
}

enum triploka.TripRelationships: String {
    case moments = "moments"
}

@objc
class _triploka.Trip: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Trip"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _triploka.Trip.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var beginDate: NSDate?

    // func validateBeginDate(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var destination: String?

    // func validateDestination(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var endDate: NSDate?

    // func validateEndDate(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var presentationImage: AnyObject?

    // func validatePresentationImage(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var moments: NSSet

}

extension _triploka.Trip {

    func addMoments(objects: NSSet) {
        let mutable = self.moments.mutableCopy() as NSMutableSet
        mutable.unionSet(objects)
        self.moments = mutable.copy() as NSSet
    }

    func removeMoments(objects: NSSet) {
        let mutable = self.moments.mutableCopy() as NSMutableSet
        mutable.minusSet(objects)
        self.moments = mutable.copy() as NSSet
    }

    func addMomentsObject(value: triploka.Moment!) {
        let mutable = self.moments.mutableCopy() as NSMutableSet
        mutable.addObject(value)
        self.moments = mutable.copy() as NSSet
    }

    func removeMomentsObject(value: triploka.Moment!) {
        let mutable = self.moments.mutableCopy() as NSMutableSet
        mutable.removeObject(value)
        self.moments = mutable.copy() as NSSet
    }

}
