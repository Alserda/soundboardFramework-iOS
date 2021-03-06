//
//  ViewController.swift
//  soundboardFramework
//
//  Created by Peter Alserda on 27/02/16.
//  Copyright © 2016 Peter Alserda. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    let backendConnection = BackendConnection.sharedInstance
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(__FUNCTION__)
//        print(UIFont.familyNames())

        fetchSoundboardData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func fetchSoundboardData() {
        backendConnection.fetchSoundboard("2", success: { (response) -> () in
            let soundboard = Soundboard()
            soundboard.id = response["id"].intValue
            soundboard.backgroundColor = response["data"]["backgroundColor"].stringValue
            soundboard.headerTitle = response["data"]["headerTitle"].stringValue
            let backgroundImageURL = response["data"]["backgroundImageURL"].stringValue
            if (!backgroundImageURL.isEmpty) {
                soundboard.backgroundImageURL = backgroundImageURL
            }
            
            
            let buttonStyle = ButtonStyle()
            let retrievedButtonStyle = response["data"]["buttonStyle"]
            buttonStyle.id = retrievedButtonStyle["id"].intValue
            buttonStyle.backgroundColor = retrievedButtonStyle["backgroundColor"].stringValue
            buttonStyle.backgroundColorHighlighted = retrievedButtonStyle["backgroundColorHighlighted"].stringValue
            buttonStyle.bottomBorderColor = retrievedButtonStyle["bottomBorderColor"].stringValue
            buttonStyle.cornerRadius = retrievedButtonStyle["cornerRadius"].floatValue
            buttonStyle.fontColor = retrievedButtonStyle["font"]["color"].stringValue
            buttonStyle.fontFamily = retrievedButtonStyle["font"]["family"].stringValue
            buttonStyle.fontSize = retrievedButtonStyle["font"]["size"].intValue
            buttonStyle.fontStyle = retrievedButtonStyle["font"]["style"].stringValue
            
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
        if (soundboard.backgroundImage != nil) {
            let image = UIImage(data: soundboard.backgroundImage!)
            let backgroundImage = UIImageView(image: image)
            backgroundImage.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
            backgroundImage.contentMode = .ScaleAspectFill
            self.view.addSubview(backgroundImage)
        } else {
            self.view.backgroundColor = UIColor(hexString: soundboard.backgroundColor)
        }
        
        
//        let label = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 21))
//        label.center = CGPointMake(self.view.frame.width / 2, 50)
//        label.textAlignment = NSTextAlignment.Center
//        label.text = soundboard.headerTitle
//        self.view.addSubview(label)

        for audioButton in soundboard.audioButtons {
            let soundboardButton = SoundboardButton(audioButton: audioButton)

            self.view.addSubview(soundboardButton)
        }
    }
    
}

