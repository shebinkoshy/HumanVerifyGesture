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
    var drawingPaths : [CGPath]?
    var cgStrokedPath : CGPath?
    var prevIntersect : CGPoint?
    var smallSquaresThatContainLetter: [UIBezierPath]?
    
    @IBOutlet weak var labelResult: UILabel!
   
    @IBOutlet weak var buttonTryAgain: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var tempDrawImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        labelResult.textColor = UIColor.white
        self.buttonTryAgain.isExclusiveTouch = true
        self.clear()
        let font = UIFont(name: "HelveticaNeue", size: 350)!
        
        var unichars = [UniChar]("D".utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        if gotGlyphs {
            let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)!
            path = UIBezierPath.init(cgPath: cgpath)
            let layer = CAShapeLayer.init()
            
            
            let transform1 = CGAffineTransform.init(translationX: 50, y: -520)
            path?.apply(transform1)
            let transform =  CGAffineTransform.init(scaleX: 1.0, y: -1.0)
            
            
            path?.apply(transform)
            layer.path = path?.cgPath
            layer.strokeColor = UIColor.yellow.cgColor
            layer.fillColor = UIColor.brown.cgColor
            self.mainImage.layer.addSublayer(layer)
            
        }
        cgStrokedPath =  path?.cgPath.copy(strokingWithWidth: CGFloat(brush), lineCap: CGLineCap.round, lineJoin: CGLineJoin.round, miterLimit: 0)
       
        let strokedPath =  UIBezierPath(cgPath: cgStrokedPath!)
        let layer = CAShapeLayer.init()
        layer.path = strokedPath.cgPath
        layer.strokeColor = UIColor.yellow.cgColor
        layer.fillColor = UIColor.brown.cgColor
        self.view.layer.addSublayer(layer)
        
        
        let actualPathRect = path?.cgPath.boundingBox
        let some = UIBezierPath.init(rect: actualPathRect!)
        let layerbox = CAShapeLayer()
        layerbox.path = some.cgPath
        self.mainImage.layer.addSublayer(layerbox)
        
        let smallSquareWidth = Float((actualPathRect?.size.width)!/4)
        let smallSquareHeight = Float((actualPathRect?.size.height)!/4)
        let initialI = Float((actualPathRect?.origin.x)!)
        var i = initialI// as Float
        let layerBox222 = CALayer()
        layerBox222.frame = actualPathRect!
        self.view.layer.addSublayer(layerBox222)
        smallSquaresThatContainLetter = Array()
        repeat
        {
            let initialJ = Float((actualPathRect?.origin.y)!)
            var j = initialJ//0 as Float
            
            repeat
            {
                
                let bPath = UIBezierPath.init(rect: CGRect(x: CGFloat(i), y: CGFloat(j), width: CGFloat(smallSquareWidth), height: CGFloat(smallSquareHeight)))
                if(LineManager.isIntersectedPath(path, path2: bPath) == true)
                {
                    smallSquaresThatContainLetter?.append(bPath)
                    let smallSquareLayer = CAShapeLayer()
                    smallSquareLayer.path = bPath.cgPath
                    smallSquareLayer.strokeColor = UIColor.yellow.cgColor
                }
                
                j = j + smallSquareHeight
            }
            while ( j < (Float((actualPathRect?.size.width)!) + initialJ))
            i = i + smallSquareWidth

        } while (i < (Float((actualPathRect?.size.width)!) + initialI))


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
        DispatchQueue.main.async {
        self.mouseSwiped = true
        let  touch = touches.first
        let currentPoint = touch?.location(in: self.view)
        print("touchesMoved")
        
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0)
        
        self.tempDrawImage.image?.draw(in: self.view.bounds)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: self.lastPoint!)
        
        
        var inersectPoint : CGPoint?
        
        var p234:CGPoint?
        for points123 in (self.cgStrokedPath?.getPathElementsPoints())! {
            
            if p234 != nil {
                inersectPoint = LineManager.lineIntersection(self.lastPoint!, p2: currentPoint!, p3: points123, p4: p234!)
            }
            p234 = points123
        }
        
        if inersectPoint?.equalTo(CGPoint.zero) == false  {
            
            
            let newLocation = touch?.location(in: self.view)
            let prevLocation = touch?.previousLocation(in: self.view)
            var copyIntersectPoint :CGPoint?
//            var copyIntersectPoint2 :CGPoint?
            let padding = 2 as Float
            if Float((newLocation?.x)!) > Float((prevLocation?.x)!) {
                /**finger touch went right*/
                copyIntersectPoint = CGPoint(x: CGFloat(Float(inersectPoint!.x) + padding), y: inersectPoint!.y)//contains aanenkil left side il ninnum keri, else - left side il ninnum puth poyi
//                copyIntersectPoint2 = CGPoint(x: CGFloat(Float(inersectPoint!.x) - padding), y: inersectPoint!.y)
            }else {
                /**finger touch went left*/
                copyIntersectPoint = CGPoint(x: CGFloat(Float(inersectPoint!.x) - padding), y: inersectPoint!.y)//contains aanenkil right side il ninnum keri, else - right side il ninnum purath poyi
//                copyIntersectPoint2 = CGPoint(x: CGFloat(Float(inersectPoint!.x) + padding), y: inersectPoint!.y)
            }
            if Float((newLocation?.y)!) > Float((prevLocation?.y)!) {
                /**finger touch went upwards*/
                copyIntersectPoint = CGPoint(x: inersectPoint!.x, y: CGFloat(Float(inersectPoint!.y) - padding))
//                copyIntersectPoint2 = CGPoint(x: inersectPoint!.x, y: CGFloat(Float(inersectPoint!.y) + padding))
            } else {
                /**finger touch went downwards*/
                copyIntersectPoint = CGPoint(x: inersectPoint!.x, y: CGFloat(Float(inersectPoint!.y) + padding))
//                copyIntersectPoint2 = CGPoint(x: inersectPoint!.x, y: CGFloat(Float(inersectPoint!.y) - padding))
            }
            
            
            
            
            if (self.path?.contains(copyIntersectPoint!))! {
                //akath keri
                context?.addLine(to: inersectPoint!)
                context?.setStrokeColor(UIColor.green.cgColor)
                context?.addLine(to: currentPoint!)
                context?.setStrokeColor(UIColor.red.cgColor)
            }
            else
            {
                context?.addLine(to: inersectPoint!)
                context?.setStrokeColor(UIColor.red.cgColor)
                context?.addLine(to: currentPoint!)
                context?.setStrokeColor(UIColor.green.cgColor)
            }
            self.prevIntersect = inersectPoint
        }
        else
        {
        context?.addLine(to: currentPoint!)
            if (self.path?.contains(currentPoint!))! {
                            context?.setStrokeColor(UIColor.red.cgColor)
                
                        }
                        else
                        {
                            context?.setStrokeColor(UIColor.green.cgColor)
                            self.isSucceed = false
                        }
        }
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(CGFloat(self.brush))
        context?.setBlendMode(CGBlendMode.normal)
        self.drawingPaths?.append((context?.path)!)
        context?.strokePath()
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.lastPoint = currentPoint
        }
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
            if ((context?.path) != nil) {
                drawingPaths?.append((context?.path)!)
                
            }
            context?.strokePath()
            
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
            let smallSquaresThatContainDrawsSet = NSMutableSet()
            for bPath in self.smallSquaresThatContainLetter!
            {
                for dPath in self.drawingPaths!
                {
                    let bezierDrawPath = UIBezierPath.init(cgPath: dPath)
                    if(LineManager.isIntersectedPath(bPath, path2: bezierDrawPath) == true)
                    {
                        smallSquaresThatContainDrawsSet.add(bPath)
                    }
                }
            }
            let avg = ((self.smallSquaresThatContainLetter?.count)! * 93) / 100
            if self.smallSquaresThatContainLetter?.count == smallSquaresThatContainDrawsSet.count || smallSquaresThatContainDrawsSet.count >= avg
            {
                
            }
            else
            {
                self.isSucceed = false
            }
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
extension CGPath {
    
    func forEach( body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }
    
    
    func getPathElementsPoints() -> [CGPoint] {
        var arrayPoints : [CGPoint]! = [CGPoint]()
        self.forEach { element in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
            case .addQuadCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
            case .addCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayPoints.append(element.points[2])
            default: break
            }
        }
        return arrayPoints
    }
    
    func getPathElementsPointsAndTypes() -> ([CGPoint],[CGPathElementType]) {
        var arrayPoints : [CGPoint]! = [CGPoint]()
        var arrayTypes : [CGPathElementType]! = [CGPathElementType]()
        self.forEach { element in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
                arrayTypes.append(element.type)
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
                arrayTypes.append(element.type)
            case .addQuadCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayTypes.append(element.type)
                arrayTypes.append(element.type)
            case .addCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayPoints.append(element.points[2])
                arrayTypes.append(element.type)
                arrayTypes.append(element.type)
                arrayTypes.append(element.type)
            default: break
            }
        }
        return (arrayPoints,arrayTypes)
    }
}

