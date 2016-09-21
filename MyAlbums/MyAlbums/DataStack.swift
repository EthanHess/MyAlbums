//
//  DataStack.swift
//  MyAlbums
//
//  Created by Ethan Hess on 8/19/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit
import CoreData

class DataStack: NSObject {
    
    static let sharedManager = DataStack()

    var managedObjectContext : NSManagedObjectContext!
    
    override init() {
        super.init()
        
        setUpMOC()
    }
    
    func setUpMOC() {
        
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        self.managedObjectContext!.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel())
        
        do {
            try self.managedObjectContext!.persistentStoreCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.storeURL(), options: nil)
        } catch let error as NSError {
            
            print(error.localizedDescription)
        }
    }
    
    func storeURL() -> NSURL? {
        
        let documentsDirectory = try? NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true)
        
        return documentsDirectory?.URLByAppendingPathComponent("db.sqlite")
    }
    
    func modelURL() -> NSURL {
        return NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
    }
    
    func managedObjectModel() -> NSManagedObjectModel {
        return NSManagedObjectModel(contentsOfURL: self.modelURL())!
    }
}
