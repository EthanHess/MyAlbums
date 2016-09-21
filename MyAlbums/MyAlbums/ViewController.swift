//
//  ViewController.swift
//  MyAlbums
//
//  Created by Ethan Hess on 8/19/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    var imagePicker = UIImagePickerController()
    var chosenImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chosenImage = nil
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.refresh), name: "reload", object: nil)
    }
    
    func refresh() {
        collectionView.reloadData()
    }
    
    deinit {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func popImageViewController(sender: AnyObject) {
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum //check if available?
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func popAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            
            textField.placeholder = "Album title"
        }
        
        alertController.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action) in
            
            if self.chosenImage != nil {
                
                let image = self.chosenImage
                let title = alertController.textFields![0].text
                
                AlbumController.sharedManager.addAlbumWithName(title!, image: image!)
                
                self.refresh()
            }
        }))
        
        let cancelAction = UIAlertAction(title: "Never mind", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indexPaths = self.collectionView.indexPathsForSelectedItems()
        let indexPath = indexPaths?.first
        
        let album = AlbumController.sharedManager.albums[indexPath!.row]
        
        if segue.identifier == DETAIL_SEGUE {
            
            let addVC = segue.destinationViewController as! AddViewController
            
            addVC.updateWithAlbum(album)
        }
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return AlbumController.sharedManager.albums.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! AlbumCell
        
        let album = AlbumController.sharedManager.albums[indexPath.row]
        
        cell.backgroundImage.image = UIImage(data: album.imageData!)
        cell.nameLabel.text = album.name
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(160, 160)
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //pop alert with options eventually
        
        self.performSegueWithIdentifier(DETAIL_SEGUE, sender: nil)
        
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.chosenImage = image
        
        dismissViewControllerAnimated(true) { 
            
            self.popAlert("Add Album", message: "")
        }
    }
    
}