//
//  ASBlockSet.m
//  CubeGame
//
//  Created by Adrian Siwy on 10/9/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import "ASBlockSet.h"
#import "ASBlockNode.h"

@implementation ASBlockSet

{
    SKAction *fadeIn, *fadeOut;
}

-(id)initWithSet1:(NSMutableArray*)set1 WithSet2:(NSMutableArray*)set2 {
    
    if (self = [super init]) {
        
        self.activeSet = 2;
        
        self.set1 = set1;
        self.set2 = set2;
        
        fadeIn = [SKAction fadeInWithDuration:.6];
        fadeOut = [SKAction fadeOutWithDuration:.3];
    }
    
    return self;
}

-(void)initToBoard:(ASBoardNode *)board {
    
    for (ASBlockNode *block in self.set1) {
        
        [board addChild:block];
    }
    
    for (ASBlockNode *block in self.set2) {
        
        [board addChild:block];
    }
}

-(void)switchSetsOnBoard:(ASBoardNode *)board {
    
    if (self.activeSet == 1) {
        
        for (ASBlockNode *block in self.set1) {
            
            [block removeFromParent];
            ASBlockNode *animationBlock = block.copy;
            animationBlock.physicsBody = nil;
            [board addChild:animationBlock];
            [animationBlock runAction:[SKAction sequence:@[fadeOut, [SKAction removeFromParent]]]];
            block.alpha = 0;
        }
        
        for (ASBlockNode *block in self.set2) {
            
            [block removeFromParent];
            [block runAction:fadeIn];
            [board addChild:block];
        }
        
        self.activeSet = 2;
        
    } else if (self.activeSet == 2) {
        
        for (ASBlockNode *block in self.set2) {
            
            [block removeFromParent];
            ASBlockNode *animationBlock = block.copy;
            animationBlock.physicsBody = nil;
            [board addChild:animationBlock];
            [animationBlock runAction:[SKAction sequence:@[fadeOut, [SKAction removeFromParent]]]];
            block.alpha = 0;
        }
        
        for (ASBlockNode *block in self.set1) {
            
            [block removeFromParent];
            [block runAction:fadeIn];
            [board addChild:block];
        }
        
        self.activeSet = 1;
    }
}

@end