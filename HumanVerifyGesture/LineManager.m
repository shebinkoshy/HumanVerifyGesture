//
//  LineManager.m
//  HumanVerifyGesture
//
//  Created by Shebin Koshy on 08/07/17.
//  Copyright © 2017 Shebin Koshy. All rights reserved.
//

#import "LineManager.h"

#import "AGKLine.h"

#import "ClippingBezier.h"

@implementation LineManager

+(CGPoint)LineIntersection:(CGPoint)p1 p2:(CGPoint)p2 p3:(CGPoint)pa p4:(CGPoint)pb
{
    AGKLine l1 = AGKLineMake(p1, p2);
    AGKLine l2 = AGKLineMake(pa, pb);
    CGPoint p;
    if(AGKLineIntersection(l1, l2, &p))
    {
        
        NSLog(@"point inter %@",NSStringFromCGPoint(p));
    }
    
    
    return p;
}


+(BOOL)isIntersectedPath:(UIBezierPath*)path1 path2:(UIBezierPath*)path2
{
    NSArray *array = [path1 findIntersectionsWithClosedPath:path2 andBeginsInside:nil];
    if (array && array.count > 0)
    {
        return YES;
    }
    return NO;
}

@end
