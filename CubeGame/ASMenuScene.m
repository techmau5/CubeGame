//
//  ASMenuScene.m
//  CubeGame
//
//  Created by Adrian Siwy on 8/1/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import "ASMenuScene.h"
#import "ASLevelSelectionScene.h"
#import "ASViewController.h"

@implementation ASMenuScene

{
    SKShapeNode *playButton, *aboutButton;
    SKLabelNode *playText, *aboutText, *titleText;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        
        titleText = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        titleText.text = @"CubeGame Demo";
        titleText.fontSize = 70;
        titleText.fontColor = [UIColor blackColor];
        titleText.position = CGPointMake(size.width/2, size.height * .75);
        [self addChild:titleText];
        
        CGRect playRect = CGRectMake(-80, -35, 160, 70);
        UIBezierPath *playPath = [UIBezierPath bezierPathWithRect:playRect];
        playButton = [SKShapeNode node];
        playButton.path = playPath.CGPath;
        playButton.fillColor = [UIColor clearColor];
        playButton.strokeColor = [UIColor clearColor];
        playButton.position = CGPointMake(size.width/2, size.height/2);
        
        playText = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        playText.text = @"play";
        playText.fontSize = 40;
        playText.fontColor = [UIColor blackColor];
        playText.alpha = 0;
        playText.position = CGPointMake(0, -playText.frame.size.height/3);
        
        SKAction *fadeIn = [SKAction fadeInWithDuration:1];
        [playText runAction:fadeIn];
        
        [playButton addChild:playText];
        [self addChild:playButton];
        
        CGRect aboutRect = CGRectMake(-110, -35, 220, 70);
        UIBezierPath *aboutPath = [UIBezierPath bezierPathWithRect:aboutRect];
        aboutButton = [SKShapeNode node];
        aboutButton.path = aboutPath.CGPath;
        aboutButton.fillColor = [UIColor clearColor];
        aboutButton.strokeColor = [UIColor clearColor];
        aboutButton.position = CGPointMake(size.width/2, size.height/2 - 75);
        
        aboutText = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        aboutText.text = @"about";
        aboutText.fontSize = 40;
        aboutText.fontColor = [UIColor blackColor];
        aboutText.alpha = 0;
        aboutText.position = CGPointMake(0, -aboutText.frame.size.height/3);
        
        [aboutText runAction:fadeIn];
        
        [aboutButton addChild:aboutText];
        [self addChild:aboutButton];
    }
    return self;
}

-(void)switchToLevelSelectionScene {
    
    SKView *skView = (SKView *) self.view;
    ASLevelSelectionScene *newScene = [[ASLevelSelectionScene alloc]initWithSize:self.size];
    newScene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *fade = [SKTransition crossFadeWithDuration:.5];
    
    [skView presentScene:newScene transition:fade];
}

-(void)changeMenuStateTo:(menuState)state {
    
    switch (state) {
        case mainMenu:
        {
            self.menuState = mainMenu;
        }
            break;
            
        case aboutPage:
        {
            self.menuState = aboutPage;
            
        }
            break;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    switch (self.menuState) {
        case mainMenu:
        {
            for (UITouch *touch in touches) {
                CGPoint location = [touch locationInNode:self];
                
                if ([(SKSpriteNode*)[self nodeAtPoint:location] isEqual:playButton] || [(SKSpriteNode*)[self nodeAtPoint:location] isEqual:playText]) {
                    
                    [self switchToLevelSelectionScene];
                    
                } else if ([(SKSpriteNode*)[self nodeAtPoint:location] isEqual:aboutButton] || [(SKSpriteNode*)[self nodeAtPoint:location] isEqual:aboutText]) {
                    
                    [self changeMenuStateTo:aboutPage];
                }
            }
        }
            break;
            
        case aboutPage:
//        {
//            for (UITouch *touch in touches) {
//                CGPoint location = [touch locationInNode:self];
//                
//                if ([(SKSpriteNode*)[self nodeAtPoint:location] isEqual:pauseMenu.resumeButton] || [(SKSpriteNode*)[self nodeAtPoint:location] isEqual:pauseMenu.resumeText]) {
//                    
//                    [pauseMenu runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:.5],[SKAction removeFromParent]]]];
//                    [self changeGameStateTo:gamePlay];
//                    
//                } else if ([(SKSpriteNode*)[self nodeAtPoint:location] isEqual:pauseMenu.mainMenuButton] || [(SKSpriteNode*)[self nodeAtPoint:location] isEqual:pauseMenu.mainMenuText]) {
//                    
//                    //temp for testing
//                    SKScene * scene = [ASGameScene sceneWithSize:self.view.bounds.size];
//                    scene.scaleMode = SKSceneScaleModeAspectFill;
//                    
//                    [self.view presentScene:scene];
//                }
//            }
//        }
            break;
    }
}

//for detecting orientation changes
- (void) orientationChanged:(NSNotification *)note {
    NSLog(@"main");
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
