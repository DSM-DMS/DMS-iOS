//
//  File.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 6. 9..
//  Copyright © 2017년 이병찬. All rights reserved.
//
import UIKit

extension UIViewController : UIGestureRecognizerDelegate {
    
    func showToast(message : String, down: Bool = true) {
        var ySize = CGFloat(100)
        if down{
            ySize = self.view.frame.size.height - 125
        }
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: ySize, width: 160, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func setBackGesture(){
        let swipeLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if (gesture as! UISwipeGestureRecognizer).direction == UISwipeGestureRecognizerDirection.right{
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func getDarkBlueColor() -> UIColor{
        return UIColor.init(red: 86/255, green: 141/255, blue: 168/255, alpha: 1)
    }
    
}
