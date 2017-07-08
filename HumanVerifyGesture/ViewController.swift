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


class ViewController: UIViewController {
    
    var mouseSwiped : Bool?
    var lastPoint : CGPoint?
    let brush = 3.0
    var path: UIBezierPath?
    var isSucceed : Bool?
    var drawingPaths : [CGPoint]?
    
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
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        if gotGlyphs {
            let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)!
            path = UIBezierPath.init(cgPath: cgpath)
            let layer = CAShapeLayer.init()
            let actualPathRect = path?.cgPath.boundingBox
            let transform1 = CGAffineTransform.init(translationX: 90, y: -520)
            path?.apply(transform1)
            let transform =  CGAffineTransform.init(scaleX: 1.0, y: -1.0)
            
            
            path?.apply(transform)
            layer.path = path?.cgPath
            layer.strokeColor = UIColor.yellow.cgColor
            layer.fillColor = UIColor.brown.cgColor
            self.mainImage.layer.addSublayer(layer)

        }
        print("pppp\(path)")
        
//        let path1 = withUnsafeMutablePointer(&transform)
//        {
//            CGPathCreateWithRect(CGRect(...), UnsafeMutablePointer($0))
//        }
       let cgStrokedPath =  path?.cgPath.copy(strokingWithWidth: CGFloat(brush), lineCap: CGLineCap.round, lineJoin: CGLineJoin.round, miterLimit: 0)
//        CGPath.copy(brush,[],CGFloat(brush), CGLineCap.round, CGLineJoin.round, 0)
////        let some = UnsafeMutablePointer($0)
//        let cgStrokedPath = CGPathCreateCopyByStrokingPath(path?.cgPath, [], CGFloat(brush), CGLineCap.round, CGLineJoin.round, 0)
//        let cgStrokedPath = CGPathCreateCopyByStrokingPath(path?.cgPath,CGAffineTransform.init(),brush,CGLineCap.round,CGLineJoin.round,0)
//        CGPathRef cgStrokedPath = CGPathCreateCopyByStrokingPath(path.CGPath, NULL,
//                                                                 lineWidth, kCGLineCapRound, kCGLineJoinRound, 0)
       let strokedPath =  UIBezierPath(cgPath: cgStrokedPath!)
        print("strokedppp\(strokedPath)")
//        UIBezierPath *strokedPath = [UIBezierPath bezierPathWithCGPath:cgStrokedPath];
//        printg

        mouseSwiped = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.clear()
        drawingPaths = Array.init()
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
//        path.
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
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
//        if ((context?.path) != nil) {
            drawingPaths?.append(currentPoint as! CGPoint)

//        }
//        context.cop
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        lastPoint = currentPoint
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
        let  touch = touches.first
        let currentPoint = touch?.location(in: self.view)

        
        if mouseSwiped == false {
            
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
            
            self.tempDrawImage.image?.draw(in: view.bounds)
            
            let context = UIGraphicsGetCurrentContext()
            
            context?.move(to: lastPoint!)
            context?.addLine(to: lastPoint!)
            
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(CGFloat(brush))
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
            if ((context?.path) != nil) {
                drawingPaths?.append(currentPoint!)
                
            }
            self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            
        }
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        self.mainImage.image?.draw(in: view.bounds)

        self.tempDrawImage.image?.draw(in: view.bounds)
        
        
        self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext()
        self.mainImage.image = nil
        UIGraphicsEndImageContext()
        
        DispatchQueue.main.async {
            print("\(self.drawingPaths)")
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

