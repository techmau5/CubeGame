//
//  ASGameScene.m
//  CubeGame
//
//  Created by Adrian Siwy on 7/27/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import "ASGameScene.h"
#import "ASBlockController.h"
#import "ASPauseMenu.h"

//enum for gravity direction
typedef enum {up, left, down, right} gravityDirection;

//define collision masks
static const uint32_t playerCategory = 0x1 << 0;
static const uint32_t blockCategory = 0x1 << 1;
static const uint32_t boardCategory = 0x1 << 2;
static const uint32_t diamondCategory = 0x1 << 3;

@implementation ASGameScene

{
    //init the variables used in GameScene
    int cellSize;
    float playerAcceleration;
    BOOL blockStill;
    CGPoint gravity, playerOrigin;
    gravityDirection direction;
    ASBlockController *blockController;
    UISwipeGestureRecognizer *swipeUp, *swipeDown, *swipeLeft, *swipeRight;
    SKSpriteNode *pauseButton;
    ASPauseMenu *pauseMenu;
}

-(id)initWithSize:(CGSize)size AndLevelID:(int)levelID{
    if (self = [super initWithSize:size]) {
        
        // gameScene init "levels"
        self.physicsWorld.contactDelegate = self;
        CGVector vector;
        vector.dx = 0;
        vector.dy = 0;
        self.physicsWorld.gravity = vector;
        
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        
        self.levelID = levelID;
        
        //create a board with the selected level loaded; level ID is given from level select
        ASLevelLoader *loader = [[ASLevelLoader alloc]init];
        self.board = [loader createLevelWithID:levelID];
        
        //calculate the gridsize and board offset (so its centered)
        cellSize = (float)260/self.board.gridSize;
        float offset = (float)(260 - (self.board.gridSize * cellSize))/2;
        
        //init pauseButton
        pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"PauseButton"];
        pauseButton.position = CGPointMake(self.size.width - 30, self.size.height - 30);
        [self addChild:pauseButton];
        
        //change size for iPad screen
        if (self.size.width > 568) {
            
            [self.board runAction:[SKAction scaleBy:2 duration:0]];
            self.board.position = CGPointMake(self.size.width/2 - 260 + 2 * offset, self.size.height/2 - 260 + 2 * offset);
            
        } else if (self.size.width <= 568) {
            
            [pauseButton runAction:[SKAction scaleBy:2 duration:0]];
            self.board.position = CGPointMake(self.size.width/2 - 130 + offset, self.size.height/2 - 130 + offset);
        }
        
        //add level elements to the board
        [self.board addBlocksToBoard];
        [self.board addGridBlocksToBoard];
        [self.board addDiamondsToBoard];
        
        [self addChild:self.board];
        
        //to combat the strange block relocation bug that may be apples fault (no clue why it happens)
        [self performSelector:@selector(removeSecondSets) withObject:nil afterDelay:1];
        
        blockStill = YES;
        blockController = [[ASBlockController alloc]initWithGridSize:self.board.gridSize];
        blockController.board = self.board;
        
        //start the game and load the board
        [self changeGameStateTo:gamePlay];
    }
    
    return self;
}

//change the state of the game
-(void)changeGameStateTo:(gameState)state {
    
    switch (state) {
            
        case gamePlay: {
            
            self.gameState = gamePlay;
            
        }
            break;
            
        case paused: {
            
            self.gameState = paused;
            
            pauseMenu = [[ASPauseMenu alloc]initWithSize:self.size];
            [pauseMenu runAction:[SKAction fadeInWithDuration:.5]];
            [self addChild:pauseMenu];
            
        }
            break;
    }
}

//determine the collision situation and run code that is appropriate
-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    //check if the player collided without moving
    if (self.board.player.position.x == playerOrigin.x && self.board.player.position.y == playerOrigin.y) return;
    
    //check if a diamond is involved, otherwise stop the block and approximate its position
    if (contact.bodyA.categoryBitMask != diamondCategory && contact.bodyB.categoryBitMask != diamondCategory) {
        
        blockStill = YES;
        self.board.player.physicsBody = nil;
        [self approximatePlayerLocation];
        
    }
    
    //check if the side of the board is involved
    if (contact.bodyA.categoryBitMask == boardCategory || contact.bodyB.categoryBitMask == boardCategory) return;
    
    //determine which body belongs to the player and run code for the other block
    if (contact.bodyA.categoryBitMask == playerCategory) {
        
        [blockController handleBlock:(ASBlockNode*)contact.bodyB.node];
        
    } else {
        
        [blockController handleBlock:(ASBlockNode*)contact.bodyA.node];
        
    }
}

//pause game when pause button is pressed
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ([(SKSpriteNode*)[self nodeAtPoint:location] isEqual:pauseButton]) {
            [self changeGameStateTo:paused];
            break;
        }
    }
}

//to be removed if unused
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
    }
}

//pause button and pause menu buttons
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //for pauseMenu and pauseButton touch detection
    switch (self.gameState) {
        case gamePlay:
        {
            for (UITouch *touch in touches) {
                CGPoint location = [touch locationInNode:self];
                
                if ([(SKSpriteNode*)[self nodeAtPoint:location] isEqual:pauseButton]) {
                    
                    [self changeGameStateTo:paused];
                    
                }
            }
        }
            break;
            
        case paused:
        {
            for (UITouch *touch in touches) {
                CGPoint location = [touch locationInNode:self];
                
                //check if resume button of main menu button was pressed
                if ([(SKSpriteNode*)[self nodeAtPoint:location] isEqual:pauseMenu.resumeButton] || [(SKSpriteNode*)[self nodeAtPoint:location] isEqual:pauseMenu.resumeText]) {
                    
                    [pauseMenu runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:.5],[SKAction removeFromParent]]]];
                    [self changeGameStateTo:gamePlay];
                    
                } else if ([(SKSpriteNode*)[self nodeAtPoint:location] isEqual:pauseMenu.mainMenuButton] || [(SKSpriteNode*)[self nodeAtPoint:location] isEqual:pauseMenu.mainMenuText]) {
                    
                    [self switchToMainMenuScene];
                    
                } else if ([(SKSpriteNode*)[self nodeAtPoint:location] isEqual:pauseMenu.restartLevelButton] || [(SKSpriteNode*)[self nodeAtPoint:location] isEqual:pauseMenu.restartLevelText]) {
                    
                    [self reloadBoard];
                }
            }
        }
            break;
    }
}

//if mainMenuButton is pressed then return to the main menu
-(void)switchToMainMenuScene {
    
    SKView *skView = (SKView *) self.view;
    ASMenuScene *newScene = [ASMenuScene sceneWithSize:self.size];
    newScene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *fade = [SKTransition crossFadeWithDuration:.5];
    
    [skView presentScene:newScene transition:fade];
}

-(void)reloadBoard {
    
    SKView *skView = (SKView *) self.view;
    ASGameScene *newScene = [[ASGameScene alloc] initWithSize:self.size AndLevelID:self.levelID];
    newScene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *fade = [SKTransition crossFadeWithDuration:.5];
    
    [skView presentScene:newScene transition:fade];
}

//gravity controlling methods
-(void)up {
    
    if (blockStill == NO) return;
    blockStill = NO;
    direction = up;
    playerAcceleration = 3;
    [blockController setBodyOrientation:vertical OfPlayer:self.board.player];
    gravity = CGPointMake(0, 1);
    playerOrigin = self.board.player.position;
}

-(void)down {
    
    if (blockStill == NO) return;
    blockStill = NO;
    direction = down;
    playerAcceleration = 3;
    [blockController setBodyOrientation:vertical OfPlayer:self.board.player];
    gravity = CGPointMake(0, -1);
    playerOrigin = self.board.player.position;
}

-(void)left {
    
    if (blockStill == NO) return;
    blockStill = NO;
    direction = left;
    playerAcceleration = 3;
    [blockController setBodyOrientation:horizontal OfPlayer:self.board.player];
    gravity = CGPointMake(-1, 0);
    playerOrigin = self.board.player.position;
}

-(void)right {
    
    if (blockStill == NO) return;
    blockStill = NO;
    direction = right;
    playerAcceleration = 3;
    [blockController setBodyOrientation:horizontal OfPlayer:self.board.player];
    gravity = CGPointMake(1, 0);
    playerOrigin = self.board.player.position;
}

//switching scenes without removing these would crash the game
- (void) willMoveFromView: (SKView *) view {
    
    [view removeGestureRecognizer: swipeUp];
    [view removeGestureRecognizer: swipeDown ];
    [view removeGestureRecognizer: swipeLeft];
    [view removeGestureRecognizer: swipeRight];
}

//create gesture recognizers when the scene didMoveToView is called
-(void)didMoveToView:(SKView *)view {
    
    swipeUp  = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(up)];
    swipeUp.numberOfTouchesRequired = 1;
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [view addGestureRecognizer:swipeUp];
    
    swipeDown  = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(down)];
    swipeDown.numberOfTouchesRequired = 1;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [view addGestureRecognizer:swipeDown];
    
    swipeLeft  = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(left)];
    swipeLeft.numberOfTouchesRequired = 1;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [view addGestureRecognizer:swipeLeft];
    
    swipeRight  = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(right)];
    swipeRight.numberOfTouchesRequired = 1;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [view addGestureRecognizer:swipeRight];
}

//set the players location in the grid location it is residing in
-(void)approximatePlayerLocation {
    
    CGPoint location = self.board.player.position;
    
    long int newX;
    long int newY;
    
    newX = lroundf(location.x/cellSize) * cellSize;
    newY = lroundf(location.y/cellSize) * cellSize;
    
    self.board.player.position = CGPointMake(newX, newY);
}

//necessary to combat the strange bug discussed in the init method
-(void)removeSecondSets {
    
    for (ASBlockSet *blockset in self.board.blockSets) {
        
        [blockset switchSetsOnBoard:self.board];
    }
}

//for detecting orientation changes
- (void) orientationChanged:(NSNotification *)note {
    NSLog(@"game");
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

//update method
-(void)update:(CFTimeInterval)currentTime {
    
    switch (self.gameState) {
            
        case gamePlay:
            
            //move player when block is active
            if (blockStill != YES) {
                
                if (playerAcceleration < 7) {
                    
                    playerAcceleration += .2 * 5/self.board.gridSize;
                }
                
                self.board.player.position = CGPointMake(self.board.player.position.x + (playerAcceleration * gravity.x), self.board.player.position.y + (playerAcceleration * gravity.y));
            }
            
            break;
            
        case paused:
            
            break;
    }
}

@end
