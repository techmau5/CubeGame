//
//  ASPauseMenu.h
//  CubeGame
//
//  Created by Adrian Siwy on 10/17/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ASPauseMenu : SKSpriteNode

@property SKShapeNode *resumeButton, *mainMenuButton, *restartLevelButton;
@property SKLabelNode *resumeText, *mainMenuText, *restartLevelText;

-(id)initWithSize:(CGSize)size;

@end
