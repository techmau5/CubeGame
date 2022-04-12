//
//  ASBlockController.h
//  CubeGame
//
//  Created by Adrian Siwy on 8/2/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ASBlockNode.h"
#import "ASBoardNode.h"

typedef enum {vertical, horizontal} bodyOrientation;

@interface ASBlockController : SKNode

@property int gridSize;
@property float cellSize;
@property ASBoardNode *board;

-(id)initWithGridSize:(int)gridSize;

//block types
-(ASBlockNode*)player;
-(ASBlockNode*)basic;
-(ASBlockNode*)toggle;
-(ASBlockNode*)goal;
-(ASBlockNode*)diamond;

-(SKShapeNode*)setBodyOrientation:(bodyOrientation)orientation OfPlayer:(SKShapeNode*)player;

-(void)handleBlock:(ASBlockNode*)block;

@end
