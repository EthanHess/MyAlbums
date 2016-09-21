//
//  Album+CoreDataProperties.swift
//  MyAlbums
//
//  Created by Ethan Hess on 8/21/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Album {

    @NSManaged var imageData: NSData?
    @NSManaged var name: String?
    @NSManaged var songs: NSOrderedSet?

}
