//
//  SoundboardViewController.swift
//  soundboardFramework
//
//  Created by Peter Alserda on 01/03/16.
//  Copyright © 2016 Peter Alserda. All rights reserved.
//

import UIKit
import RealmSwift

class SoundboardDetail: UIViewController {
    var soundboard: Soundboard = Soundboard()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(hexString: "#FADFAD")
        navigationController?.navigationBarHidden = true
        print(soundboard.statusBarStyle)
        removeLoadingSoundboardFromStack()
        styleApplication()
        addBackButton()
        addSettingsButton()
    }
    
    func addSettingsButton() {
        let navigationBarHeight = navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        let settingsImage: UIImage = UIImage(named: "gear")!.imageWithRenderingMode(.AlwaysTemplate)
        let settingsButton = UIImageView(image: settingsImage)
        settingsButton.tintColor = UIColor(hexString: soundboard.backButtonColor) //todo: add option for this

        
        let singleFingerTap = UITapGestureRecognizer(target: self, action: "settingsButtonPressed:")
        let settingsButtonContainer: UIView = UIView(frame: CGRectMake((CGRectGetMaxX(view.frame) - navigationBarHeight), statusBarHeight, navigationBarHeight, navigationBarHeight))
        settingsButton.frame = CGRectMake((settingsButtonContainer.frame.width - 30), 12, 21, 21)
        print(settingsButtonContainer.frame)
        settingsButtonContainer.addSubview(settingsButton)
        settingsButtonContainer.addGestureRecognizer(singleFingerTap)
        
        view.addSubview(settingsButtonContainer)
    }
    
    func settingsButtonPressed(sender: UIButton) {
        showConfirmationMessage(title: "Remove?", message: "Are you sure that you want to remove this soundboard?", confirmTitle: "Yes, remove it", declineTitle: "No") { (result) -> () in
            self.removeSoundboard()
            self.customPopTransition(withDuration: 0.5)
            self.navigationController?.popViewControllerAnimated(false)
        }
    }
    
    func removeSoundboard() {
        print(__FUNCTION__)
        try! realm.write({ () -> Void in
            realm.delete((soundboard.audioButtons.first?.buttonStyle)!)
            realm.delete(soundboard.audioButtons)
            realm.delete(soundboard)
        })
    }
    
    func addBackButton() {
        let navigationBarHeight = navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height

        let backButtonImage: UIImage = UIImage(named: "back-chevron")!.imageWithRenderingMode(.AlwaysTemplate)
        let backButton = UIImageView(image: backButtonImage)
        backButton.tintColor = UIColor(hexString: soundboard.backButtonColor)
        backButton.frame = CGRectMake(9, 12, 12.5, 21)

        let singleFingerTap = UITapGestureRecognizer(target: self, action: "backButtonPressed:")
        let backButtonContainer: UIView = UIView(frame: CGRectMake(0, statusBarHeight, navigationBarHeight, navigationBarHeight))
        backButtonContainer.addSubview(backButton)
        backButtonContainer.addGestureRecognizer(singleFingerTap)
        
        view.addSubview(backButtonContainer)
    }
    
    func backButtonPressed(sender: UIButton) {
        print(__FUNCTION__)
        
        customPopTransition(withDuration: 0.5)
        navigationController?.popViewControllerAnimated(false)
    }
    
    func removeLoadingSoundboardFromStack() {
        let viewControllers: NSMutableArray = NSMutableArray(array: navigationController!.viewControllers)
        for vc in viewControllers {
            if vc is LoadingSoundboard {
                viewControllers.removeObjectIdenticalTo(vc)
                navigationController?.viewControllers = NSArray(array: viewControllers) as! Array<UIViewController>
            }
        }
    }
    
    func backToRootButtonPressed(sender: UIButton) {
        print(__FUNCTION__)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func styleApplication() {
        if (soundboard.backgroundImage != nil) {
            let image = UIImage(data: soundboard.backgroundImage!)
            
            let navigationBarHeight: CGFloat = (self.navigationController!.navigationBar.frame.height +
                UIApplication.sharedApplication().statusBarFrame.size.height)
            print(navigationBarHeight)
            let backgroundImage = UIImageView(image: image)
            backgroundImage.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
            backgroundImage.contentMode = .ScaleAspectFill
            self.view.addSubview(backgroundImage)
        } else {
            self.view.backgroundColor = UIColor(hexString: soundboard.backgroundColor)
        }
        
        for audioButton in soundboard.audioButtons {
            let soundboardButton = SoundboardButton(audioButton: audioButton)
            
            self.view.addSubview(soundboardButton)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        switch soundboard.statusBarStyle {
        case "Light":
            return .LightContent
        default:
            return .Default
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        print(__FUNCTION__)
        navigationController?.navigationBarHidden = false
    }
}
