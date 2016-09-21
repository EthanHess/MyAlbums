//
//  SoundPlayer.swift
//  MyAlbums
//
//  Created by Ethan Hess on 8/21/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit
import AVFoundation

class SoundPlayer: NSObject {
    
    var player : AVAudioPlayer!
    
    static let sharedInstance = SoundPlayer ()
    
    func playAudioFileAtURL(url: NSURL) {
        
        player = try! AVAudioPlayer(contentsOfURL: url)
        player.numberOfLoops = 0
        player.play()
        
    }
    
    func stop() {
        
        player.stop()
    }
}
