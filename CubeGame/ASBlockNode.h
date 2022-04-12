//
//  ASBlockNode.h
//  CubeGame
//
//  Created by Adrian Siwy on 9/14/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ASBlockNode : SKShapeNode

//stuff to be added here
@property char type;

//tag is used to define an attribute for different blocks (used differently based on the block) and set used for diamond blocks
@property int tag, set;

@end
