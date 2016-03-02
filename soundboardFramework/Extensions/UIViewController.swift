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
}