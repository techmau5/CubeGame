//
//  ASInfoNode.m
//  CubeGame
//
//  Created by Adrian Siwy on 9/6/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import "ASInfoNode.h"

@implementation ASInfoNode

-(id)init
{
    if (self = [super init]) {
        
        CGRect shadeRect = CGRectMake(0, 0, 300, 300);
        UIBezierPath *shadePath = [UIBezierPath bezierPathWithRect:shadeRect];
        self.shade = [SKShapeNode node];
        self.shade.path = shadePath.CGPath;
        self.shade.fillColor = [UIColor whiteColor];
        self.shade.lineWidth = 0;
        self.shade.zPosition = 2;
        self.shade.position = CGPointMake(-20, -20);
        
        self.tipList = [[NSMutableDictionary alloc]init];
    }
    return self;
}

@end
