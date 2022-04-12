//
//  ASViewController.m
//  CubeGame
//
//  Created by Adrian Siwy on 7/27/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import "ASViewController.h"
#import "ASGameScene.h"
#import "ASMenuScene.h"
#import "SKScene+ASOrientation.h"

@implementation ASViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    //skView.showsPhysics = YES;
    
    // Create and configure the scene.
    SKScene *scene = [ASMenuScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
//    //for detecting orientation changes
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self.scene selector:@selector(orientationChanged:)
//     name:UIDeviceOrientationDidChangeNotification
//     object:[UIDevice currentDevice]];
    
    // Present the scene.
    [skView presentScene:scene];
}

//-(void)setCurrentScene:(SKScene *)scene {
//    
//    self.scene = scene;
//}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
