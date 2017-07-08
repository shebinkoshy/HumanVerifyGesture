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
    var cgStrokedPath : CGPath?
    var prevIntersect : CGPoint?
    
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
        cgStrokedPath =  path?.cgPath.copy(strokingWithWidth: CGFloat(brush), lineCap: CGLineCap.round, lineJoin: CGLineJoin.round, miterLimit: 0)
//        CGPath.copy(brush,[],CGFloat(brush), CGLineCap.round, CGLineJoin.round, 0)
////        let some = UnsafeMutablePointer($0)
//        let cgStrokedPath = CGPathCreateCopyByStrokingPath(path?.cgPath, [], CGFloat(brush), CGLineCap.round, CGLineJoin.round, 0)
//        let cgStrokedPath = CGPathCreateCopyByStrokingPath(path?.cgPath,CGAffineTransform.init(),brush,CGLineCap.round,CGLineJoin.round,0)
//        CGPathRef cgStrokedPath = CGPathCreateCopyByStrokingPath(path.CGPath, NULL,
//                                                                 lineWidth, kCGLineCapRound, kCGLineJoinRound, 0)
        let strokedPath =  UIBezierPath(cgPath: cgStrokedPath!)
//        path = strokedPath
        let layer = CAShapeLayer.init()
//        let actualPathRect = path?.cgPath.boundingBox
//        let transform1 = CGAffineTransform.init(translationX: 90, y: -520)
//        path?.apply(transform1)
//        let transform =  CGAffineTransform.init(scaleX: 1.0, y: -1.0)
//        
//        
//        path?.apply(transform)
        layer.path = strokedPath.cgPath
        layer.strokeColor = UIColor.yellow.cgColor
        layer.fillColor = UIColor.brown.cgColor
        self.view.layer.addSublayer(layer)
//        print("strokedppp\(strokedPath)")
//        UIBezierPath *strokedPath = [UIBezierPath bezierPathWithCGPath:cgStrokedPath];
//        printg

        mouseSwiped = false
    }
    
    
    func checkLinIntersection(p1: CGPoint, p2:CGPoint, p3:CGPoint, p4:CGPoint) -> Bool
    {
        var denominator = (p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x) * (p2.y - p1.y)
        var ua = (p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x)
        var ub = (p2.x - p1.x) * (p1.y - p3.y) - (p2.y - p1.y) * (p1.x - p3.x)
        if (denominator < 0) {
            ua = -ua
            ub = -ub
            denominator = -denominator
        }
        return (ua > 0.0 && ua <= denominator && ub > 0.0 && ub <= denominator)
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
        
        
        var inersectPoint : CGPoint?
        
        var p234:CGPoint?
        for points123 in (cgStrokedPath?.getPathElementsPoints())! {
            
            if p234 != nil {
                inersectPoint = LineManager.lineIntersection(lastPoint!, p2: currentPoint!, p3: points123, p4: p234!)
            }
            p234 = points123
        }
        
        if inersectPoint?.equalTo(CGPoint.zero) == false  {
            
            
            let newLocation = touch?.location(in: self.view)
            let prevLocation = touch?.previousLocation(in: self.view)
            var copyIntersectPoint :CGPoint?
            var copyIntersectPoint2 :CGPoint?
            let padding = 2 as Float
            if Float((newLocation?.x)!) > Float((prevLocation?.x)!) {
                /**finger touch went right*/
                copyIntersectPoint = CGPoint(x: CGFloat(Float(inersectPoint!.x) + padding), y: inersectPoint!.y)//contains aanenkil left side il ninnum keri, else - left side il ninnum puth poyi
                copyIntersectPoint2 = CGPoint(x: CGFloat(Float(inersectPoint!.x) - padding), y: inersectPoint!.y)
            }else {
                /**finger touch went left*/
                copyIntersectPoint = CGPoint(x: CGFloat(Float(inersectPoint!.x) - padding), y: inersectPoint!.y)//contains aanenkil right side il ninnum keri, else - right side il ninnum purath poyi
                copyIntersectPoint2 = CGPoint(x: CGFloat(Float(inersectPoint!.x) + padding), y: inersectPoint!.y)
            }
            if Float((newLocation?.y)!) > Float((prevLocation?.y)!) {
                /**finger touch went upwards*/
                copyIntersectPoint = CGPoint(x: inersectPoint!.x, y: CGFloat(Float(inersectPoint!.y) - padding))
                copyIntersectPoint2 = CGPoint(x: inersectPoint!.x, y: CGFloat(Float(inersectPoint!.y) + padding))
            } else {
                /**finger touch went downwards*/
                copyIntersectPoint = CGPoint(x: inersectPoint!.x, y: CGFloat(Float(inersectPoint!.y) + padding))
                copyIntersectPoint2 = CGPoint(x: inersectPoint!.x, y: CGFloat(Float(inersectPoint!.y) - padding))
            }
            
            
            
            
            if (path?.contains(copyIntersectPoint!))! {
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
            prevIntersect = inersectPoint
        }
        else
        {
        context?.addLine(to: currentPoint!)
            if (path?.contains(currentPoint!))! {
                            context?.setStrokeColor(UIColor.red.cgColor)
                
                        }
                        else
                        {
                            context?.setStrokeColor(UIColor.green.cgColor)
                            isSucceed = false
                        }
        }
//        context?.addLine(to: currentPoint!)
////        path.
//        if (path?.contains(currentPoint!))! {
//            context?.setStrokeColor(UIColor.red.cgColor)
//
//        }
//        else
//        {
//            context?.setStrokeColor(UIColor.green.cgColor)
//            isSucceed = false
//        }
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
//            print("\(self.drawingPaths)")
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
//        print(MemoryLayout.size(ofValue: body))
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
}//}

