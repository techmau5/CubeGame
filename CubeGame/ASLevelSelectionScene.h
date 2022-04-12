//
//  ASLevelSelectionScene.h
//  CubeGame
//
//  Created by Adrian Siwy on 10/27/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
//#import "ASOrientationChange.h"
#import "ASViewController.h"

@interface ASLevelSelectionScene : SKScene <UITextFieldDelegate>

@property SKSpriteNode *backButton;
@property SKShapeNode *levelOneShape, *levelTwoShape, *levelThreeShape;

-(void)orientationChanged:(NSNotification *)note;

@end
