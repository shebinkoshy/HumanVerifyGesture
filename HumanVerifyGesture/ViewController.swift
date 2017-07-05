//
//  ViewController.swift
//  HumanVerifyGesture
//
//  Created by Shebin Koshy on 02/07/17.
//  Copyright © 2017 Shebin Koshy. All rights reserved.
//

import UIKit
import CoreGraphics

import UIKit
import CoreText
//import XCPlayground


class ViewController: UIViewController {
    
    var mouseSwiped : Bool?
    var lastPoint : CGPoint?
    let brush = 3.0
    var path: UIBezierPath?
    var isSucceed : Bool?
    
    @IBOutlet weak var labelResult: UILabel!
   
    @IBOutlet weak var buttonTryAgain: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var tempDrawImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.buttonTryAgain.isExclusiveTouch = true
        self.clear()
        let font = UIFont(name: "HelveticaNeue", size: 456)!
        
        var unichars = [UniChar]("k".utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
//        var glyphs = [CGGlyph](count: unichars.count, repeatedValue: 0)
//        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        if gotGlyphs {
            let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)!
//            cgpath.
            path = UIBezierPath.init(cgPath: cgpath)
            let layer = CAShapeLayer.init()
//            let b = getPathForLetter(letter: "K") as UIBezierPath
            let actualPathRect = path?.cgPath.boundingBox
//            let transform1 = CGAffineTransform(translationX: (actualPathRect.width + 120), y: 120)
            let transform1 = CGAffineTransform.init(translationX: 90, y: -520)
            path?.apply(transform1)
//            let transform = CGAffineTransform(rotationAngle: 3)
            
//            CGAffineTransform.init(rotationAngle: )
//            CGAffineTransform.init(translationX: <#T##CGFloat#>, y: <#T##CGFloat#>)
            let transform =  CGAffineTransform.init(scaleX: 1.0, y: -1.0)
            
            
//            CGMutablePathRef f = CGPathCreateMutable();
//            CGPathAddPath(f, &rotation, aPath.CGPath);
//            
            
            path?.apply(transform)
            layer.path = path?.cgPath
            layer.strokeColor = UIColor.yellow.cgColor
            layer.fillColor = UIColor.brown.cgColor
            self.mainImage.layer.addSublayer(layer)
//            print(path)
//            XCPlaygroundPage.currentPage.captureValue(path, withIdentifier: "glyph \(glyphs[0])")
        }
//        path.
        print("pppp\(path)")

        mouseSwiped = false
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
//        let font = UIFont(name: "HelveticaNeue", size: 12)!
//        
//        var unichars = [UniChar]("J".utf16)
//        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
//        //        var glyphs = [CGGlyph](count: unichars.count, repeatedValue: 0)
//        //        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
//        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
//        if gotGlyphs {
//            let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)!
//            //            cgpath.
//            let path = UIBezierPath.init(cgPath: cgpath)
//            let layer = CAShapeLayer.init()
//            //            let b = getPathForLetter(letter: "K") as UIBezierPath
//            let actualPathRect = path.cgPath.boundingBox
//            //            let transform1 = CGAffineTransform(translationX: (actualPathRect.width + 120), y: 120)
//            let transform1 = CGAffineTransform.init(translationX: 100, y: 100)
//            //            path.apply(transform1)
//            let transform = CGAffineTransform(rotationAngle: CGFloat(slider.value))
//            path.apply(transform)
//            layer.path = path.cgPath
//            self.mainImage.layer.addSublayer(layer)
//            //            print(path)
//            //            XCPlaygroundPage.currentPage.captureValue(path, withIdentifier: "glyph \(glyphs[0])")
//        }
//print("val\(slider.value)")
    }
    func getPathForLetter(letter: Character) -> UIBezierPath {
        var path = UIBezierPath()
        let font = CTFontCreateWithName("HelveticaNeue" as CFString, 64, nil)
        var unichars = [UniChar]("\(letter)".utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        if gotGlyphs {
            let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)
            path = UIBezierPath.init(cgPath: cgpath!)
        }
        print("pppp\(path)")
        return path
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.clear()
        isSucceed = true;
        mouseSwiped = false
        let  touch = touches.first
        lastPoint = touch?.location(in: self.view)
        print("touchesBegan")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        mouseSwiped = true
        let  touch = touches.first
        let currentPoint = touch?.location(in: self.view)
        print("touchesMoved")
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        
        self.tempDrawImage.image?.draw(in: view.bounds)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: lastPoint!)
        context?.addLine(to: currentPoint!)
//        let actualPathRect = path?.cgPath.boundingBox
        if (path?.contains(currentPoint!))! {
            context?.setStrokeColor(UIColor.red.cgColor)

        }
        else
        {
            context?.setStrokeColor(UIColor.green.cgColor)
            isSucceed = false
        }
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(CGFloat(brush))
//        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        lastPoint = currentPoint
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
        let  touch = touches.first
        let currentPoint = touch?.location(in: self.view)

        
        if mouseSwiped == false {
            
//            let  touch = touches.first
//            let currentPoint = touch?.location(in: self.view)
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
            
            self.tempDrawImage.image?.draw(in: view.bounds)
            
            let context = UIGraphicsGetCurrentContext()
            
            context?.move(to: lastPoint!)
            context?.addLine(to: lastPoint!)
            
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(CGFloat(brush))
//            context?.setStrokeColor(UIColor.red.cgColor)
            if (path?.contains(currentPoint!))! {
                context?.setStrokeColor(UIColor.red.cgColor)
                
            }
            else
            {
                context?.setStrokeColor(UIColor.green.cgColor)
                isSucceed = false
            }
            context?.setBlendMode(CGBlendMode.normal)
            context?.strokePath()
            
            self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            
        }
//        UIGraphicsBeginImageContext(self.mainImage.frame.size);
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        self.mainImage.image?.draw(in: view.bounds)

        self.tempDrawImage.image?.draw(in: view.bounds)
        
        
        self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext()
        self.mainImage.image = nil
        UIGraphicsEndImageContext()
        
        DispatchQueue.main.async {
            self.labelResult.isHidden = false
            self.buttonTryAgain.isHidden = false
            if (self.isSucceed == true)
            {
                self.labelResult.text = "Success";
            }
            else
            {
                self.labelResult.text = "Failed";
            }
        }
    }
    
    
//    - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    if(!mouseSwiped) {
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
//    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
//    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
//    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
//    CGContextStrokePath(UIGraphicsGetCurrentContext());
//    CGContextFlush(UIGraphicsGetCurrentContext());
//    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    }
//    
//    UIGraphicsBeginImageContext(self.mainImage.frame.size);
//    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
//    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
//    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
//    self.tempDrawImage.image = nil;
//    UIGraphicsEndImageContext();
//    }

    @IBAction func buttonAction(_ sender: Any) {
        self.clear()
    }
    
    func clear() {
        self.mainImage.image = nil
        self.tempDrawImage.image = nil
        self.buttonTryAgain.isHidden = true
        self.labelResult.isHidden = true
    }
}

