//
//  SoundListViewController.swift
//  Soundie
//
//  Created by Marco F.A. Corzani on 31.10.14.
//  Copyright (c) 2014 Alphaweb. All rights reserved.
//

import UIKit
import AVFoundation //Für Sound
import CoreData

class SoundListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    var audioPlayer = AVAudioPlayer()
    
    //Ein leeres Array wird erzeugt, aus Sound, in Sound.swift deffiniert
    var sounds:[Sound] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        self.tableView.dataSource = self
        self.tableView.delegate = self
}

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Roll tide...
        var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        var request = NSFetchRequest(entityName: "Sound")
        self.sounds = context.executeFetchRequest(request, error: nil)! as [Sound]
    
    
    }
    
    // Anzahl rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sounds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var sound = self.sounds[indexPath.row]
        
        var cell = UITableViewCell()
        //Inhalt der Zelle
        
        cell.textLabel!.text = sound.name
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var sound = self.sounds[indexPath.row]
      
        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        
        
        var pathComponents = [baseString, sound.url]
        var audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)
        
        self.audioPlayer = AVAudioPlayer(contentsOfURL: audioNSURL, error: nil)
        self.audioPlayer.play()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    //Hilfeeeeee
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var nextViewController = segue.destinationViewController as NewSoundViewController
        nextViewController.previousViewController = self
    }
}

