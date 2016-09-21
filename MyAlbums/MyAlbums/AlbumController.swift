//
//  AlbumController.swift
//  MyAlbums
//
//  Created by Ethan Hess on 8/19/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit
import CoreData

class AlbumController: NSObject {
    
    static let sharedManager = AlbumController()
    
    var albums : [Album] {
        get {
            
            return (try? DataStack.sharedManager.managedObjectContext.executeFetchRequest(NSFetchRequest(entityName: "Album"))) as! Array
        
        }
    }
    
    func addAlbumWithName(name: String, image: UIImage) {
        
        let album = NSEntityDescription.insertNewObjectForEntityForName("Album", inManagedObjectContext: DataStack.sharedManager.managedObjectContext) as! Album
        
        album.name = name
        album.imageData = NSData(data: UIImageJPEGRepresentation(image, 100)!)
        
        save()
    }

    func addSongToAlbum(album: Album, name: String, urlString: String) {
        
        let song = NSEntityDescription.insertNewObjectForEntityForName("Song", inManagedObjectContext: DataStack.sharedManager.managedObjectContext) as! Song
        
        song.name = name
        song.urlString = urlString
        song.album = album
        
        save()
        
    }
    
    //eventually be able to remove song too
    
    func removeAlbum(album: Album) {
        
        album.managedObjectContext?.deleteObject(album)
        save()
    }
    
    func save() {
        
        do {
            
            try DataStack.sharedManager.managedObjectContext.save()
            
        }
            
        catch _ {
            
            //catch error here
        }
    }
}
