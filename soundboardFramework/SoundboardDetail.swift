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
        view.backgroundColor = UIColor(hexString: "#bdc3c7")
        navigationController?.navigationBarHidden = false
        removeLoadingSoundboardFromStack()
        styleApplication()
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
            backgroundImage.frame = CGRectMake(0, navigationBarHeight, self.view.frame.width, self.view.frame.height)
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
}
