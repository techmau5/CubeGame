//
//  ASBoardNode.m
//  CubeGame
//
//  Created by Adrian Siwy on 7/27/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import "ASBoardNode.h"
#import "ASBlockSet.h"

@implementation ASBoardNode

{
    int cellSize;
    float offset;
}

static const uint32_t boardCategory = 0x1 << 2;

-(id)initWithGridSize:(int)gridSize {
    
    if (self = [super init]) {
        
        self.gridSize = gridSize;
        cellSize = (float)260/gridSize;
        offset = (float)(260 - (self.gridSize * cellSize))/2;
        
        NSLog(@"The offset is: %f", offset);
        
        //create new bg
        UIBezierPath *fieldPath = [UIBezierPath bezierPath];
        [fieldPath moveToPoint:CGPointMake(14, 0)];
        [fieldPath addLineToPoint:CGPointMake(0, 14)];
        [fieldPath addLineToPoint:CGPointMake(0, 266)];
        [fieldPath addLineToPoint:CGPointMake(14, 280)];
        [fieldPath addLineToPoint:CGPointMake(266, 280)];
        [fieldPath addLineToPoint:CGPointMake(280, 266)];
        [fieldPath addLineToPoint:CGPointMake(280, 14)];
        [fieldPath addLineToPoint:CGPointMake(266, 0)];
        [fieldPath closePath];
        
        self.field = [[SKShapeNode alloc]init];
        self.field.path = fieldPath.CGPath;
        self.field.lineWidth = 0;
        self.field.fillColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
        self.field.position = CGPointMake(-offset - 10, -offset - 10);
        self.field.zPosition = -1;
        self.field.alpha = 0;
        
        //anim,ate field in
        [self.field runAction:[SKAction fadeAlphaTo:1 duration:.5]];
        [self addChild:self.field];
        
        //create border physics body
        CGRect edgeRect = CGRectMake(0, 0, 260 - (2 * offset), 260 - (2 * offset));
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:edgeRect];
        self.physicsBody.categoryBitMask = boardCategory;
        
        //create grid blocks
        {
            int gridX = 1;
            int gridY = 1;
            int blockCount = (gridSize - 1) * (gridSize - 1);
            
            self.gridBlocks = [[NSMutableArray alloc]init];
            
            for (int i = 1; i <= blockCount; i++) {
                
                if (gridY == gridSize) {
                    
                    gridX += 1;
                    gridY = 1;
                }
                
                SKShapeNode *gridBlock = [self gridBlock];
                gridBlock.position = CGPointMake(gridX * cellSize, gridY * cellSize);
                gridBlock.zPosition = 1;
                [self.gridBlocks addObject:gridBlock];
                gridY += 1;
            }
        }
        
        //reorganize grid blocks into animation order
        {
            int pointSize = gridSize - 1;
            
            NSMutableArray *reorganizedArray = [[NSMutableArray alloc]init];
            
            for (int gridPoint = 1; gridPoint <= pointSize; gridPoint++) {
                
                [reorganizedArray addObject:[NSNumber numberWithInt:gridPoint]];
                
                NSNumber *previousPoint;
                
                for (int i = 1; i < gridPoint; i++) {
                    
                    int lastEntry = (int)[reorganizedArray count] - 1;
                    previousPoint = [reorganizedArray objectAtIndex:lastEntry];
                    int point = previousPoint.intValue + pointSize - 1;
                    [reorganizedArray addObject:[NSNumber numberWithInt:point]];
                }
            }
            
            for (int gridPoint = 2; gridPoint <= pointSize; gridPoint++) {
                
                [reorganizedArray addObject:[NSNumber numberWithInt:pointSize * (gridPoint)]];
                
                NSNumber *previousPoint;
                
                for (int i = pointSize - gridPoint; i > 0; i--) {
                    
                    int lastEntry = (int)[reorganizedArray count] - 1;
                    previousPoint = [reorganizedArray objectAtIndex:lastEntry];
                    int point = previousPoint.intValue + pointSize - 1;
                    [reorganizedArray addObject:[NSNumber numberWithInt:point]];
                }
            }
            
            NSMutableArray *organizedArray = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < [reorganizedArray count]; i++) {
                
                NSNumber *index = [reorganizedArray objectAtIndex:i];
                [organizedArray addObject:[self.gridBlocks objectAtIndex:index.intValue - 1]];
            }
            
            self.gridBlocks = organizedArray;
        }
        
        self.info = [[ASInfoNode alloc]init];
        [self addChild:self.info];
        
        self.blockSets = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)addBlocksToBoard {
    
    for (ASBlockNode *block in self.defaultSet) {
        
        [block runAction:[SKAction fadeInWithDuration:.7]];
        [self addChild:block];
    }

    for (ASBlockSet *blockSet in self.blockSets) {
        
        [blockSet initToBoard:self];
    }
}

-(void)addDiamondsToBoard {
    
    for (ASBlockNode *block in self.diamondSet) {
        
        [block runAction:[SKAction fadeInWithDuration:.7]];
        [self addChild:block];
    }
}

-(SKShapeNode *)gridBlock {
    
    float size = (cellSize/4)/.8071f;
    CGRect blockRect = CGRectMake(0, 0, size, size);
    UIBezierPath *blockPath = [UIBezierPath bezierPathWithRect:blockRect];
    [blockPath applyTransform:CGAffineTransformMakeTranslation(-size/2, -size/2)];
    [blockPath applyTransform:CGAffineTransformMakeRotation(M_PI/4)];
    SKShapeNode *blockShape = [SKShapeNode node];
    blockShape.path = blockPath.CGPath;
    blockShape.fillColor = [UIColor colorWithRed:.1 green:.1 blue:.8 alpha:.8];
    blockShape.lineWidth = 0;
    
    return blockShape;
}

-(void)addGridBlocksToBoard {
    
    for (int i = 0; i <= ((self.gridSize - 1) * (self.gridSize - 1) - 1); i++) {
        
        float gridOffset = 0;
        
        if (self.gridSize > 7) gridOffset = .5;
        
        SKShapeNode *node = [self.gridBlocks objectAtIndex:i];
        node.position = CGPointMake(node.position.x + gridOffset, node.position.y + gridOffset);
        [self addChild:node];
        SKAction *scale = [SKAction sequence:@[[SKAction scaleTo:0 duration:0],[SKAction waitForDuration:(float)(i/14)/self.gridSize],[SKAction scaleTo:1 duration:1]]];
        [node runAction:scale];
    }
}

@end
