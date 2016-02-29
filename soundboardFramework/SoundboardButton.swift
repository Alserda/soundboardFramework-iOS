//
//  SoundboardButton.swift
//  soundboardFramework
//
//  Created by Peter Alserda on 29/02/16.
//  Copyright © 2016 Peter Alserda. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class SoundboardButton: UIButton {
    let realm = try! Realm()
    var audioPlayer = AVAudioPlayer()
    
    func setup(audioButton audioButton: AudioButton) {
        let buttonStyle = audioButton.buttonStyle!
        self.tag = audioButton.id
        self.backgroundColor = UIColor(hexString: buttonStyle.backgroundColor)
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(buttonStyle.cornerRadius)
        self.setTitle(audioButton.title, forState: .Normal)
        self.titleLabel?.textColor = UIColor(hexString: buttonStyle.fontColor)
        self.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        
        print("something, ", __FUNCTION__, audioButton)
        self.frame = CGRectMake(CGFloat(audioButton.x),
            CGFloat(audioButton.y),
            CGFloat(audioButton.width),
            CGFloat(audioButton.height))
        
        if let fontStyle = buttonStyle.fontStyle {
            let fontName: String = "\(buttonStyle.fontFamily)-\(fontStyle)"
            self.titleLabel?.font = UIFont(name: fontName, size: CGFloat(buttonStyle.fontSize))
        } else {
            self.titleLabel?.font = UIFont(name: audioButton.buttonStyle!.fontFamily, size: CGFloat(audioButton.buttonStyle!.fontSize))
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
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
}
