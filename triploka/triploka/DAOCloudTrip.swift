//
//  DAOCloudTrip.swift
//  chp3
//
//  Created by Jordan Rodrigues Rangel on 5/26/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit
import CloudKit

private var dao : DAOCloudTrip = DAOCloudTrip()

class DAOCloudTrip: NSObject {
    
    private var container : CKContainer
    private var privateDB : CKDatabase
    private var rootPath : String
    private var plistPath : String
    
    override init() {
        
        container = CKContainer.defaultContainer()
        privateDB = container.privateCloudDatabase
        
        rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        
        plistPath = rootPath.stringByAppendingPathComponent("Instructions.plist")
        
        var fileManager = NSFileManager.defaultManager()
        
        if !fileManager.fileExistsAtPath(plistPath) {
            
            var error : NSErrorPointer = nil
            let bundle = NSBundle.mainBundle().pathForResource("Instructions", ofType: "plist")
            fileManager.copyItemAtPath(bundle!, toPath: plistPath, error: error)
            
            if error != nil {
                
                println("Erro ao copiar plist para bundle")
            }
        }
        
        super.init()
    }
    
    class func getInstance() -> DAOCloudTrip {
        
        return dao
    }
    
    func updateCloudKit() {
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)) {
            
            self.readNextInstruction()
        }
    }
    
    private func readNextInstruction() {
        
        let instructions : NSArray! = NSArray(contentsOfFile: plistPath)
        
        if instructions != nil && instructions.count > 0 {
            
            let instruction : NSDictionary = instructions[0] as! NSDictionary
            let type : String = instruction["type"] as! String
            let action : String = instruction["action"] as! String
            
            var trip : Trip = Trip()
            
            trip.beginDate = instruction.valueForKey("beginDate") as! NSDate
            trip.endDate = instruction.valueForKey("endDate") as! NSDate
            trip.destination = instruction["destination"] as! String
            
            if type == "Trip" {
                
                if action == "Save" {
                    
                    saveNewTrip(trip)
                }
                else if action == "Update" {
                    
                    updateTrip(trip)
                }
                else if action == "Delete" {
                    
                    deleteTrip(trip)
                }
            }
            else if action == "Moment" {
                
                let index : Int = (instruction.valueForKey("index") as! NSNumber).integerValue
                
                if action == "Save" {
                    
                    saveNewMoment(index, trip: trip)
                }
                else if action == "Update" {
                    
                    updateMoment(index, trip: trip)
                }
                else if action == "Delete" {
                    
                    deleteMomentFrom(index, trip: trip)
                }
            }
        }
    }
    
    func saveNewTrip(trip: Trip) {
        
        let tripRecord : CKRecord = getTripRecord(trip)
        modifyTrip(trip, tripRecord: tripRecord)
        
        privateDB.saveRecord(tripRecord, completionHandler: { (recordReturned, error) -> Void in
            
            if let err = error {
                
                println("Erro ao salvar uma viagem. O erro foi: \(err)")
                self.updateCloudKit()
            }
            else {
                
                println("Viagem salva com sucesso!")
                self.saveAllMoments(tripRecord, moments: trip.getAllMoments())
            }
        })
    }
    
    func saveNewMoment(index: Int, trip: Trip) {
        
        if index > 0 {
            
            let tripRecord : CKRecord = getTripRecord(trip)
            
            auxSaveNewMoment(index, moments: trip.getAllMoments(), tripRecord: tripRecord, callAgain: false)
        }
    }
    
    func updateTrip(trip: Trip) {
        
        let tripRecord : CKRecord = getTripRecord(trip)
        modifyTrip(trip, tripRecord: tripRecord)
        let updateOperation : CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [tripRecord], recordIDsToDelete: nil)
        
        updateOperation.savePolicy = CKRecordSavePolicy.ChangedKeys
        
        updateOperation.modifyRecordsCompletionBlock = { saved, _, error in
            
            if let err = error {
                
                println("Erro ao atualizar viagem. O erro foi: \(err)")
                self.updateCloudKit()
            }
        }
    }
    
    func updateMoment(index: Int, trip: Trip) {
        
        let tripRecord : CKRecord = getTripRecord(trip)
        let momentRecord : CKRecord = CKRecord(recordType: "Moment")
        let moments : [Moment] = trip.getAllMoments()
        let moment : Moment = moments[index]
        
        modifyMoment(index, moment: moment, momentRecord: momentRecord, tripRecord: tripRecord)
        
        let updateOperation : CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [momentRecord], recordIDsToDelete: nil)
        
        updateOperation.savePolicy = CKRecordSavePolicy.ChangedKeys
        
        updateOperation.modifyRecordsCompletionBlock = { saved, _, error in
            
            if let err = error {
                
                println("Erro ao atualizar viagem. O erro foi: \(err)")
            }
        }
    }
    
    private func saveAllMoments(tripRecord: CKRecord, moments: [Moment]) {
        
        if moments.count > 0 {
            
            auxSaveNewMoment(0, moments: moments, tripRecord: tripRecord, callAgain: true)
        }
    }
    
    private func auxSaveNewMoment(index: Int, moments: [Moment], tripRecord: CKRecord, callAgain: Bool) {
        
        if index < moments.count {
            
            let moment : Moment = moments[index]
            let momentRecord : CKRecord = CKRecord(recordType: "Moment")
            
            modifyMoment(index, moment: moment, momentRecord: momentRecord, tripRecord: tripRecord)
            
            privateDB.saveRecord(momentRecord, completionHandler: { (recordReturned, error) -> Void in
                
                if let err = error {
                    
                    println("Erro ao salvar um momento. O erro foi: \(err)")
                }
                else {
                    
                    if callAgain {
                        
                        self.auxSaveNewMoment(index+1, moments: moments, tripRecord: tripRecord, callAgain: callAgain)
                    }
                    else {
                        
                        // este é o caso onde o saveMoment foi chamado
                        // chamar observer aqui para notificar
                    }
                }
            })
        }
        else {
            
            if callAgain {
                
                // este é o caso onde o saveAllMoments foi chamado
                // chamar observer aqui para notificar
            }
        }
    }
    
    func fetchTripWith(beginDate: NSDate, endDate: NSDate, destination: String) {
        
        let tripID : CKRecordID = CKRecordID(recordName: "\(beginDate)bd\(endDate)ed\(destination)dt")
        
        privateDB.fetchRecordWithID(tripID, completionHandler: { (recordReturned, error) -> Void in
            
            if let err = error {
                
                println("Erro ao pegar uma viagem. O erro foi: \(err)")
                // avisar observer
            }
            else {
                
                if recordReturned == nil {
                    
                    println("Viagem não existe na cloud.")
                    // avisar observer?
                }
                else {
                    
                    var trip : Trip = Trip()
                    
                    trip.beginDate = recordReturned.valueForKey("beginDate") as! NSDate
                    trip.endDate = recordReturned.valueForKey("endDate") as! NSDate
                    trip.destination = recordReturned.valueForKey("destination") as! String
                    
                    let photoAsset : CKAsset = recordReturned.valueForKey("presentationImage") as! CKAsset
                    var error : NSErrorPointer! = nil
                    
                    let data = NSData(contentsOfURL: photoAsset.fileURL, options: NSDataReadingOptions.DataReadingMappedAlways, error: error)
                    
                    if error != nil || data == nil {
                        
                        println("Erro ao pegar uma viagem. O erro se deu ao tentar pegar a presentationImage do URL. O erro foi: \(error)")
                        
                        // avisar observer?
                    }
                    else {
                        
                        dao.fetchMomentsFromTrip(trip)
                        
                    }
                }
            }
        })
    }
    
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
    
    private func auxFetchAllTrips(index: Int, tripsRecords: [CKRecord]) {
        
        if index < tripsRecords.count {
            
            var trip : Trip = Trip()
            let tripRecord : CKRecord = tripsRecords[index]
            
            trip.beginDate = tripRecord.valueForKey("beginDate") as! NSDate
            trip.endDate = tripRecord.valueForKey("endDate") as! NSDate
            trip.destination = tripRecord.valueForKey("destination") as! String
            
            let photoAsset : CKAsset = tripRecord.valueForKey("presentationImage") as! CKAsset
            var error : NSErrorPointer! = nil
            
            let data = NSData(contentsOfURL: photoAsset.fileURL, options: NSDataReadingOptions.DataReadingMappedAlways, error: error)
            
            if error != nil || data == nil {
                
                println("Erro ao pegar uma viagem. O erro se deu ao tentar pegar a presentationImage do URL. O erro foi: \(error)")
                
                // avisar observer?
            }
            else {
                
                self.auxFetchMomentsFromTrip(trip, nextIndex: index+1, tripsRecords: tripsRecords)
                
            }
        }
    }
    
    func fetchMomentsFromTrip(trip: Trip) {
        
        auxFetchMomentsFromTrip(trip, nextIndex: -1, tripsRecords: [])
    }
    
    private func auxFetchMomentsFromTrip(trip: Trip, nextIndex: Int, tripsRecords: [CKRecord]) {
        
        let tripID : CKRecordID = dao.getTripID(trip)
        let momentsQuery : CKQuery = dao.getMomentsQuery(tripID)
        
        self.privateDB.performQuery(momentsQuery, inZoneWithID: CKRecordZone.defaultRecordZone().zoneID, completionHandler: { (momentsRecords, error) -> Void in
            
            if let err = error {
                
                println("Erro ao pegar os momentos de uma viagem. O erro foi: \(err)")
            }
            else {
                
                if momentsRecords.count > 0 {
                    
                    var i : Int = 0
                    var moments : [Moment] = []
                    
                    for momentRecordObj in momentsRecords {
                        
                        let momentRecord : CKRecord = momentRecordObj as! CKRecord
                        
                        moments[i].category = momentRecord.valueForKey("category") as! NSNumber
                        
                        moments[i].comment = momentRecord.valueForKey("comment") as! String
                        
                        //moments[i].geoTag = momentRecord.valueForKey("geoTag") as! String
                        
                        i++
                    }
                }
                
                if nextIndex > 0 {
                    
                    self.auxFetchAllTrips(nextIndex, tripsRecords: tripsRecords)
                }
                
                println("Viagem obtida com sucesso!")
                // avisar ao observer e enviar o vetor moments
            }
        })
    }
    
    func deleteTrip(trip: Trip) {
        
        let deleteOperation : CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [dao.getTripID(trip)])
        
        deleteOperation.savePolicy = CKRecordSavePolicy.AllKeys
        
        deleteOperation.modifyRecordsCompletionBlock = { added, deleted, error in
            
            if let err = error {
                
                println("Erro ao deletar viagem. O erro foi: \(err)")
            }
            else {
                
                if deleted.count < 1 {
                    
                    println("Não existe esta viagem na cloud para que possa ser deletada")
                }
                else {
                    
                    println("Viagem deletada com sucesso!")
                    // não precisa deletar os moments, pois já são deletados automaticamente
                }
                
                // avisar ao observer
            }
        }
        
        privateDB.addOperation(deleteOperation)
    }
    
    func deleteMomentFrom(index: Int, trip: Trip) {
        
        let count: Int = trip.getAllMoments().count
        
        if count < 1 || index >= count {
            
            return
        }
        
        let tripID : CKRecordID = dao.getTripID(trip)
        let tripReference : CKReference = CKReference(recordID: tripID, action: CKReferenceAction.None)
        
        let momentsPredicate : NSPredicate = NSPredicate(format: "trip == %@ AND index == %@", tripReference, NSNumber(integer: index))
        
        let momentsQuery : CKQuery = CKQuery(recordType: "Moment", predicate: momentsPredicate)
        
        privateDB.performQuery(momentsQuery, inZoneWithID: CKRecordZone.defaultRecordZone().zoneID) { (momentsRecords, error) -> Void in
            
            if let err = error {
                
                println("Erro ao deletar ")
            }
            else {
                
                if momentsRecords.count > 0 {
                    
                    let momentRecord : CKRecord = momentsRecords[0] as! CKRecord
                    let deleteOperation : CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [momentRecord.recordID])
                    
                    deleteOperation.savePolicy = CKRecordSavePolicy.AllKeys
                    
                    deleteOperation.modifyRecordsCompletionBlock = { added, deleted, error in
                        
                        if let err = error {
                            
                            println("Erro ao deletar momento. O erro foi: \(err)")
                        }
                        else {
                            
                            println("Momento deletado com sucesso")
                            // avisar ao observer
                        }
                    }
                    
                    self.privateDB.addOperation(deleteOperation)
                }
                else {
                    
                    // avisar ao observer que não existe tal momento a ser deletado na cloud
                }
            }
        }
    }
    
    private func getTripID(trip: Trip) -> CKRecordID {
        
        return CKRecordID(recordName: "\(trip.beginDate)bd\(trip.endDate)ed\(trip.destination)dt")
    }
    
    private func getTripRecord(trip: Trip) -> CKRecord {
        
        return CKRecord(recordType: "Trip", recordID: getTripID(trip))
    }
    
    private func modifyTrip(trip: Trip, tripRecord: CKRecord) {
        
        let photoAssset : CKAsset = CKAsset(fileURL: NSURL(fileURLWithPath: "")) // consertar
        
        tripRecord.setValue(trip.beginDate, forKey: "beginDate")
        tripRecord.setValue(trip.endDate, forKey: "endDate")
        tripRecord.setValue(trip.destination, forKey: "destination")
        tripRecord.setValue(photoAssset, forKey: "presentationImage")
    }
    
    private func modifyMoment(index: Int, moment: Moment, momentRecord: CKRecord, tripRecord: CKRecord) {
        
        momentRecord.setValue(moment.category, forKey: "category")
        momentRecord.setValue(moment.comment, forKey: "comment")
        //momentRecord.setValue(moment.geoTag, forKey: "geoTrag")
        momentRecord.setValue(CKReference(record: tripRecord, action: CKReferenceAction.DeleteSelf), forKey: "trip")
        momentRecord.setValue(NSNumber(integer: index), forKey: "index")
    }
    
    private func getMomentsQuery(tripID: CKRecordID) -> CKQuery {
        
        let tripReference : CKReference = CKReference(recordID: tripID, action: CKReferenceAction.None)
        
        let momentsPredicate : NSPredicate = NSPredicate(format: "trip == %@", tripReference)
        let momentsQuery : CKQuery = CKQuery(recordType: "Moment", predicate: momentsPredicate)
        
        momentsQuery.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        return momentsQuery
    }
}