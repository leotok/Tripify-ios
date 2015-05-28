////
////  DAOCloudTrip.swift
////  chp3
////
////  Created by Jordan Rodrigues Rangel on 5/26/15.
////  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
////
//
//import UIKit
//import CloudKit
//
//private var dao : DAOCloudTrip = DAOCloudTrip()
//
//class DAOCloudTrip: NSObject {
//   
//    private var container : CKContainer
//    private var privateDB : CKDatabase
//    
//    override init() {
//        
//        container = CKContainer.defaultContainer()
//        privateDB = container.privateCloudDatabase
//        super.init()
//    }
//    
//    class func getInstance() -> DAOCloudTrip {
//        
//        return dao
//    }
//    
//    func saveNewTrip(trip: Trip) {
//        
//        let timeline : Timeline = trip.timeline
//        let tripID : CKRecordID = dao.getTripID(trip)
//        var tripRecord : CKRecord = CKRecord(recordType: "Trip", recordID: tripID)
//        
//        for moment in timeline.moments {
//            
//            var momentRecord : CKRecord = CKRecord(recordType: "Moment")
//            
//            momentRecord.setValue(moment.category, forKey: "category")
//            momentRecord.setValue(moment.comment, forKey: "comment")
//            momentRecord.setValue(moment.dateOfCreation, forKey: "dateOfCreation")
//            momentRecord.setValue(CKReference(record: tripRecord, action: CKReferenceAction.DeleteSelf), forKey: "trip")
//            
//            // Tem que transformar geoTag em NSData e desserializar num CLLocation, algo assim:
//            var location : CLLocation = (moment.geoTag as! NSData).valueForKey("location") as! CLLocation
//            momentRecord.setValue(location, forKey: "geoTrag")
//        }
//        
//        let photoAssset : CKAsset = CKAsset(fileURL: NSURL(fileURLWithPath: "")) // consertar
//        
//        tripRecord.setValue(trip.beginDate, forKey: "beginDate")
//        tripRecord.setValue(trip.endDate, forKey: "endDate")
//        tripRecord.setValue(trip.destination, forKey: "destination")
//        tripRecord.setValue(photoAssset, forKey: "presentationImage")
//        
//        privateDB .saveRecord(tripRecord, completionHandler: { (recordReturned, error) -> Void in
//            
//            if let err = error {
//                
//                println("Erro ao salvar uma viagem. O erro foi: \(err)")
//            }
//            else {
//                
//                println("Viagem salva com sucesso!")
//            }
//        })
//    }
//    
//    func fetchTripNamed(beginDate: NSDate, endDate: NSDate, destination: String) {
//        
//        let tripID : CKRecordID = CKRecordID(recordName: "\(beginDate)bd\(endDate)ed\(destination)dt")
//        
//        privateDB.fetchRecordWithID(tripID, completionHandler: { (recordReturned, error) -> Void in
//            
//            if let err = error {
//                
//                println("Erro ao pegar uma viagem. O erro foi: \(err)")
//            }
//            else {
//                
//                var trip : Trip = Trip()
//                
//                trip.beginDate = recordReturned.valueForKey("beginDate") as! NSDate
//                trip.endDate = recordReturned.valueForKey("endDate") as! NSDate
//                trip.destination = recordReturned.valueForKey("destination") as! String
//                
//                let photoAsset : CKAsset = recordReturned.valueForKey("presentationImage") as! CKAsset
//                var error : NSErrorPointer! = nil
//                
//                trip.presentationImage = NSData(contentsOfURL: photoAsset.fileURL, options: NSDataReadingOptions.DataReadingMappedAlways, error: error) as! AnyObject
//                
//                if let err = error {
//                    
//                    println("Erro ao pegar uma viagem. O erro se deu ao tentar pegar a presentationImage do URL. O erro foi: \(err)")
//                }
//                else {
//                    
//                    let tripReference : CKReference = CKReference(recordID: tripID, action: CKReferenceAction.None)
//                    
//                    let momentsPredicate : NSPredicate = NSPredicate(format: "trip == %@", tripReference)
//                    let momentsQuery : CKQuery = CKQuery(recordType: "Moment", predicate: momentsPredicate)
//                    
//                    momentsQuery.sortDescriptors = [NSSortDescriptor(key: "dateOfCreation", ascending: true)]
//                    
//                    self.privateDB.performQuery(momentsQuery, inZoneWithID: CKRecordZone.defaultRecordZone().zoneID, completionHandler: { (momentsRecords, error) -> Void in
//                        
//                        if let err = error {
//                            
//                            println("Erro ao pegar uma viagem. Falha ao pegar os momentos da viagem. O erro foi: \(err)")
//                        }
//                        else {
//                            
//                            trip.timeline.moments = Array<Moment>(count: momentsRecords.count, repeatedValue: Moment())
//                            
//                            var i : Int = 0
//                            
//                            for momentRecordObj in momentsRecords {
//                                
//                                let momentRecord : CKRecord = momentRecordObj as! CKRecord
//                                
//                                trip.timeline.moments[i].category = momentRecord.valueForKey("category") as! NSNumber
//                                
//                                trip.timeline.moments[i].comment = momentRecord.valueForKey("comment") as! String
//                                
//                                trip.timeline.moments[i].geoTag = momentRecord.valueForKey("geoTag")!
//                                
//                                trip.timeline.moments[i].dateOfCreation = momentRecord.valueForKey("dateOfCreation") as! NSDate
//                                
//                                i++
//                            }
//                            
//                            println("Viagem obtida com sucesso!")
//                        }
//                    })
//                    
//                }
//            }
//        })
//    }
//    
//    func fetchAllTrips() {
//        
//        let tripQuery : CKQuery = CKQuery(recordType: "Trip", predicate: NSPredicate(format: "TRUEPREDICATE"))
//        
//        tripQuery.sortDescriptors = [NSSortDescriptor(key: "beginDate", ascending: false), NSSortDescriptor(key: "endDate", ascending: false)]
//        
//        privateDB.performQuery(tripQuery, inZoneWithID: CKRecordZone.defaultRecordZone().zoneID) { (tripsRecords, error) -> Void in
//            
//            if let err = error {
//                
//                println("Erro ao pegar todas as viagens. O erro foi: \(err)")
//            }
//            else {
//                
//                
//            }
//        }
//    }
//    
//    func deleteTrip(trip: Trip) {
//        
//        let tripID : CKRecordID = dao.getTripID(trip)
//        
//        let deleteOperation : CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [tripID])
//        
//        deleteOperation.savePolicy = CKRecordSavePolicy.AllKeys
//        
//        deleteOperation.modifyRecordsCompletionBlock = { added, deleted, error in
//        
//            if let err = error {
//                
//                println("Erro ao deletar viagem. O erro foi: \(err)")
//            }
//        }
//        
//        privateDB.addOperation(deleteOperation)
//    }
//    
//    private func getTripID(trip: Trip) -> CKRecordID {
//    
//        return CKRecordID(recordName: "\(trip.beginDate)bd\(trip.endDate)ed\(trip.destination)dt")
//    }
//}