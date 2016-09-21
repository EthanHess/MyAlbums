//
//  SongListViewController.swift
//  MyAlbums
//
//  Created by Ethan Hess on 8/21/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit

class SongListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var album : Album!
    
    func updateWithAlbum(album: Album) {
        
        self.album = album
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SongListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.album.songs!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("songCell")! as UITableViewCell
        
        let song = self.album.songs![indexPath.row] as! Song
        
        cell.textLabel?.text = song.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let song = self.album.songs![indexPath.row] as! Song
        let urlString = song.urlString
        
        let url = NSURL(string: urlString!)
        
        SoundPlayer.sharedInstance.playAudioFileAtURL(url!)
    }
} 