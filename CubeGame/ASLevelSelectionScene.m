//
//  ASLevelSelectionScene.m
//  CubeGame
//
//  Created by Adrian Siwy on 10/27/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import "ASLevelSelectionScene.h"
#import "ASGameScene.h"
#import "ASMenuScene.h"

@implementation ASLevelSelectionScene

{
    
}

-(void)didMoveToView:(SKView *)view {
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        
        CGRect levelOneRect = CGRectMake(0, 0, 200, 200);
        UIBezierPath *levelOnePath = [UIBezierPath bezierPathWithRect:levelOneRect];
        self.levelOneShape = [SKShapeNode node];
        self.levelOneShape.path = levelOnePath.CGPath;
        self.levelOneShape.fillColor = [UIColor colorWithRed:.9 green:.5 blue:.5 alpha:1];
        self.levelOneShape.strokeColor = [UIColor clearColor];
        self.levelOneShape.position = CGPointMake(size.width/4 - 100, size.height/2 - 100);
        [self addChild:self.levelOneShape];
        
        SKLabelNode *one = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        one.text = @"one";
        one.fontSize = 40;
        one.fontColor = [UIColor blackColor];
        one.alpha = 1.0;
        one.position = CGPointMake(size.width/4, self.levelOneShape.position.y - 50);
        [self addChild:one];
        
        CGRect levelTwoRect = CGRectMake(0, 0, 200, 200);
        UIBezierPath *levelTwoPath = [UIBezierPath bezierPathWithRect:levelTwoRect];
        self.levelTwoShape = [SKShapeNode node];
        self.levelTwoShape.path = levelTwoPath.CGPath;
        self.levelTwoShape.fillColor = [UIColor colorWithRed:.5 green:.9 blue:.5 alpha:1];
        self.levelTwoShape.strokeColor = [UIColor clearColor];
        self.levelTwoShape.position = CGPointMake(size.width/2 - 100, size.height/2 - 100);
        [self addChild:self.levelTwoShape];
        
        SKLabelNode *two = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        two.text = @"two";
        two.fontSize = 40;
        two.fontColor = [UIColor blackColor];
        two.alpha = 1.0;
        two.position = CGPointMake(size.width/2, self.levelOneShape.position.y - 50);
        [self addChild:two];
        
        CGRect levelThreeRect = CGRectMake(0, 0, 200, 200);
        UIBezierPath *levelThreePath = [UIBezierPath bezierPathWithRect:levelThreeRect];
        self.levelThreeShape = [SKShapeNode node];
        self.levelThreeShape.path = levelThreePath.CGPath;
        self.levelThreeShape.fillColor = [UIColor colorWithRed:.5 green:.5 blue:.9 alpha:1];
        self.levelThreeShape.strokeColor = [UIColor clearColor];
        self.levelThreeShape.position = CGPointMake(size.width * .75 - 100, size.height/2 - 100);
        [self addChild:self.levelThreeShape];
        
        SKLabelNode *three = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        three.text = @"three";
        three.fontSize = 40;
        three.fontColor = [UIColor blackColor];
        three.alpha = 1.0;
        three.position = CGPointMake(size.width * .75, self.levelOneShape.position.y - 50);
        [self addChild:three];
        
        self.backButton = [SKSpriteNode spriteNodeWithImageNamed:@"BackButton"];
        self.backButton.position = CGPointMake(self.size.width - 30, self.size.height - 30);
        [self.backButton runAction:[SKAction scaleTo:.4 duration:0]];
        [self addChild:self.backButton];
    }
    return self;
}

-(void)switchToMainMenuScene {
    
    SKView *skView = (SKView *) self.view;
    ASMenuScene *newScene = [ASMenuScene sceneWithSize:self.size];
    newScene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *fade = [SKTransition crossFadeWithDuration:.5];
    
    [skView presentScene:newScene transition:fade];
}

-(void)switchToGameSceneWithLevelID:(int)levelID {
    
    SKView *skView = (SKView *) self.view;
    ASGameScene *newScene = [[ASGameScene alloc]initWithSize:self.size AndLevelID:levelID];
    newScene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *fade = [SKTransition crossFadeWithDuration:.5];
    
    [skView presentScene:newScene transition:fade];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        
        
        if ([(SKSpriteNode*)[self nodeAtPoint:location] isEqual:self.backButton]) {
            
            [self switchToMainMenuScene];
        } else if ([(SKShapeNode*)[self nodeAtPoint:location] isEqual:self.levelOneShape]) { // <<<<< to be removed TO DELETE
            
            [self switchToGameSceneWithLevelID:300];
        } else if ([(SKShapeNode*)[self nodeAtPoint:location] isEqual:self.levelTwoShape]) { // <<<<< to be removed TO DELETE
            
            [self switchToGameSceneWithLevelID:201];
        } else if ([(SKShapeNode*)[self nodeAtPoint:location] isEqual:self.levelThreeShape]) { // <<<<< to be removed TO DELETE
            
            [self switchToGameSceneWithLevelID:202];
        }
    }
}

//for detecting orientation changes
- (void) orientationChanged:(NSNotification *)note {
    NSLog(@"level");
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            NSLog(@"portrait");
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"left");
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"right");
            break;
        default:
            
            break;
    };
}

@end
