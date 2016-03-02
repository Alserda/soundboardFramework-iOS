//
//  LoadingSoundboard.swift
//  soundboardFramework
//
//  Created by Peter Alserda on 01/03/16.
//  Copyright © 2016 Peter Alserda. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class LoadingSoundboard: UIViewController {
    let backendConnection = BackendConnection.sharedInstance
    var recievedJSON: JSON = []
    let realm = try! Realm()
    var progressView: UIProgressView?
    var progressLabel: UILabel?

    
    override func viewDidLoad() {
        navigationController?.navigationBarHidden = true
        view.backgroundColor = UIColor.whiteColor()
        addProgressInformation()

        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "storeSoundboard", userInfo: nil, repeats: false)
    }
    
    func addProgressInformation() {
        progressView = UIProgressView(progressViewStyle: .Default)
        progressView?.center = self.view.center
        progressView?.progress = 0
        view.addSubview(progressView!)
        
        progressLabel = UILabel(frame: CGRectMake(0, view.center.y - 100, view.frame.width, 50))
        progressLabel?.textAlignment = .Center
        progressLabel?.text = "Saving the soundboard.."
        
        view.addSubview(progressLabel!)
    }
    
    func storeSoundboard() {
        print(__FUNCTION__)
        let soundboard = Soundboard()
        soundboard.id = recievedJSON["id"].intValue
        soundboard.backgroundColor = recievedJSON["data"]["backgroundColor"].stringValue
        soundboard.backButtonColor = recievedJSON["data"]["backButtonColor"].stringValue
        soundboard.statusBarStyle = recievedJSON["data"]["statusBarStyle"].stringValue
        soundboard.headerTitle = recievedJSON["data"]["headerTitle"].stringValue
        let backgroundImageURL = recievedJSON["data"]["backgroundImageURL"].stringValue
        if (!backgroundImageURL.isEmpty) {
            soundboard.backgroundImageURL = backgroundImageURL
        }
        
        
        let buttonStyle = ButtonStyle()
        let retrievedButtonStyle = recievedJSON["data"]["buttonStyle"]
        buttonStyle.id = retrievedButtonStyle["id"].intValue
        buttonStyle.backgroundColor = retrievedButtonStyle["backgroundColor"].stringValue
        buttonStyle.backgroundColorHighlighted = retrievedButtonStyle["backgroundColorHighlighted"].stringValue
        buttonStyle.bottomBorderColor = retrievedButtonStyle["bottomBorderColor"].stringValue
        buttonStyle.cornerRadius = retrievedButtonStyle["cornerRadius"].floatValue
        buttonStyle.fontColor = retrievedButtonStyle["font"]["color"].stringValue
        buttonStyle.fontFamily = retrievedButtonStyle["font"]["family"].stringValue
        buttonStyle.fontSize = retrievedButtonStyle["font"]["size"].intValue
        buttonStyle.fontStyle = retrievedButtonStyle["font"]["style"].stringValue
        
        for (_, _audioButton) in recievedJSON["data"]["audioFiles"] {
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
                    self.progressView?.progress += 0.10
                    self.presentSoundboardDetail(withSoundboard: soundboard)
                })
            } else {
                // Style the application because there is no image
                print("Style the application because there is no image")
                self.progressView?.progress += 0.10
                self.presentSoundboardDetail(withSoundboard: soundboard)
            }
        })
    }
    
    func obtainAudioFileData(soundboard: Soundboard, closure: (finished: Bool) -> ()) {
        progressView?.progress += 0.10
        progressLabel?.text = "Retrieving audiofiles..."
        let addedProgress: Float = (Float(0.80) / Float(soundboard.audioButtons.count))
        var counter = 0
        for audioFile in soundboard.audioButtons {
            backendConnection.fetchAudioFile(audioFile.url, success: { (response) -> () in
                audioFile.data = response
                try! self.realm.write({ () -> Void in
                    self.realm.add(audioFile, update: true)
                })
                counter += 1
                self.progressView?.progress += addedProgress
                if (counter == soundboard.audioButtons.count) {
                    closure(finished: true)
                }
                }, failed: { (error) -> () in
                    print(error)
            })
        }
    }
    
    func obtainBackgroundImage(soundboard: Soundboard, closure: (finished: Bool) -> ()) {
        progressLabel?.text = "Saving background-image..."
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

    func presentSoundboardDetail(withSoundboard soundboard: Soundboard) {
        customPushTransition(withDuration: 0.6)
        let soundboardDetail = SoundboardDetail()
        soundboardDetail.soundboard = soundboard
        navigationController?.pushViewController(soundboardDetail, animated: false)
    }
}
