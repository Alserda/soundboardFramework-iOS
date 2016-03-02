//
//  CATransition.swift
//  soundboardFramework
//
//  Created by Peter Alserda on 02/03/16.
//  Copyright © 2016 Peter Alserda. All rights reserved.
//

import UIKit

extension UIViewController {
    func customPushTransition(withDuration duration: CFTimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromRight
        self.navigationController!.view.layer.addAnimation(transition, forKey: nil)
    }
    
    func customPopTransition(withDuration duration: CFTimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        navigationController!.view.layer.addAnimation(transition, forKey: nil)
    }
    
    /* Extention for confirmation messages. */
    func showConfirmationMessage(title title: String, message: String, confirmTitle: String, declineTitle: String, completion: (result: Bool?) -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: confirmTitle, style: .Destructive, handler: { (action) -> Void in
            completion(result: true)
        }))
        alertController.addAction(UIAlertAction(title: declineTitle, style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /* Extention for showing error messages. */
    func showErrorMessage(title title: String, message: String, dismisstitle: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: dismisstitle, style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}