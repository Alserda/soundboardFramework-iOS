//
//  SoundboardViewController.swift
//  soundboardFramework
//
//  Created by Peter Alserda on 01/03/16.
//  Copyright © 2016 Peter Alserda. All rights reserved.
//

import UIKit

class SoundboardDetail: UIViewController {
    var soundboard: Soundboard = Soundboard()
    
    override func viewDidLoad() {
        print("SoundboardDetail, ", __FUNCTION__)
        view.backgroundColor = UIColor(hexString: "#FADFAD")
        navigationController?.navigationBarHidden = true
        removeLoadingSoundboardFromStack()
        styleApplication()
        addBackButton()
    }
    
    func addBackButton() {
        let navigationBarHeight = navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height

        let backBtnImage: UIImage = UIImage(named: "ios9-back-arrow")!
        let backBtn: UIButton = UIButton(type: .Custom)
        backBtn.setBackgroundImage(backBtnImage, forState: .Normal)
        backBtn.addTarget(self, action: "backButtonPressed:", forControlEvents: .TouchUpInside)
        backBtn.frame = CGRectMake(9, 12, 12.5, 21)
        
        let singleFingerTap = UITapGestureRecognizer(target: self, action: "backButtonPressed:")
        let backButtonView: UIView = UIView(frame: CGRectMake(0, statusBarHeight, navigationBarHeight, navigationBarHeight))
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, 0, 0)
        backButtonView.addSubview(backBtn)
        backButtonView.addGestureRecognizer(singleFingerTap)
        
        view.addSubview(backButtonView)
    }
    
    func backButtonPressed(sender: UIButton) {
        print(__FUNCTION__)
        navigationController?.popViewControllerAnimated(true)
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
    
    override func viewWillDisappear(animated: Bool) {
        print(__FUNCTION__)
        navigationController?.navigationBarHidden = false
    }
}
