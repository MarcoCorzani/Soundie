//
//  NewSoundViewController.swift
//  Soundie
//
//  Created by Marco F.A. Corzani on 31.10.14.
//  Copyright (c) 2014 Alphaweb. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData



class NewSoundViewController : UIViewController {

    required init(coder aDecoder: NSCoder) {
        
        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        
        self.audioURL = NSUUID().UUIDString + ".m4a"
        var pathComponents = [baseString, self.audioURL]
        var audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        var recordSettings: [NSObject : AnyObject] = Dictionary()
        recordSettings[AVFormatIDKey] = kAudioFormatMPEG4AAC
        recordSettings[AVSampleRateKey] = 44100.0
        recordSettings[AVNumberOfChannelsKey] = 2
        
        self.audioRecorder = AVAudioRecorder(URL: audioNSURL, settings: recordSettings, error: nil)
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        
        //super init is below
        super.init(coder: aDecoder)
        
        
    }

    
    @IBOutlet weak var newSoundTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    
    
    var audioRecorder:AVAudioRecorder
    var audioURL : String
    var previousViewController = SoundListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ab hier gehts los!
    }

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        //Geht zurück
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveTapped(sender: AnyObject) {
        
        // Save Sound to CoreData
        var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        
        //Create a sound object
        
        var sound = NSEntityDescription.insertNewObjectForEntityForName("Sound", inManagedObjectContext: context) as Sound
        sound.name = self.newSoundTextField.text
        sound.url = self.audioURL
        context.save(nil)
        
        
        
        //Dismiss ViewController
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func recordTapped(sender: UIButton) {
        
        if self.audioRecorder.recording {
            self.audioRecorder.stop()
            self.recordButton.setTitle("Record", forState: UIControlState.Normal)
            
        } else {
            var session = AVAudioSession.sharedInstance()
            session.setActive(true, error: nil)
            self.audioRecorder.record()
            self.recordButton.setTitle("Finish Recording", forState: UIControlState.Normal)
            
            }
        
        
        
    }

}
