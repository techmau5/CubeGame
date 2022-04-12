//
//  ASLevelLoader.h
//  CubeGame
//
//  Created by Adrian Siwy on 8/3/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ASBoardNode.h"
#import "ASBlockController.h"
#import "ASBlockNode.h"
#import "ASBlockSet.h"

@interface ASLevelLoader : NSObject

@property NSDictionary *levelDictionary, *diamondDictionary;

-(ASBoardNode*)createLevelWithID:(int)levelID;

@end
