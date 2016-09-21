//
//  AddViewController.swift
//  MyAlbums
//
//  Created by Ethan Hess on 8/19/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class AddViewController: UIViewController {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var urlStringToSave : String?
    var album: Album!
    
    var recording = false

    @IBOutlet var recordButton: UIButton!
    
    func updateWithAlbum(album: Album) {
        
        self.album = album
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        urlStringToSave = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordOrStop(sender: AnyObject) {
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if allowed {
                        
                        self.startRecording()
                        
                    } else {
                        // TODO: actual error message
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }

    func startRecording() {
        
        if recording == false {
        
        let dateString = NSDate()
        
        let audioFilenameURL = getDocumentsDirectory().URLByAppendingPathComponent("recording\(dateString).m4a")
        let audioURL = audioFilenameURL
        
        self.urlStringToSave = String(audioURL)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recording = true
            
            recordButton.setTitle("Tap to Stop", forState: .Normal)
        } catch {
            finishRecording(success: false)
        }
        }
        
        else if recording == true {
            
            finishRecording(success: true)
            recording = false
        }
    }
    
    @IBAction func saveRecording(sender: AnyObject) {
        
        self.popAlert("Save", message: "Your song is awesome!")
        
    }
    
    func getDocumentsDirectory() -> NSURL {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        
        return NSURL(fileURLWithPath: documentsDirectory)
    }
    
    func finishRecording(success success: Bool) {
        
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            
            recordButton.setTitle("Record again!", forState: .Normal)
            
            
        } else {
            recordButton.setTitle("Record", forState: .Normal)
            // recording failed, pop error alert or something
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func popAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            
            textField.text = "Song Name"
        }
        
        let action = UIAlertAction(title: "Save", style: .Default) { (action) in
            
            let name = alertController.textFields![0].text
            let url = self.urlStringToSave
            
            if name != nil && url != nil {
                
                AlbumController.sharedManager.addSongToAlbum(self.album!, name: name!, urlString: url!)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            
        }
        
        let cancel = UIAlertAction(title: "Nevermind", style: .Cancel, handler: nil)
        
        alertController.addAction(action)
        alertController.addAction(cancel)
        
        presentViewController(alertController, animated: true, completion: nil) //maybe completion?
    }
    
    
    @IBAction func seeSongs(sender: AnyObject) {
        
        self.performSegueWithIdentifier(SONG_SEGUE, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == SONG_SEGUE {
            
            let songVC = segue.destinationViewController as! SongListViewController
            
            songVC.updateWithAlbum(album)
        }
    }

}

extension AddViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if !flag {
            finishRecording(success: false)
        }
    }
}