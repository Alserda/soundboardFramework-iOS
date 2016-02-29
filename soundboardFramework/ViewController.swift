//
//  ViewController.swift
//  soundboardFramework
//
//  Created by Peter Alserda on 27/02/16.
//  Copyright © 2016 Peter Alserda. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class ViewController: UIViewController {
    let backendConnection = BackendConnection.sharedInstance
    let realm = try! Realm()
    var audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(__FUNCTION__)
        fetchSoundboardData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func fetchSoundboardData() {
        backendConnection.fetchSoundboard({ (response) -> () in
            print(response)
            let soundboard = Soundboard()
            soundboard.id = response["id"].intValue
            soundboard.backgroundColor = response["data"]["backgroundColor"].stringValue
            soundboard.headerTitle = response["data"]["headerTitle"].stringValue

            for (_, _audioFile) in response["data"]["audioFiles"] {
                let audioFile = AudioFile()
                audioFile.id = _audioFile["id"].intValue
                audioFile.title = _audioFile["title"].stringValue
                audioFile.url = _audioFile["url"].stringValue

                soundboard.audioFiles.append(audioFile)
            }
            
            let buttonStyle = ButtonStyle()
            //get buttonstyle ID
            buttonStyle.cornerRadius = response["data"]["buttonStyle"]["cornerRadius"].floatValue
            buttonStyle.backgroundColor = response["data"]["buttonStyle"]["backgroundColor"].stringValue
            
            print("henkhenkhenkh", buttonStyle)
            
            try! self.realm.write({ () -> Void in
                self.realm.create(Soundboard.self, value: soundboard, update: true)
            })
            
            self.obtainAudioFileData(soundboard, closure: { (finished) -> () in
                print(finished)
                self.styleApplication(soundboard)
            })
            
            }) { (error) -> () in
                print(error)
        }
    }
    
    func obtainAudioFileData(soundboard: Soundboard, closure: (finished: Bool) -> ()) {
        var counter = 0
        for audioFile in soundboard.audioFiles {
            backendConnection.fetchAudioFile(audioFile.url, success: { (response) -> () in
                audioFile.data = response
                try! self.realm.write({ () -> Void in
                    self.realm.add(audioFile, update: true)
                })
                counter += 1
                if (counter == soundboard.audioFiles.count) {
                    closure(finished: true)
                }
                }, failed: { (error) -> () in
                    print(error)
            })
        }
        
    }
    func styleApplication(soundboard: Soundboard) {
        print(__FUNCTION__, soundboard)
        let label = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 21))
        label.center = CGPointMake(self.view.frame.width / 2, 50)
        label.textAlignment = NSTextAlignment.Center
        label.text = soundboard.headerTitle
        self.view.addSubview(label)
        self.view.backgroundColor = UIColor(hexString: soundboard.backgroundColor)
        for audioButton in soundboard.audioFiles {
            let button = UIButton(type: .Custom)
            button.layer.cornerRadius = 5
            button.backgroundColor = UIColor.redColor()
            button.frame = CGRectMake(100, 100, 250, 75)
            button.clipsToBounds = true
            button.setTitle(audioButton.title, forState: UIControlState.Normal)
            button.titleLabel?.textColor = UIColor.whiteColor()
            button.tag = audioButton.id
            button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
            self.view.addSubview(button)
        }
    }
    
    func buttonPressed(sender: UIButton!) {
        let audioFile = self.realm.objectForPrimaryKey(AudioFile.self, key: sender.tag)
        print(audioFile)
        
        do {
            try audioPlayer = AVAudioPlayer(data: (audioFile?.data!)!)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("error")
        }
        
        
        
    }
}

