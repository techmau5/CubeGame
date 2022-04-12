//
//  ASBlockController.m
//  CubeGame
//
//  Created by Adrian Siwy on 8/2/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import "ASBlockController.h"
#import "ASBlockSet.h"

@implementation ASBlockController

//define collision masks
static const uint32_t playerCategory = 0x1 << 0;
static const uint32_t blockCategory = 0x1 << 1;
static const uint32_t boardCategory = 0x1 << 2;
static const uint32_t diamondCategory = 0x1 << 3;

//init and find the gridsize and cellsize for determining sizes
-(id)initWithGridSize:(int)gridSize {
    
    if (self = [super init]) {
        
        self.gridSize = gridSize;
        self.cellSize = (float)260/gridSize;
    }
    
    return self;
}

//create the block path (universal for all blocks)
-(UIBezierPath *)blockPath {
    
    //pre-calculations
    float gap = 0.2f * self.cellSize;
    float gap2 = 0.8f * self.cellSize;
    float size = self.cellSize;
    
    //make the block shape
    UIBezierPath *blockPath = [UIBezierPath bezierPath];
    [blockPath moveToPoint:CGPointMake(gap,0)];
    [blockPath addLineToPoint:CGPointMake(0, gap)];
    [blockPath addLineToPoint:CGPointMake(0, gap2)];
    [blockPath addLineToPoint:CGPointMake(gap, size)];
    [blockPath addLineToPoint:CGPointMake(gap2, size)];
    [blockPath addLineToPoint:CGPointMake(size, gap2)];
    [blockPath addLineToPoint:CGPointMake(size, gap)];
    [blockPath addLineToPoint:CGPointMake(gap2, 0)];
    [blockPath closePath];
    
    return blockPath;
    
}

//create a block physics body (universal for all blocks)
-(SKPhysicsBody*)blockBody {
    
    //create block physics body
    CGRect blockRect = CGRectMake(0, 0, self.cellSize, self.cellSize);
    CGPoint center = CGPointMake(CGRectGetMidX(blockRect), CGRectGetMidY(blockRect));
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:blockRect.size center:center];
    body.categoryBitMask = blockCategory;
    body.allowsRotation = NO;
    body.dynamic = NO;
    
    return body;
}

//creates a player block that is movable by the player
-(ASBlockNode *)player {
    
    UIBezierPath *blockPath = [self blockPath];
    ASBlockNode *blockNode = [[ASBlockNode alloc]init];
    blockNode.path = blockPath.CGPath;
    blockNode.fillColor =[UIColor colorWithRed:.6 green:.6 blue:1 alpha:1];
    blockNode.lineWidth = 0;
    blockNode.type = 'p';
    
    return blockNode;
}

//changes the orientation of the player block's collision box
-(ASBlockNode *)setBodyOrientation:(bodyOrientation)orientation OfPlayer:(ASBlockNode *)player{
    
    CGRect blockRect;
    CGPoint center;
    
    if (orientation == vertical) {
        blockRect = CGRectMake(0, 0, 1, self.cellSize);
        center = CGPointMake(CGRectGetMidX(blockRect) + self.cellSize/2, CGRectGetMidY(blockRect));
    } else if (orientation == horizontal) {
        blockRect = CGRectMake(0, 0, self.cellSize, 1);
        center = CGPointMake(CGRectGetMidX(blockRect), CGRectGetMidY(blockRect) + self.cellSize/2);
    }
    
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:blockRect.size center:center];
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.contactTestBitMask = blockCategory | boardCategory | diamondCategory;
    player.physicsBody.collisionBitMask = blockCategory | boardCategory;
    player.physicsBody.allowsRotation = NO;
    
    return player;
}

//creates a basic block that acts as a barrier (no special functionality)
-(ASBlockNode *)basic {
    
    //create block
    UIBezierPath *blockPath = [self blockPath];
    ASBlockNode *blockNode = [ASBlockNode node];
    blockNode.path = blockPath.CGPath;
    blockNode.fillColor =[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1];
    blockNode.lineWidth = 0;
    blockNode.type = 'b';
    
    //create block physics body
    blockNode.physicsBody = [self blockBody];
    
    return blockNode;
}

//  \/  Custom   Blocks   Start   Here  \/  //

//creates a toggle block that alternates between two sets of blocks when hit
-(ASBlockNode *)toggle {
    
    UIBezierPath *blockPath = [self blockPath];
    ASBlockNode *blockNode = [[ASBlockNode alloc]init];
    blockNode.path = blockPath.CGPath;
    blockNode.fillColor =[UIColor greenColor];
    blockNode.lineWidth = 0;
    blockNode.type = 't';
    
    blockNode.physicsBody = [self blockBody];
    
    return blockNode;
}

//code executed when hitting a toggle block
-(void)handleToggle:(ASBlockNode*)block {
    
    [[self.board.blockSets objectAtIndex:block.tag] switchSetsOnBoard:self.board];
}

//this is created in the DiamondData loop in ASLevelLoader // NOT USING STANDARD BLOCK PATH OR PHYSICS BODY //
-(ASBlockNode *)diamond {
    
    float size = (self.cellSize/4);
    CGRect blockRect = CGRectMake(0, 0, size, size);
    UIBezierPath *blockPath = [UIBezierPath bezierPathWithRect:blockRect];
    [blockPath applyTransform:CGAffineTransformMakeTranslation(-size/2, -size/2)];
    [blockPath applyTransform:CGAffineTransformMakeRotation(M_PI/4)];
    
    ASBlockNode *blockNode = [ASBlockNode node];
    blockNode.path = blockPath.CGPath;
    blockNode.fillColor = [UIColor colorWithRed:.7451 green:.7451 blue:.1176 alpha:1.0];
    blockNode.lineWidth = 0;
    blockNode.type = 'd';
    
    //create diamond physics body
    SKPhysicsBody *body = [SKPhysicsBody bodyWithPolygonFromPath:blockPath.CGPath];
    body.categoryBitMask = diamondCategory;
    body.allowsRotation = NO;
    body.dynamic = NO;
    blockNode.physicsBody = body;
    
    return blockNode;
}

//code executed when hitting a diamond. Last will trigger the goal to appear
-(void)handleDiamond:(ASBlockNode*)block {
    
    [block runAction:[SKAction scaleBy:2 duration:.4]];
    block.fillColor = [UIColor yellowColor];
    [block runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:.5], [SKAction removeFromParent]]]];
    [self.board.diamondSet removeObject:block];
    
    //BASIC FOR NOW BUT TO BE EXPANDED
    NSLog(@"diamond grabbed");
    
    if(self.board.diamondSet.count == 0) {
        
        
    }
}

//creates end goal block that spawns when all diamonds are collected
-(ASBlockNode *)goal {
    
    UIBezierPath *blockPath = [self blockPath];
    ASBlockNode *blockNode = [[ASBlockNode alloc]init];
    blockNode.path = blockPath.CGPath;
    blockNode.fillColor = [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
    blockNode.lineWidth = 0;
    blockNode.type = 'g';
    blockNode.zPosition = -1;
    
    blockNode.physicsBody = [self blockBody];
    //blockNode.physicsBody.;
    
    return blockNode;
}

//method that is called by the GameScene when a collision between the player and a block occurs (runs code for block that is hit)
-(void)handleBlock:(ASBlockNode*)block{
    
    switch (block.type) {
        case 'b':
            
            break;
        case 't':
            
            [self handleToggle:block];
            
            break;
        case 'd':
            
            [self handleDiamond:block];
            
            break;
        default:
            
            break;
    }
}

@end
