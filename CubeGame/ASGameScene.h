//
//  ASGameScene.h
//  CubeGame
//

//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ASMenuScene.h"
#import "ASBoardNode.h"
#import "ASLevelLoader.h"
//#import "ASOrientationChange.h"
#import "ASViewController.h"

typedef enum {gamePlay, paused} gameState;

@interface ASGameScene : SKScene <SKPhysicsContactDelegate, UIGestureRecognizerDelegate>

@property int gridSize, levelID;
@property ASBoardNode *board;
@property gameState gameState;

-(void)changeGameStateTo:(gameState)state;
-(id)initWithSize:(CGSize)size AndLevelID:(int)levelID;
-(void)orientationChanged:(NSNotification *)note;

@end
