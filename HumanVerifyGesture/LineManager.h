//
//  LineManager.h
//  HumanVerifyGesture
//
//  Created by Shebin Koshy on 08/07/17.
//  Copyright © 2017 Shebin Koshy. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface LineManager : NSObject

+(CGPoint)LineIntersection:(CGPoint)p1 p2:(CGPoint)p2 p3:(CGPoint)pa p4:(CGPoint)pb;
+(BOOL)isIntersectedPath:(UIBezierPath*)path1 path2:(UIBezierPath*)path2;
@end 
