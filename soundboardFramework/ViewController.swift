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
        print(UIFont.familyNames())

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
            let backgroundImageURL = response["data"]["backgroundImageURL"].stringValue
            if (!backgroundImageURL.isEmpty) {
                soundboard.backgroundImageURL = backgroundImageURL
            }

            
            let buttonStyle = ButtonStyle()
            buttonStyle.cornerRadius = response["data"]["buttonStyle"]["cornerRadius"].floatValue
            buttonStyle.backgroundColor = response["data"]["buttonStyle"]["backgroundColor"].stringValue
            buttonStyle.fontColor = response["data"]["buttonStyle"]["font"]["color"].stringValue
            buttonStyle.fontFamily = response["data"]["buttonStyle"]["font"]["family"].stringValue
            buttonStyle.fontSize = response["data"]["buttonStyle"]["font"]["size"].intValue
            buttonStyle.fontStyle = response["data"]["buttonStyle"]["font"]["style"].stringValue

            for (_, _audioButton) in response["data"]["audioFiles"] {
                let audioButton = AudioButton()
                audioButton.id = _audioButton["id"].intValue
                audioButton.title = _audioButton["title"].stringValue
                audioButton.url = _audioButton["url"].stringValue
                audioButton.x = _audioButton["positioning"]["x"].floatValue
                audioButton.y = _audioButton["positioning"]["y"].floatValue
                audioButton.width = _audioButton["positioning"]["width"].floatValue
                audioButton.height = _audioButton["positioning"]["height"].floatValue
                audioButton.buttonStyle = buttonStyle
                soundboard.audioButtons.append(audioButton)
            }
            
            try! self.realm.write({ () -> Void in
                self.realm.create(Soundboard.self, value: soundboard, update: true)
            })

            self.obtainAudioFileData(soundboard, closure: { (finished) -> () in
                if ((soundboard.backgroundImageURL?.isEmpty) != nil) {
                    // Retrieve the image because there is an URL, then style the application
                    print("Retrieve the image because there is an URL, then style the application")
                    self.obtainBackgroundImage(soundboard, closure: { (finished) -> () in
                        self.styleApplication(soundboard)
                    })
                } else {
                    // Style the application because there is no image
                    print("Style the application because there is no image")
                    self.styleApplication(soundboard)
                }
            })
            }) { (error) -> () in
                print(error)
        }
    }
    
    func obtainBackgroundImage(soundboard: Soundboard, closure: (finished: Bool) -> ()) {
        backendConnection.fetchBackgroundImage(soundboard.backgroundImageURL!, success: { (response) -> () in
            soundboard.backgroundImage = response
            try! self.realm.write({ () -> Void in
                self.realm.add(soundboard, update: true)
            })
            closure(finished: true)
            
            }) { (error) -> () in
                print(error)
        }
    }
    
    func obtainAudioFileData(soundboard: Soundboard, closure: (finished: Bool) -> ()) {
        var counter = 0
        for audioFile in soundboard.audioButtons {
            backendConnection.fetchAudioFile(audioFile.url, success: { (response) -> () in
                audioFile.data = response
                try! self.realm.write({ () -> Void in
                    self.realm.add(audioFile, update: true)
                })
                counter += 1
                if (counter == soundboard.audioButtons.count) {
                    closure(finished: true)
                }
                }, failed: { (error) -> () in
                    print(error)
            })
        }
        
    }
    func styleApplication(soundboard: Soundboard) {
        self.view.backgroundColor = UIColor(hexString: soundboard.backgroundColor)
        
        if (soundboard.backgroundImage == nil) {
            print("There isnt a background image, use default color")
        } else {
            print("There is a background image, use this!")
        }
        
        
        let label = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 21))
        label.center = CGPointMake(self.view.frame.width / 2, 50)
        label.textAlignment = NSTextAlignment.Center
        label.text = soundboard.headerTitle
        self.view.addSubview(label)

        for audioButton in soundboard.audioButtons {
            let button = UIButton(type: .Custom)
            let buttonStyle = audioButton.buttonStyle!
            button.layer.cornerRadius = CGFloat(audioButton.buttonStyle!.cornerRadius)
            button.backgroundColor = UIColor(hexString: audioButton.buttonStyle!.backgroundColor)

            let buttonFrame = CGRectMake(   CGFloat(audioButton.x),
                                            CGFloat(audioButton.y),
                                            CGFloat(audioButton.width),
                                            CGFloat(audioButton.height))
            button.frame = buttonFrame
            button.clipsToBounds = true
            button.setTitle(audioButton.title, forState: UIControlState.Normal)
            button.titleLabel?.textColor = UIColor(hexString: audioButton.buttonStyle!.fontColor)
//            button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
            if let fontStyle = buttonStyle.fontStyle {
                let fontName: String = "\(buttonStyle.fontFamily)-\(fontStyle)"
                button.titleLabel?.font = UIFont(name: fontName, size: CGFloat(buttonStyle.fontSize))
            } else {
                button.titleLabel?.font = UIFont(name: audioButton.buttonStyle!.fontFamily, size: CGFloat(audioButton.buttonStyle!.fontSize))
            }

            button.tag = audioButton.id
            button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
            self.view.addSubview(button)
        }
    }
    
    func buttonPressed(sender: UIButton!) {
        let audioFile = self.realm.objectForPrimaryKey(AudioButton.self, key: sender.tag)
        do {
            try audioPlayer = AVAudioPlayer(data: (audioFile?.data!)!)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("error")
        }
        
        
        
    }
}

