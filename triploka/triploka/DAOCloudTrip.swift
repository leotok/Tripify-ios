//
//  DAOCloudTrip.swift
//  chp3
//
//  Created by Jordan Rodrigues Rangel on 5/26/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit
import CloudKit

private var dao : DAOCloudTrip! = nil

class DAOCloudTrip {
    
    private var container : CKContainer
    private var privateDB : CKDatabase
    private var rootPath : String
    private var plistPath : String
    private var tempURL : NSURL!
    
    init() {
        
        container = CKContainer.defaultContainer()
        privateDB = container.privateCloudDatabase
        
        rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        
        plistPath = rootPath.stringByAppendingPathComponent("Instructions.plist")
        
        var fileManager = NSFileManager.defaultManager()
        
        let tempDirectoryStr : String! = NSTemporaryDirectory()
        
        if tempDirectoryStr == nil {
            
            var errorPointer : NSErrorPointer! = nil
            
            tempURL = fileManager.URLForDirectory(NSSearchPathDirectory.ItemReplacementDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: NSURL(fileURLWithPath: rootPath)!, create: true, error: errorPointer)
            
            if errorPointer != nil {
                
                //implementar
            }
        }
        else {
            
            tempURL = NSURL(fileURLWithPath: tempDirectoryStr.stringByAppendingPathComponent("tempPhotoAsset.jpeg"))
        }
        
        if !fileManager.fileExistsAtPath(plistPath) {
            
            var error : NSErrorPointer = nil
            let bundle = NSBundle.mainBundle().pathForResource("Instructions", ofType: "plist")
            fileManager.copyItemAtPath(bundle!, toPath: plistPath, error: error)
            
            if error != nil {
                
                println("Erro ao copiar plist para bundle")
            }
        }
    }
    
    class func getInstance() -> DAOCloudTrip {
        
        if dao == nil {
            
            dao = DAOCloudTrip()
        }
        
        return dao
    }
    
    // Checa se tem internet. Se tiver, manda atualizar o CloudKit
    
    func updateCloudKit() {
        
        NetworkStatus.checkNetworkConnection()
    }
    
    // Salva uma viagem na plist para que seja posteriormente enviada para a cloud
    
    func saveInstruction(trip: Trip) {
        
        var instructions : NSMutableArray! = NSMutableArray(contentsOfFile: plistPath)
        
        if instructions == nil {
            
            instructions = NSMutableArray(capacity: 1)
        }
        
        let newInstruction : NSMutableDictionary = NSMutableDictionary()
        
        newInstruction.setValue("Trip", forKey: "type")
        newInstruction.setValue("Save", forKey: "action")
        
        newInstruction.setValue(trip.beginDate, forKey: "beginDate")
        newInstruction.setValue(trip.endDate, forKey: "endDate")
        newInstruction.setValue(trip.destination, forKey: "destination")
        newInstruction.setValue(UIImageJPEGRepresentation(trip.getPresentationImage(), 1), forKey: "presentationImage")
        
        instructions.addObject(newInstruction)
        instructions.writeToFile(plistPath, atomically: true)
    }
    
    // Salva um momento na plist para que seja posteriormente enviada para a cloud
    
    func saveInstruction(moment: Moment) {
        
        var instructions : NSMutableArray! = NSMutableArray(contentsOfFile: plistPath)
        let trip = moment.trip!
        let photos = moment.getAllPhotos()
        
        //let newInstruction : NSMutableDictionary = NSMutableDictionary(dictionary: ["type" : "Moment", "action" : "Save", "beginDate" : trip.beginDate, "endDate" : trip.endDate, "destination" : trip.destination, "index" : moment.index!, "category" : moment.category!, "comment" : moment.comment!, "geoTag" : moment.getGeoTag(), "photosAmount" : photos.count])
        
        let newInstruction : NSMutableDictionary = NSMutableDictionary()
        
        newInstruction.setValue("Trip", forKey: "type")
        newInstruction.setValue("Save", forKey: "action")
        
        newInstruction.setValue(trip.beginDate, forKey: "beginDate")
        newInstruction.setValue(trip.endDate, forKey: "endDate")
        newInstruction.setValue(trip.destination, forKey: "destination")
        
        newInstruction.setValue(moment.index!, forKey: "index")
        newInstruction.setValue(moment.category!, forKey: "category")
        newInstruction.setValue(moment.comment!, forKey: "comment")
        newInstruction.setValue(moment.getGeoTag(), forKey: "geoTag")
        newInstruction.setValue(NSNumber(integer: photos.count), forKey: "photosAmount")
        
        if photos.count > 0 {
            
            newInstruction.setValue(self.getMomentPhotosArray(photos, isAsset: false), forKey: "photos")
        }
        
        instructions.addObject(newInstruction)
        instructions.writeToFile(plistPath, atomically: true)
    }
    
    // Lê a próxima instrução na plist para atualizar a cloud
    
    func readNextInstruction() {
        
        let instructions : NSArray! = NSArray(contentsOfFile: plistPath)
        
        if instructions != nil && instructions.count > 0 {
            
            let instruction : NSDictionary = instructions[0] as! NSDictionary
            let type : String = instruction["type"] as! String
            let action : String = instruction["action"] as! String
            
            let tripRecord: CKRecord = createTripRecord(instruction)
            
            if type == "Trip" {
                
                if action == "Delete" {
                    
                    deleteRecord(tripRecord, wasReadFromPlist: true, isTripRecord: true)
                }
                else {
                    
                    modifyTripRecord(instruction, tripRecord: tripRecord)
                    
                    if action == "Save" {
                     
                        saveRecord(tripRecord, wasReadFromPlist: true, isTripRecord: true)
                    }
                    else if action == "Update" {
                        
                        updateRecord(tripRecord, wasReadFromPlist: true, isTripRecord: true)
                    }
                }
            }
            else if action == "Moment" {
                
                let momentRecord = createMomentRecord(instruction)
                
                if action == "Delete" {
                    
                    deleteRecord(momentRecord, wasReadFromPlist: true, isTripRecord: false)
                }
                else {
                    
                    modifyMomentRecord(instruction, momentRecord: momentRecord, tripRecord: tripRecord)
                    
                    if action == "Update" {
                        
                        updateRecord(momentRecord, wasReadFromPlist: true, isTripRecord: false)
                    }
                    else if action == "Save" {
                        
                        saveRecord(momentRecord, wasReadFromPlist: true, isTripRecord: false)
                    }
                }
            }
        }
    }
    
    // Salva uma nova viagem na cloud
    
    func saveNewTrip(trip: Trip) {
        
        let tripRecord : CKRecord = createTripRecord(trip.beginDate, endDate: trip.endDate)
        
        modifyTripRecord(trip, tripRecord: tripRecord)
        saveRecord(tripRecord, wasReadFromPlist: false, isTripRecord: true)
    }
    
    func saveNewMoment(moment: Moment) {
        
        let (momentRecord, tripRecord) : (CKRecord, CKRecord) = createMomentRecord(moment)
        
        modifyMomentRecord(moment, momentRecord: momentRecord, tripRecord: tripRecord)
        saveRecord(momentRecord, wasReadFromPlist: false, isTripRecord: false)
    }
    
    // Atualiza uma viagem já existente na cloud
    
    func updateTrip(trip: Trip) {
        
        let tripRecord : CKRecord = createTripRecord(trip)
        
        modifyTripRecord(trip, tripRecord: tripRecord)
        updateRecord(tripRecord, wasReadFromPlist: false, isTripRecord: true)
    }
    
    func updateMoment(moment: Moment) {
        
        let (momentRecord, tripRecord) : (CKRecord, CKRecord) = createMomentRecord(moment)
        
        modifyMomentRecord(moment, momentRecord: momentRecord, tripRecord: tripRecord)
        updateRecord(momentRecord, wasReadFromPlist: false, isTripRecord: false)
    }
    
    // Faz o download de todas as viagens
    
    func fetchAllTrips() {
        
        let tripQuery : CKQuery = CKQuery(recordType: "Trip", predicate: NSPredicate(format: "TRUEPREDICATE"))
        
        tripQuery.sortDescriptors = [NSSortDescriptor(key: "beginDate", ascending: false), NSSortDescriptor(key: "endDate", ascending: false)]
        
        privateDB.performQuery(tripQuery, inZoneWithID: CKRecordZone.defaultRecordZone().zoneID) { (tripsRecords, error) -> Void in
            
            if let err = error {
                
                println("Erro ao pegar todas as viagens. O erro foi: \(err)")
            }
            else {
                
                if tripsRecords.count > 0 {
                    
                    self.auxFetchAllTrips(0, tripsRecords: tripsRecords as! [CKRecord])
                }
            }
        }
    }
    
    // Função auxiliar que permite baixar todas as viagens
    
    private func auxFetchAllTrips(index: Int, tripsRecords: [CKRecord]) {
        
        if index < tripsRecords.count {
            
            var trip : Trip = Trip()
            let tripRecord : CKRecord = tripsRecords[index]
            
            trip.beginDate = tripRecord.valueForKey("beginDate") as! NSDate
            trip.endDate = tripRecord.valueForKey("endDate") as! NSDate
            trip.destination = tripRecord.valueForKey("destination") as! String
            
            let photoAsset : CKAsset = tripRecord.valueForKey("presentationImage") as! CKAsset
            let data : NSData = NSData(contentsOfURL: photoAsset.fileURL)!
            
            trip.changePresentationImage(UIImage(data: data)!)
            self.auxFetchMomentsFromTrip(trip, index: index, tripsRecords: tripsRecords)
        }
    }
    
    // Download de todos os momentos de uma viagem
    
    func fetchMomentsFromTrip(trip: Trip) {
        
        auxFetchMomentsFromTrip(trip, index: -1, tripsRecords: [])
    }
    
    // Função auxiliar que permite baixar todos os momentos de uma viagem
    
    private func auxFetchMomentsFromTrip(trip: Trip, index: Int, tripsRecords: [CKRecord]) {
        
        let tripID : CKRecordID = getTripID(trip.beginDate, endDate: trip.endDate)
        let momentsQuery : CKQuery = dao.getMomentsQuery(tripID)
        
        self.privateDB.performQuery(momentsQuery, inZoneWithID: CKRecordZone.defaultRecordZone().zoneID, completionHandler: { (momentsRecords, error) -> Void in
            
            if let err = error {
                
                println("Erro ao pegar os momentos de uma viagem. O erro foi: \(err)")
            }
            else {
                
                if momentsRecords.count > 0 {
                    
                    var moment: Moment = Moment()
                    
                    for momentRecordObj in momentsRecords {
                        
                        let momentRecord : CKRecord = momentRecordObj as! CKRecord
                        
                        moment.category = momentRecord.valueForKey("category") as? NSNumber
                        
                        moment.comment = momentRecord.valueForKey("comment") as? String
                        
                        moment.changeGeoTag(momentRecord.valueForKey("geoTag") as! CLLocation)
                        
                        moment.index = momentRecord.valueForKey("index") as? NSNumber
                        
                        moment.trip = trip
                        
                        let nPhotosAmount = momentRecord.valueForKey("photosAmount") as! NSNumber
                        let photosAmount = nPhotosAmount.integerValue
                        
                        if photosAmount > 0 {
                            
                            let photosAssets : NSArray = momentRecord.valueForKey("photos") as! NSArray
                            
                            for element in photosAssets {
                                
                                let photoAsset : CKAsset = element as! CKAsset
                                
                                moment.addNewPhoto(UIImage(data: NSData(contentsOfURL: photoAsset.fileURL)!)!)
                            }
                        }
                        
                        trip.addNewMoment(moment)
                    }
                }
                
                if index > -1 {
                    
                    self.auxFetchAllTrips(index+1, tripsRecords: tripsRecords)
                }
                
                println("Viagem obtida com sucesso!")
                // avisar ao observer e enviar o vetor moments
            }
        })
    }
    
    // Deleta uma viagem que esteja na cloud
    
    func deleteTrip(trip: Trip) {
        
        let tripRecord = createTripRecord(trip)
        deleteRecord(tripRecord, wasReadFromPlist: false, isTripRecord: true)
    }
    
    func deleteMoment(moment: Moment) {
        
        let (momentRecord, tripRecord) : (CKRecord, CKRecord) = createMomentRecord(moment)
        
        deleteRecord(momentRecord, wasReadFromPlist: false, isTripRecord: false)
    }
    
    private func getTripIDString(beginDate: NSDate, endDate: NSDate) -> String {
        
        return "\(DateFormatter.formattedDate(beginDate))bd\(DateFormatter.formattedDate(endDate))ed"
    }
    
    // Função auxiliar que cria o CKRecordID de uma trip
    
    private func getTripID(beginDate: NSDate, endDate: NSDate) -> CKRecordID {
        
        return CKRecordID(recordName: getTripIDString(beginDate, endDate: endDate))
    }
    
    private func getTripID(tripRecordIDString: String) -> CKRecordID {
        
        return CKRecordID(recordName: tripRecordIDString)
    }
    
    // Função auxiliar que cria o CKRecord de uma trip
    
    private func createTripRecord(beginDate: NSDate, endDate: NSDate) -> CKRecord {
        
        return CKRecord(recordType: "Trip", recordID: getTripID(beginDate, endDate: endDate))
    }
    
    private func createTripRecord(tripRecordIDString: String) -> CKRecord {
        
        return CKRecord(recordType: "Trip", recordID: getTripID(tripRecordIDString))
    }
    
    private func createTripRecord(trip: Trip) -> CKRecord {
        
        return createTripRecord(trip.beginDate, endDate: trip.endDate)
    }
    
    private func createTripRecord(trip: NSDictionary) -> CKRecord {
        
        return createTripRecord(trip.valueForKey("beginDate") as! NSDate, endDate: trip.valueForKey("beginDate") as! NSDate)
    }
    
    private func getMomentID(moment: Moment) -> (CKRecordID, CKRecord) {
    
        let trip : Trip = moment.trip!
        let tripIDString : String = getTripIDString(trip.beginDate, endDate: trip.endDate)
        
        return (CKRecordID(recordName: "\(tripIDString)\(moment.index!)"), createTripRecord(tripIDString))
    }
    
    private func createMomentRecord(moment: Moment) -> (CKRecord, CKRecord) {
        
        let (momentRecordID, tripRecord) = getMomentID(moment)
        
        return (CKRecord(recordType: "Moment", recordID: momentRecordID), tripRecord)
    }
    
    private func createMomentRecord(index: NSNumber, beginDate: NSDate, endDate: NSDate) -> CKRecord {
        
        let tripIDString : String = getTripIDString(beginDate, endDate: endDate)
        
        return CKRecord(recordType: "Moment", recordID: CKRecordID(recordName: "\(tripIDString)\(index)"))
    }
    
    private func createMomentRecord(moment: NSDictionary) -> CKRecord {
        
        let tripIDString : String = getTripIDString(moment.valueForKey("beginDate") as! NSDate, endDate: moment.valueForKey("beginDate") as! NSDate)
        
        let index = moment.valueForKey("index") as! NSNumber
        
        return CKRecord(recordType: "Moment", recordID: CKRecordID(recordName: "\(tripIDString)\(index)"))
    }
    
    // Função auxiliar que inicializa um tripRecord a partir de uma trip
    
    private func modifyTripRecord(trip: Trip, tripRecord: CKRecord) {
        
        tripRecord.setValue(trip.beginDate, forKey: "beginDate")
        tripRecord.setValue(trip.endDate, forKey: "endDate")
        tripRecord.setValue(trip.destination, forKey: "destination")
        tripRecord.setValue(UIImageJPEGRepresentation(trip.getPresentationImage(), 1), forKey: "presentationImage")
    }
    
    // Função auxiliar que inicializa um tripRecord a partir de uma trip num NSDictionary
    
    private func modifyTripRecord(trip: NSDictionary, tripRecord: CKRecord) {
        
        tripRecord.setValue(trip.objectForKey("beginDate"), forKey: "beginDate")
        tripRecord.setValue(trip.objectForKey("endDate"), forKey: "endDate")
        tripRecord.setValue(trip.objectForKey("destination"), forKey: "destination")
        tripRecord.setValue(trip.objectForKey("presentationImage"), forKey: "presentationImage")
    }
    
    // Função auxiliar que inicializa um momentRecord a partir de um moment
    
    private func modifyMomentRecord(index: Int, moment: Moment, momentRecord: CKRecord, tripRecord: CKRecord) {
        
        momentRecord.setValue(moment.category, forKey: "category")
        momentRecord.setValue(moment.comment, forKey: "comment")
        momentRecord.setValue(moment.getGeoTag(), forKey: "geoTag")
        momentRecord.setValue(CKReference(record: tripRecord, action: CKReferenceAction.DeleteSelf), forKey: "trip")
        momentRecord.setValue(NSNumber(integer: index), forKey: "index")
        
        let imgs : [UIImage] = moment.getAllPhotos()
        let amount : Int = imgs.count
        
        momentRecord.setValue(NSNumber(integer: amount), forKey: "photosAmount")
        
        for var i : Int = 0; i < amount; i++ {
            
            momentRecord.setValue(UIImageJPEGRepresentation(imgs[i], 1), forKey: "photo\(i)")
        }
    }
    
    private func modifyMomentRecord(moment: Moment, momentRecord: CKRecord, tripRecord: CKRecord) {
        
        momentRecord.setValue(moment.category, forKey: "category")
        momentRecord.setValue(moment.comment, forKey: "comment")
        momentRecord.setValue(moment.getGeoTag(), forKey: "geoTag")
        momentRecord.setValue(CKReference(record: tripRecord, action: CKReferenceAction.DeleteSelf), forKey: "trip")
        momentRecord.setValue(moment.index!, forKey: "index")
        
        let photos : [UIImage] = moment.getAllPhotos()
        
        momentRecord.setValue(photos.count, forKey: "photosAmount")
        
        if photos.count > 0 {
            
            momentRecord.setValue(self.getMomentPhotosArray(photos, isAsset: true), forKey: "photos")
        }
    }
    
    private func modifyMomentRecord(moment: NSDictionary, momentRecord: CKRecord, tripRecord: CKRecord) {
        
        momentRecord.setValue(moment.valueForKey("category"), forKey: "category")
        momentRecord.setValue(moment.valueForKey("comment"), forKey: "comment")
        momentRecord.setValue(moment.valueForKey("geoTag"), forKey: "geoTag")
        momentRecord.setValue(CKReference(record: tripRecord, action: CKReferenceAction.DeleteSelf), forKey: "trip")
        momentRecord.setValue(moment.valueForKey("index"), forKey: "index")
        momentRecord.setValue(moment.valueForKey("photosAmount"), forKey: "photosAmount")
        momentRecord.setValue(moment.valueForKey("photos"), forKey: "photos")
    }
    
    // Função auxiliar que cria CKQuery que procura todos os moments de uma certa trip
    
    private func getMomentsQuery(tripID: CKRecordID) -> CKQuery {
        
        let tripReference : CKReference = CKReference(recordID: tripID, action: CKReferenceAction.DeleteSelf)
        
        let momentsPredicate : NSPredicate = NSPredicate(format: "trip == %@", tripReference)
        let momentsQuery : CKQuery = CKQuery(recordType: "Moment", predicate: momentsPredicate)
        
        momentsQuery.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        return momentsQuery
    }
    
    // Função auxiliar que retira da plist a instrução que acabou de ser executada
    
    private func updatePlist() {
        
        let instructions : NSMutableArray! = NSMutableArray(contentsOfFile: plistPath)
        
        if instructions != nil && instructions.count > 0 {
            
            instructions.removeObjectAtIndex(0)
            instructions.writeToFile(plistPath, atomically: true)
        }
    }

    
    private func saveRecord(record: CKRecord, wasReadFromPlist: Bool, isTripRecord: Bool) {
        
        privateDB.saveRecord(record, completionHandler: { (recordReturned, error) -> Void in
            
            if let err = error {
                
                if isTripRecord {
                    
                    println("Erro ao salvar trip. O erro foi: \(err)")
                }
                else {
                    
                    println("Erro ao salvar momento. O erro foi: \(err)")
                }
                
                if !wasReadFromPlist {
                    
                    //self.saveInstruction(<#trip: Trip#>) tem que fazer uma versão que aceite receber uma tripRecord
                    //self.saveInstruction(moment: Moment) tem que fazer uma versão que aceite receber uma momentRecord
                    //tem que chamar esses métodos nos if's acima
                }
            }
            else {
                
                if wasReadFromPlist {
                    
                    self.updatePlist()
                    self.updateCloudKit()
                }
            }
        })
    }
    
    private func updateRecord(record: CKRecord, wasReadFromPlist: Bool, isTripRecord: Bool) {
        
        let updateOperation : CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        updateOperation.savePolicy = CKRecordSavePolicy.ChangedKeys
        
        updateOperation.modifyRecordsCompletionBlock = { saved, _, error in
            
            if let err = error {
                
                if isTripRecord {
                    
                    println("Erro ao atualizar trip. O erro foi: \(err)")
                }
                else {
                    
                    println("Erro ao atualizar momento. O erro foi: \(err)")
                }
                
                if !wasReadFromPlist {
                    
                    //implementar
                }
            }
            else {
                
                if wasReadFromPlist {
                    
                    self.updatePlist()
                    self.updateCloudKit()
                }
            }
        }
        
        privateDB.addOperation(updateOperation)
    }
    
    private func deleteRecord(record: CKRecord, wasReadFromPlist: Bool, isTripRecord: Bool) {
        
        privateDB.deleteRecordWithID(record.recordID, completionHandler: { (recordReturned, error) -> Void in
            
            if let err = error {
                
                if isTripRecord {
                    
                    println("Erro ao deletar trip. O erro foi: \(err)")
                }
                else {
                    
                    println("Erro ao deletar momento. O erro foi: \(err)")
                }
                
                if !wasReadFromPlist {
                    
                    //implementar
                }
            }
            else {
                
                if wasReadFromPlist {
                    NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
                    self.updatePlist()
                    self.updateCloudKit()
                }
            }
        })
    }
    
    private func getMomentPhotosArray(photos: [UIImage], isAsset: Bool) -> NSMutableArray {
        
        var photosAssets : NSMutableArray = NSMutableArray(capacity: photos.count)
        
        for img in photos {
            
            let data : NSData = UIImageJPEGRepresentation(img, 1)
            
            if isAsset {
                
                photosAssets.addObject(data)
            }
            else {
                
                data.writeToURL(tempURL, atomically: false)
                photosAssets.addObject(CKAsset(fileURL: tempURL))
            }
        }
        
        return photosAssets
    }
}