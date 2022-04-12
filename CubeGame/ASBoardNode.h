//
//  ASBoardNode.h
//  CubeGame
//
//  Created by Adrian Siwy on 7/27/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ASBlockNode.h"
#import "ASInfoNode.h"

@interface ASBoardNode : SKNode

@property int gridSize;
@property SKShapeNode *field;
@property ASBlockNode *player, *goalBlock;
@property NSMutableArray *gridBlocks, *blockSets, *defaultSet, *diamondSet;
@property ASInfoNode *info;

-(id)initWithGridSize:(int)gridSize;
-(void)addBlocksToBoard;
-(void)addDiamondsToBoard;
-(void)addGridBlocksToBoard;

@end
