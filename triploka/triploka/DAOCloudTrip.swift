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
        
        let newInstruction : NSDictionary = NSDictionary(dictionary: ["type" : "Trip", "action" : "Save", "beginDate" : trip.beginDate, "endDate" : trip.endDate, "destination" : trip.destination, "presentationImage" : UIImageJPEGRepresentation(trip.getPresentationImage(), 1)])
        
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
            
            var trip : Trip = Trip()
            
            trip.beginDate = instruction.valueForKey("beginDate") as! NSDate
            trip.endDate = instruction.valueForKey("endDate") as! NSDate
            trip.destination = instruction.valueForKey("destination") as! String
            
            let tripRecord: CKRecord = getTripRecord(trip)
            
            if type == "Trip" {
                
                if action == "Save" {
                    
                    trip.changePresentationImage(UIImage(data: instruction.valueForKey("presentationImage") as! NSData)!)
                    
                    saveTripRecord(tripRecord)
                }
                else if action == "Update" {
                    
                    trip.changePresentationImage(UIImage(data: instruction.valueForKey("presentationImage") as! NSData)!)
                    
                    updateTrip(trip)
                }
                else if action == "Delete" {
                    
                    deleteTrip(trip)
                }
            }
            else if action == "Moment" {
                
                let index : Int = (instruction.valueForKey("index") as! NSNumber).integerValue
                let momentRecord : CKRecord = CKRecord(recordType: "Moment")
                
                momentRecord.setValue(instruction.valueForKey("comment") as! String, forKey: "comment")
                
                momentRecord.setValue(instruction.valueForKey("category") as! NSNumber, forKey: "category")
                
                momentRecord.setValue(instruction.valueForKey("geoTag") as! CLLocation, forKey: "geoTag")
                
                momentRecord.setValue(CKReference(record: tripRecord, action: CKReferenceAction.DeleteSelf), forKey: "trip")
                
                let nsnAmount : NSNumber = instruction.valueForKey("photosAmount") as! NSNumber
                let amount : Int = nsnAmount.integerValue
                
                for var i : Int = 0; i < amount; i++ {
                    
                    momentRecord.setValue(instruction.valueForKey("photo\(i)") as! NSData, forKey: "photo\(i)")
                }
                
                if action == "Save" {
                    
                    saveMomentRecord(momentRecord)
                }
                else if action == "Update" {
                    
                    updateMomentOperation(momentRecord)
                }
                else if action == "Delete" {
                    
                    deleteMomentOperation(momentRecord)
                }
            }
        }
    }
    
    // Salva uma nova viagem na cloud
    
    func saveNewTrip(trip: Trip) {
        
        let tripRecord : CKRecord = getTripRecord(trip)
        modifyTrip(trip, tripRecord: tripRecord)
        
        privateDB.saveRecord(tripRecord, completionHandler: { (recordReturned, error) -> Void in
            
            if let err = error {
                
                println("Erro ao salvar uma viagem. O erro foi: \(err)")
            }
            else {
                
                println("Viagem salva com sucesso!")
                self.saveAllMoments(tripRecord, moments: trip.getAllMoments())
            }
        })
    }
    
    // Salva o momento da posição index do vetor de momentos de trip na cloud
    
    func saveNewMoment(index: Int, trip: Trip) {
        
        if index > 0 {
            
            let tripRecord : CKRecord = getTripRecord(trip)
            
            auxSaveNewMoment(index, moments: trip.getAllMoments(), tripRecord: tripRecord, callAgain: false)
        }
    }
    
    // Atualiza uma viagem já existente na cloud
    
    func updateTrip(trip: Trip) {
        
        let tripRecord : CKRecord = getTripRecord(trip)
        modifyTrip(trip, tripRecord: tripRecord)
        let updateOperation : CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [tripRecord], recordIDsToDelete: nil)
        
        updateOperation.savePolicy = CKRecordSavePolicy.ChangedKeys
        
        updateOperation.modifyRecordsCompletionBlock = { saved, _, error in
            
            if let err = error {
                
                println("Erro ao atualizar viagem. O erro foi: \(err)")
            }
            else {
                
                self.updatePlist()
                self.updateCloudKit()
            }
        }
        
        privateDB.addOperation(updateOperation)
    }
    
    // Atualiza um momento já existente na cloud
    
    func updateMoment(index: Int, trip: Trip) {
        
        let tripRecord : CKRecord = getTripRecord(trip)
        let momentRecord : CKRecord = CKRecord(recordType: "Moment")
        let moments : [Moment] = trip.getAllMoments()
        let moment : Moment = moments[index]
        
        modifyMoment(index, moment: moment, momentRecord: momentRecord, tripRecord: tripRecord)
        
        updateMomentOperation(momentRecord)
    }
    
    // Salva todos os momentos da array moments na cloud
    
    private func saveAllMoments(tripRecord: CKRecord, moments: [Moment]) {
        
        if moments.count > 0 {
            
            auxSaveNewMoment(0, moments: moments, tripRecord: tripRecord, callAgain: true)
        }
    }
    
    // Função auxiliar que salva um certo moment
    
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
                        
                        self.updatePlist()
                        self.updateCloudKit()
                    }
                }
            })
        }
        else {
            
            if callAgain {
                
                self.updatePlist()
                self.updateCloudKit()
            }
        }
    }
    
    // Faz o download de uma certa viagem
    
    func fetchTripWith(beginDate: NSDate, endDate: NSDate, destination: String) {
        
        let tripID : CKRecordID = CKRecordID(recordName: "\(DateFormatter.formattedDate(beginDate))bd\(DateFormatter.formattedDate(endDate))ed\(destination)dt")
        
        privateDB.fetchRecordWithID(tripID, completionHandler: { (recordReturned, error) -> Void in
            
            if let err = error {
                
                println("Erro ao pegar uma viagem. O erro foi: \(err)")
            }
            else {
                
                if recordReturned == nil {
                    
                    println("Viagem não existe na cloud.")
                    self.updateCloudKit()
                }
                else {
                    
                    var trip : Trip = Trip()
                    
                    trip.beginDate = recordReturned.valueForKey("beginDate") as! NSDate
                    trip.endDate = recordReturned.valueForKey("endDate") as! NSDate
                    trip.destination = recordReturned.valueForKey("destination") as! String
                    
                    let data : NSData = recordReturned.valueForKey("presentationImage") as! NSData
                    
                    trip.changePresentationImage(UIImage(data: data)!)
                    dao.fetchMomentsFromTrip(trip)
                }
            }
        })
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
            var error : NSErrorPointer! = nil
            let data : NSData = tripRecord.valueForKey("presentationImage") as! NSData
            
            trip.changePresentationImage(UIImage(data: data)!)
            self.auxFetchMomentsFromTrip(trip, nextIndex: index+1, tripsRecords: tripsRecords)
        }
    }
    
    // Download de todos os momentos de uma viagem
    
    func fetchMomentsFromTrip(trip: Trip) {
        
        auxFetchMomentsFromTrip(trip, nextIndex: -1, tripsRecords: [])
    }
    
    // Função auxiliar que permite baixar todos os momentos de uma viagem
    
    private func auxFetchMomentsFromTrip(trip: Trip, nextIndex: Int, tripsRecords: [CKRecord]) {
        
        let tripID : CKRecordID = dao.getTripID(trip)
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
                        
                        moment.category = (momentRecord.valueForKey("category") as! NSNumber)
                        
                        moment.comment = (momentRecord.valueForKey("comment") as! String)
                        
                        moment.changeGeoTag(momentRecord.valueForKey("geoTag") as! CLLocation)
                        
                        let amount : Int = (momentRecord.valueForKey("photosAmount") as! NSNumber).integerValue
                        
                        for var i : Int = 0; i < amount; i++ {
                            
                            moment.addNewPhoto(UIImage(data: (momentRecord.valueForKey("photo\(i)") as! NSData))!)
                        }
                        
                        trip.addNewMoment(moment)
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
    
    // Deleta uma viagem que esteja na cloud
    
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
                
                self.updatePlist()
                self.updateCloudKit()
            }
        }
        
        privateDB.addOperation(deleteOperation)
    }
    
    // Deleta um certo momento desta trip que esteja na cloud
    
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
                    
                    self.deleteMomentOperation(momentRecord)
                }
                else {
                    
                    self.updatePlist()
                    self.updateCloudKit()
                }
            }
        }
    }
    
    // Função auxiliar que cria o CKRecordID de uma trip
    
    private func getTripID(trip: Trip) -> CKRecordID {
        
        return CKRecordID(recordName: "\(DateFormatter.formattedDate(trip.beginDate))bd\(DateFormatter.formattedDate(trip.endDate))ed\(trip.destination)dt")
    }
    
    // Função auxiliar que cria o CKRecord de uma trip
    
    private func getTripRecord(trip: Trip) -> CKRecord {
        
        return CKRecord(recordType: "Trip", recordID: getTripID(trip))
    }
    
    // Função auxiliar que inicializa um tripRecord a partir de uma trip
    
    private func modifyTrip(trip: Trip, tripRecord: CKRecord) {
        
        tripRecord.setValue(trip.beginDate, forKey: "beginDate")
        tripRecord.setValue(trip.endDate, forKey: "endDate")
        tripRecord.setValue(trip.destination, forKey: "destination")
        tripRecord.setValue(UIImageJPEGRepresentation(trip.getPresentationImage(), 1), forKey: "presentationImage")
    }
    
    // Função auxiliar que inicializa um momentRecord a partir de um moment
    
    private func modifyMoment(index: Int, moment: Moment, momentRecord: CKRecord, tripRecord: CKRecord) {
        
        momentRecord.setValue(moment.category, forKey: "category")
        momentRecord.setValue(moment.comment, forKey: "comment")
        momentRecord.setValue(moment.getGeoTag(), forKey: "geoTrag")
        momentRecord.setValue(CKReference(record: tripRecord, action: CKReferenceAction.DeleteSelf), forKey: "trip")
        momentRecord.setValue(NSNumber(integer: index), forKey: "index")
        
        let imgs : [UIImage] = moment.getAllPhotos()
        let amount : Int = imgs.count
        
        momentRecord.setValue(NSNumber(integer: amount), forKey: "photosAmount")
        
        for var i : Int = 0; i < amount; i++ {
            
            momentRecord.setValue(UIImageJPEGRepresentation(imgs[i], 1), forKey: "photo\(i)")
        }
    }
    
    // Função auxiliar que cria CKQuery que procura todos os moments de uma certa trip
    
    private func getMomentsQuery(tripID: CKRecordID) -> CKQuery {
        
        let tripReference : CKReference = CKReference(recordID: tripID, action: CKReferenceAction.None)
        
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
    
    // Função que atualiza um certo moment que já esteja na cloud
    
    private func updateMomentOperation(momentRecord: CKRecord) {
        
        let updateOperation : CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [momentRecord], recordIDsToDelete: nil)
        
        updateOperation.savePolicy = CKRecordSavePolicy.ChangedKeys
        
        updateOperation.modifyRecordsCompletionBlock = { saved, _, error in
            
            if let err = error {
                
                println("Erro ao atualizar momento. O erro foi: \(err)")
            }
            else {
                
                self.updatePlist()
                self.updateCloudKit()
            }
        }
        
        privateDB.addOperation(updateOperation)
    }
    
    // Deleta momento já presente na cloud
    
    private func deleteMomentOperation(momentRecord: CKRecord) {
        
        let deleteOperation : CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [momentRecord.recordID])
        
        deleteOperation.savePolicy = CKRecordSavePolicy.AllKeys
        
        deleteOperation.modifyRecordsCompletionBlock = { added, deleted, error in
            
            if let err = error {
                
                println("Erro ao deletar momento. O erro foi: \(err)")
            }
            else {
                
                println("Momento deletado com sucesso")
                self.updatePlist()
                self.updateCloudKit()
            }
        }
        
        self.privateDB.addOperation(deleteOperation)
    }
    
    // Salva um certo momento na cloud
    
    private func saveMomentRecord(momentRecord: CKRecord) {
        
        privateDB.saveRecord(momentRecord, completionHandler: { (recordReturned, error) -> Void in
            
            if let err = error {
                
                println("Erro ao salvar momento pegado da plist. O erro foi: \(err)")
            }
            else {
                
                self.updatePlist()
                self.updateCloudKit()
            }
        })
    }
    
    // Salva uma trip na cloud
    
    private func saveTripRecord(tripRecord: CKRecord) {
        
        privateDB.saveRecord(tripRecord, completionHandler: { (recordReturned, error) -> Void in
            
            if let err = error {
                
                println("Erro ao salvar momento pegado da plist. O erro foi: \(err)")
            }
            else {
                
                self.updatePlist()
                self.updateCloudKit()
            }
        })
    }
}