//
//  ASPauseMenu.m
//  CubeGame
//
//  Created by Adrian Siwy on 10/17/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import "ASPauseMenu.h"

@implementation ASPauseMenu

- (id)initWithSize:(CGSize)size {
    
    if (self = [super init]) {
        
        self.zPosition = 99;
        
        self.alpha = 0;
        
        //init BG and buttons to the pauseMenu
        CGRect bgRect = CGRectMake(0, 0, size.width, size.height);
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithRect:bgRect];
        SKShapeNode *background = [SKShapeNode node];
        background.path = bgPath.CGPath;
        background.fillColor = [UIColor whiteColor];
        [self addChild:background];
        
        
        CGRect resumeRect = CGRectMake(-100, -35, 200, 70);
        UIBezierPath *resumePath = [UIBezierPath bezierPathWithRect:resumeRect];
        self.resumeButton = [SKShapeNode node];
        self.resumeButton.path = resumePath.CGPath;
        self.resumeButton.fillColor = [UIColor clearColor];
        self.resumeButton.strokeColor = [UIColor clearColor];
        self.resumeButton.position = CGPointMake(size.width/2, size.height/2 + 90);
        
        self.resumeText = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        self.resumeText.text = @"resume";
        self.resumeText.fontSize = 40;
        self.resumeText.fontColor = [UIColor blackColor];
        self.resumeText.position = CGPointMake(0, -self.resumeText.frame.size.height/2);
        
        [self.resumeButton addChild:self.resumeText];
        [self addChild:self.resumeButton];
        
        
        CGRect restartLevelRect = CGRectMake(-100, -35, 200, 70);
        UIBezierPath *restartLevelPath = [UIBezierPath bezierPathWithRect:restartLevelRect];
        self.restartLevelButton = [SKShapeNode node];
        self.restartLevelButton.path = restartLevelPath.CGPath;
        self.restartLevelButton.fillColor = [UIColor clearColor];
        self.restartLevelButton.strokeColor = [UIColor clearColor];
        self.restartLevelButton.position = CGPointMake(size.width/2, size.height/2);
        
        self.restartLevelText = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        self.restartLevelText.text = @"restart";
        self.restartLevelText.fontSize = 40;
        self.restartLevelText.fontColor = [UIColor blackColor];
        self.restartLevelText.position = CGPointMake(0, -self.resumeText.frame.size.height/2);
        
        [self.restartLevelButton addChild:self.restartLevelText];
        [self addChild:self.restartLevelButton];
        
        
        CGRect mainMenuRect = CGRectMake(-130, -35, 260, 70);
        UIBezierPath *mainMenuPath = [UIBezierPath bezierPathWithRect:mainMenuRect];
        self.mainMenuButton = [SKShapeNode node];
        self.mainMenuButton.path = mainMenuPath.CGPath;
        self.mainMenuButton.fillColor = [UIColor clearColor];
        self.mainMenuButton.strokeColor = [UIColor clearColor];
        self.mainMenuButton.position = CGPointMake(size.width/2, size.height/2 - 90);
        
        self.mainMenuText = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        self.mainMenuText.text = @"main menu";
        self.mainMenuText.fontSize = 40;
        self.mainMenuText.fontColor = [UIColor blackColor];
        self.mainMenuText.position = CGPointMake(0, -self.mainMenuText.frame.size.height/2);
        
        [self.mainMenuButton addChild:self.mainMenuText];
        [self addChild:self.mainMenuButton];
    }
    return self;
}

@end
