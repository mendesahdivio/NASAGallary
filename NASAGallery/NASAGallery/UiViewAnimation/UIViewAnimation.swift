//
//  UIViewAnimation.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 01/09/22.
//

import Foundation
import UIKit
extension UIView {
    func fadeIn(duration: TimeInterval = 0.2, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
       self.alpha = 0.0

       UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
           self.isHidden = false
           self.alpha = 1.0
       }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.2, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
       self.alpha = 1.0

       UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
           self.alpha = 0.0
       }) { (completed) in
           self.isHidden = true
           completion(true)
       }
     }
    
    
    func slideInFromLeft(duration: TimeInterval = 0.1, completionDelegate: AnyObject? = nil) {
        let slideInFromLeftTransition = CATransition()
        slideInFromLeftTransition.type = CATransitionType.push
        slideInFromLeftTransition.subtype = CATransitionSubtype.fromRight
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromLeftTransition.fillMode = CAMediaTimingFillMode.removed
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
      }
    
    
    func slideInFromRight(duration: TimeInterval = 0.1, completionDelegate: AnyObject? = nil) {
        let slideInFromLeftTransition = CATransition()
        slideInFromLeftTransition.type = CATransitionType.push
        slideInFromLeftTransition.subtype = CATransitionSubtype.fromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromLeftTransition.fillMode = CAMediaTimingFillMode.removed
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromRightTransition")
      }
}
