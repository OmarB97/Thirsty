//
//  UnwindCustomSegue.swift
//  #Thirsty
//
//  Created by Omar Baradei on 4/21/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit

class UnwindCustomSegue: UIStoryboardSegue {
    
    override func perform() {
        //set the ViewControllers for the animation
        
        let sourceView = self.source.view as UIView!
        let destinationView = self.destination.view as UIView!
        let window = UIApplication.shared.delegate?.window!
        
        // 1. beloveSubview
        window?.insertSubview(destinationView!, belowSubview: sourceView!)
        
        
        //2. y cordinate change
        destinationView?.center = CGPoint(x: (sourceView?.center.x)!, y: (sourceView?.center.y)! + (destinationView?.center.y)!)
        
        
        //3. create UIAnimation- change the views's position when present it
        UIView.animate(withDuration: 0.4,
                       animations: {
                        destinationView?.center = CGPoint(x: (sourceView?.center.x)!, y: (sourceView?.center.y)!)
                        sourceView?.center = CGPoint(x: (sourceView?.center.x)!, y: 0 - 2 * (destinationView?.center.y)!)
        }, completion: {
            (value: Bool) in
            //4. dismiss
            
            destinationView?.removeFromSuperview()
            if let navController = self.destination.navigationController {
                navController.popToViewController(self.destination, animated: false)
            }
            
            
        })
    }

//    override func perform() {
//        let firstVCView = self.source.view as UIView!
//        let secondVCView = self.destination.view as UIView!
//
//        // Get the screen width and height.
//        let screenWidth = UIScreen.main.bounds.size.width
//        let screenHeight = UIScreen.main.bounds.size.height
//        
//        // Specify the initial position of the destination view.
//        secondVCView?.frame = CGRect(x: 0.0, y: -screenHeight, width: screenWidth, height: screenHeight)
//        
//        // Access the app's key window and insert the destination view above the current (source) one.
//        let window = UIApplication.shared.keyWindow
//        window?.insertSubview(secondVCView!, aboveSubview: firstVCView!)
//        
//        // Animate the transition.
//        UIView.animate(withDuration: 0.35, animations: { () -> Void in
//            firstVCView?.frame = ((firstVCView?.frame)?.offsetBy(dx: 0.0, dy: screenHeight))!
//            secondVCView?.frame = (secondVCView?.frame.offsetBy(dx: 0.0, dy: screenHeight))!
//            
//        }) { (Finished) -> Void in
//            //self.source.present(self.destination, animated: false, completion: nil)
//            self.source.navigationController?.pushViewController(self.destination, animated: false)
//        }
//    }
}
