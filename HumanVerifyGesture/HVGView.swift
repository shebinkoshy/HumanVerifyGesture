//
//  HVG.swift
//  HumanVerifyGesture
//
//  Created by Shebin Koshy on 09/07/17.
//  Copyright © 2017 Shebin Koshy. All rights reserved.
//

import UIKit

protocol HVGViewDelegate{
    func HVGResult(view:HVGView, isSuccess: Bool!)
    func HVGCleared(view:HVGView)
//    func HVGTouchesBegan(view:HVGView, point: CGPoint!)
}

class HVGView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    var isMouseSwiped : Bool?
    var lastPoint : CGPoint?
    let brush = 3.0
    var letterBezierPath: UIBezierPath?
    var isSucceed : Bool?
    var drawingPaths : [CGPath]?
    var letterStrokedPoints : [CGPoint]?
    var smallSquaresThatContainLetter: [UIBezierPath]?
    var delegate: HVGViewDelegate?
    var mainImage : UIImageView?
    var tempDrawImage : UIImageView?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        mainImage = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.addSubview(mainImage!)
        
        tempDrawImage = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.addSubview(tempDrawImage!)
        
        
        self.clear()
        
        letterBezierPath = self.getPathForLetter(letter: "a")
        if letterBezierPath != nil {
            let LetterShapelayer = CAShapeLayer.init()
            
            
            let transformTranslation = CGAffineTransform.init(translationX: 50, y: -320)
            letterBezierPath?.apply(transformTranslation)
            let transformScale =  CGAffineTransform.init(scaleX: 1.0, y: -1.0)
            
            
            letterBezierPath?.apply(transformScale)
            LetterShapelayer.path = letterBezierPath?.cgPath
            LetterShapelayer.strokeColor = UIColor.yellow.cgColor
            LetterShapelayer.fillColor = UIColor.brown.cgColor
            self.mainImage!.layer.addSublayer(LetterShapelayer)
            
        }
        let letterStrokedPath =  letterBezierPath?.cgPath.copy(strokingWithWidth: CGFloat(brush), lineCap: CGLineCap.round, lineJoin: CGLineJoin.round, miterLimit: 0)
        
        letterStrokedPoints = letterStrokedPath?.getPathElementsPoints()
        
        let letterStrokedBezierPath =  UIBezierPath(cgPath: letterStrokedPath!)
        let letterStrokedLayer = CAShapeLayer.init()
        letterStrokedLayer.path = letterStrokedBezierPath.cgPath
        letterStrokedLayer.strokeColor = UIColor.yellow.cgColor
        letterStrokedLayer.fillColor = UIColor.brown.cgColor
        self.layer.addSublayer(letterStrokedLayer)
        
        
        let letterEncloseRectPath = letterBezierPath?.cgPath.boundingBox
        let letterEncloseRectBezierPath = UIBezierPath.init(rect: letterEncloseRectPath!)
        let letterEncloseRectLayer = CAShapeLayer()
        letterEncloseRectLayer.path = letterEncloseRectBezierPath.cgPath
        //        self.mainImage.layer.addSublayer(letterEncloseRectLayer)
        
        let smallSlicingSquareWidth = Float((letterEncloseRectPath?.size.width)!/4)
        let smallSlicingSquareHeight = Float((letterEncloseRectPath?.size.height)!/4)
        let initialI = Float((letterEncloseRectPath?.origin.x)!)
        var i = initialI
        
        smallSquaresThatContainLetter = Array()
        repeat
        {
            let initialJ = Float((letterEncloseRectPath?.origin.y)!)
            var j = initialJ
            
            repeat
            {
                
                let bPath = UIBezierPath.init(rect: CGRect(x: CGFloat(i), y: CGFloat(j), width: CGFloat(smallSlicingSquareWidth), height: CGFloat(smallSlicingSquareHeight)))
                if(LineManager.isIntersectedPath(letterBezierPath, path2: bPath) == true)
                {
                    smallSquaresThatContainLetter?.append(bPath)
                    let smallSquareLayer = CAShapeLayer()
                    smallSquareLayer.path = bPath.cgPath
                    smallSquareLayer.strokeColor = UIColor.yellow.cgColor
                }
                
                j = j + smallSlicingSquareHeight
            }
                while ( j < (Float((letterEncloseRectPath?.size.width)!) + initialJ))
            i = i + smallSlicingSquareWidth
            
        } while (i < (Float((letterEncloseRectPath?.size.width)!) + initialI))
        
        
        isMouseSwiped = false
    }
    
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    
    func getPathForLetter(letter: Character) -> UIBezierPath {
        var path = UIBezierPath()
        let font = CTFontCreateWithName("HelveticaNeue" as CFString, 350, nil)
        var unichars = [UniChar]("\(letter)".utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        if gotGlyphs {
            let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)
            path = UIBezierPath.init(cgPath: cgpath!)
        }
        return path
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let  touch = touches.first
        lastPoint = touch?.location(in: self)
//        delegate?.HVGTouchesBegan(view: self, point: lastPoint)
        self.clear()
        drawingPaths = Array.init()
        isSucceed = true;
        isMouseSwiped = false
        
        print("touchesBegan")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.isMouseSwiped = true
            let touch = touches.first
            let currentPoint = touch?.location(in: self)
            print("touchesMoved")
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
            
            self.tempDrawImage!.image?.draw(in: self.bounds)
            
            let context = UIGraphicsGetCurrentContext()
            
            context?.move(to: self.lastPoint!)
            
            
            var inersectPoint : CGPoint?
            
            var copyTempPoint:CGPoint?
            for point in (self.letterStrokedPoints)! {
                
                if copyTempPoint != nil {
                    inersectPoint = LineManager.lineIntersection(self.lastPoint!, p2: currentPoint!, p3: point, p4: copyTempPoint!)
                }
                copyTempPoint = point
            }
            
            if inersectPoint?.equalTo(CGPoint.zero) == false  {
                
                
                let newLocation = touch?.location(in: self)
                let prevLocation = touch?.previousLocation(in: self)
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
                
                
                
                
                if (self.letterBezierPath?.contains(copyIntersectPoint!))! {
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
            }
            else
            {
                context?.addLine(to: currentPoint!)
                if (self.letterBezierPath?.contains(currentPoint!))!
                {
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
            self.tempDrawImage!.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.lastPoint = currentPoint
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
        let  touch = touches.first
        let currentPoint = touch?.location(in: self)
        if isMouseSwiped == false {
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
            
            self.tempDrawImage!.image?.draw(in: self.bounds)
            
            let context = UIGraphicsGetCurrentContext()
            
            context?.move(to: lastPoint!)
            context?.addLine(to: lastPoint!)
            
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(CGFloat(brush))
            if (letterBezierPath?.contains(currentPoint!))! {
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
            
            self.tempDrawImage!.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.mainImage!.image?.draw(in: self.bounds)
        
        self.tempDrawImage!.image?.draw(in: self
            .bounds)
        
        
        self.mainImage!.image = UIGraphicsGetImageFromCurrentImageContext()
        self.mainImage!.image = nil
        UIGraphicsEndImageContext()
        
        DispatchQueue.main.async {
            let smallSquaresThatContainDrawsSet = NSMutableSet()
            for ltrPath in self.smallSquaresThatContainLetter!
            {
                for drwPath in self.drawingPaths!
                {
                    let bezierDrawPath = UIBezierPath.init(cgPath: drwPath)
                    if(LineManager.isIntersectedPath(ltrPath, path2: bezierDrawPath) == true)
                    {
                        smallSquaresThatContainDrawsSet.add(ltrPath)
                    }
                }
            }
            let avg = ((self.smallSquaresThatContainLetter?.count)! * 86) / 100
            if self.smallSquaresThatContainLetter?.count == smallSquaresThatContainDrawsSet.count || smallSquaresThatContainDrawsSet.count >= avg
            {
                
            }
            else
            {
                self.isSucceed = false
            }
            self.delegate?.HVGResult(view: self, isSuccess: self.isSucceed)
        }
    }
    
    
    
    public func clear() {
        self.mainImage!.image = nil
        self.tempDrawImage!.image = nil
        self.delegate?.HVGCleared(view: self)
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
