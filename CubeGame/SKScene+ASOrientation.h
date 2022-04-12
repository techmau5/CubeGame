//
//  SKScene+ASOrientation.h
//  CubeGame
//
//  Created by Adrian Siwy on 11/9/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKScene (ASOrientation)

-(void)orientationChanged:(NSNotification *)note;

@end
