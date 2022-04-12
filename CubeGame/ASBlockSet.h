//
//  ASBlockSet.h
//  CubeGame
//
//  Created by Adrian Siwy on 10/9/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASBoardNode.h"

@interface ASBlockSet : SKNode

@property int activeSet;

@property NSMutableArray *set1, *set2;

-(id)initWithSet1:(NSMutableArray*)set1 WithSet2:(NSMutableArray*)set2;

-(void)initToBoard:(ASBoardNode*)board;
-(void)switchSetsOnBoard:(ASBoardNode*)board;

@end
