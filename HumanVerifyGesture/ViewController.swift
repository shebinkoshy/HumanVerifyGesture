//
//  ViewController.swift
//  HumanVerifyGesture
//
//  Created by Shebin Koshy on 02/07/17.
//  Copyright © 2017 Shebin Koshy. All rights reserved.
//

import UIKit
//import CoreGraphics

//import UIKit
//import CoreText


class ViewController: UIViewController,HVGViewDelegate {
    
    var labelResult : UILabel?
    var buttonTryAgain : UIButton?
    var viewHVG : HVG?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHVG = HVG(frame: self.view.frame)
        viewHVG?.delegate = self
        self.view.addSubview(viewHVG!)
        
        labelResult = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 150, width: UIScreen.main.bounds.size.width, height: 30))
        labelResult!.textAlignment = NSTextAlignment.center
        labelResult!.textColor = UIColor.black
        self.view.addSubview(labelResult!)
        
        buttonTryAgain = UIButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 100, width: UIScreen.main.bounds.size.width, height: 30))
        buttonTryAgain?.setTitleColor(self.view.tintColor, for: UIControlState.normal)
        buttonTryAgain!.setTitle("Try Again", for: UIControlState.normal)
        buttonTryAgain!.isExclusiveTouch = true
        buttonTryAgain?.addTarget(self, action: #selector(buttonAction(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(buttonTryAgain!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func HVGResult(view:HVG, isSuccess: Bool!) {
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
    
    func HVGCleared(view:HVG) {
        self.buttonTryAgain!.isHidden = true
        self.labelResult!.isHidden = true
    }
    
    func buttonAction(_ sender: Any) {
        viewHVG?.clear()
    }
    
}

