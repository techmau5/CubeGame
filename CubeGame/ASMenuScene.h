//
//  ASMenuScene.h
//  CubeGame
//
//  Created by Adrian Siwy on 8/1/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ASGameScene.h"
//#import "ASOrientationChange.h"
#import "ASViewController.h"

typedef enum {mainMenu, aboutPage} menuState;

@interface ASMenuScene : SKScene

@property menuState menuState;

-(void)orientationChanged:(NSNotification *)note;

@end
