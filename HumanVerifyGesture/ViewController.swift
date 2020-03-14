//
//  ViewController.swift
//  HumanVerifyGesture
//
//  Created by Shebin Koshy on 02/07/17.
//  Copyright © 2017 Shebin Koshy. All rights reserved.
//

import UIKit

class ViewController: UIViewController,HVGViewDelegate,UIGestureRecognizerDelegate {
    
    var labelResult : UILabel?
    var buttonTryAgain : UIButton?
    var viewHVG : HVGView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelResult = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 150, width: UIScreen.main.bounds.size.width, height: 30))
        labelResult!.textAlignment = NSTextAlignment.center
        labelResult!.textColor = UIColor.black
        self.view.addSubview(labelResult!)
        
        buttonTryAgain = UIButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 100, width: UIScreen.main.bounds.size.width, height: 30))
        buttonTryAgain?.setTitleColor(self.view.tintColor, for: UIControl.State.normal)
        buttonTryAgain!.setTitle("Try Again", for: UIControl.State.normal)
        buttonTryAgain!.isExclusiveTouch = true
        buttonTryAgain?.addTarget(self, action: #selector(buttonAction(_:)), for: UIControl.Event.touchUpInside)
//        self.view.gestureR
        self.view.addSubview(buttonTryAgain!)
        
        
        
        viewHVG = HVGView(frame: self.view.frame, letter: "a")
        self.HVGCleared(view: viewHVG!)
        viewHVG?.delegate = self
        self.view.addSubview(viewHVG!)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func HVGResult(view:HVGView, isSuccess: Bool!) {
        self.labelResult!.isHidden = false
        self.buttonTryAgain!.isHidden = false
        if (isSuccess == true)
        {
            self.labelResult!.text = "Success";
        }
        else
        {
            self.labelResult!.text = "Failed";
        }

    }
    
    func HVGCleared(view:HVGView) {
        self.buttonTryAgain!.isHidden = true
        self.labelResult!.isHidden = true
    }
    
    @objc func buttonAction(_ sender: Any) {
        viewHVG?.clear()
    }
    
     public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if (gestureRecognizer.view?.isEqual(buttonTryAgain))!
        {
            return true
        }
        return false
    }
    
     public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
     {
        if (gestureRecognizer.view?.isEqual(buttonTryAgain))!
        {
            return true
        }
        return false
    }
    
}

