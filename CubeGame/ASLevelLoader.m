//
//  ASLevelLoader.m
//  CubeGame
//
//  Created by Adrian Siwy on 8/3/14.
//  Copyright (c) 2014 adriansiwy. All rights reserved.
//

#import "ASLevelLoader.h"

@implementation ASLevelLoader

-(id)init {
    
    if (self = [super init]) {
        
        //load both LevelDictionary and DiamondDictionary .plist files
        NSString *dictionary = [[NSBundle mainBundle]pathForResource:@"LevelDictionary" ofType:@"plist"];
        self.levelDictionary = [[NSDictionary alloc]initWithContentsOfFile:dictionary];
        dictionary = [[NSBundle mainBundle]pathForResource:@"DiamondDictionary" ofType:@"plist"];
        self.diamondDictionary = [[NSDictionary alloc]initWithContentsOfFile:dictionary];
    }
    
    return self;
}

-(ASBoardNode *)createLevelWithID:(int)levelKey {
    
    //get string for levelData and diamondData using levelID
    NSString *stringKey = [NSString stringWithFormat:@"%i",levelKey];
    NSString *levelData = [self.levelDictionary objectForKey:stringKey];
    NSString *diamondData = [self.diamondDictionary objectForKey:stringKey];
    
    //get gridSize and calculate cellSize
    char gridChar = [levelData characterAtIndex:0]; int gridSize = [NSString stringWithFormat:@"%c", gridChar].intValue;
    int cellSize = (float)260/gridSize;
    
    //create the board node
    ASBoardNode *board = [[ASBoardNode alloc]initWithGridSize:gridSize];
    
    //create instance of ASBlockController
    ASBlockController *block = [[ASBlockController alloc]initWithGridSize:gridSize];
    
    //init blockSets and create two sets for toggle block instances; create diamondSet for storing level diamonds
    board.blockSets = [[NSMutableArray alloc]init];
    NSMutableArray *set1 = [[NSMutableArray alloc]init];
    NSMutableArray *set2 = [[NSMutableArray alloc]init];
    board.diamondSet = [[NSMutableArray alloc]init];
    
    //ints for using while loop and cycling through the string
    int totalChars = (int)levelData.length;
    int currentChar = 1;
    int currentSet = 1;
    
    //chars for checking required block and location
    char character, value, x, y;
    
    //cycle through the levelData and create objects and object sets specified
    while (currentChar + 1 <= totalChars) {
        
        //get next char in levelData and the x and y coordinates (the two right after)
        character = [levelData characterAtIndex:currentChar];
        value = character;
        x = [levelData characterAtIndex:currentChar + 1]; int xInt = [NSString stringWithFormat:@"%c", x].intValue - 1;
        y = [levelData characterAtIndex:currentChar + 2]; int yInt = [NSString stringWithFormat:@"%c", y].intValue - 1;
        
        //create block node to be set to be given properties
        ASBlockNode *blockNode;
        
        //create blocks given in the LevelDictionary for the LevelKey
        switch (value) {
            case 'a':
            {
                //creates and sets new default array (Af) f = (c)reate or (n)ext
                switch (x) {
                    case 'c':
                    {
                        if (set2.count == 0) {
                                                     
                            board.defaultSet = set1;
                            
                        } else {
                            
                            ASBlockSet *newSet = [[ASBlockSet alloc]initWithSet1:set1 WithSet2:set2];
                            [board.blockSets addObject:newSet];
                            
                            currentSet = 1;
                        }
                        
                        set1 = [[NSMutableArray alloc]init];
                        set2 = [[NSMutableArray alloc]init];
                    }
                        break;
                    case 'n':
                    {
                        currentSet = 2;
                    }
                        break;
                }
                
                currentChar += 2;
            }
                break;
            case 'p':
            {
                //player block (Pxy)
                blockNode = [block player];
                blockNode.position = CGPointMake((xInt * cellSize), (yInt * cellSize));
                blockNode.name = @"player";
                board.player = blockNode;
                currentChar += 3;
            }
                break;
            case 'b':
            {
                //basic single block (Bxy)
                blockNode = [block basic];
                blockNode.position = CGPointMake((xInt * cellSize), (yInt * cellSize));
                currentChar += 3;
            }
                break;
            case 't':
            {
                //create toggle block (Txya) a = set
                blockNode = [block toggle];
                blockNode.position = CGPointMake((xInt * cellSize), (yInt * cellSize));
                char a = [levelData characterAtIndex:currentChar + 3]; int aInt = [NSString stringWithFormat:@"%c", a].intValue;
                blockNode.tag = aInt - 1;
                currentChar += 4;
            }
                break;
            case 'g':
            {
                //create goal block (Gxy)
                blockNode = [block goal];
                blockNode.position = CGPointMake((xInt * cellSize), (yInt * cellSize));
                board.goalBlock = blockNode;
                currentChar += 3;
            }
        }
        
        //adds block to either default set (first set1), or set1 or set2 for toggle block. As long as block is not nil
        if (blockNode != nil) {
            
            if (currentSet == 1) {
                
                [set1 addObject:blockNode];
                
            } else if (currentSet == 2) {
                
                [set2 addObject:blockNode];
                
            }
        }
    }
    
    //add blocks to default set (first batch)
    if (set2 == nil) {
        
        board.defaultSet = set1;
        
    } else {
        
        ASBlockSet *newSet = [[ASBlockSet alloc]initWithSet1:set1 WithSet2:set2];
        [board.blockSets addObject:newSet];
    }
    
    //reset totalChars and currentChar to be used again for diamondData loop
    totalChars = (int)diamondData.length;
    currentChar = 0;
    
    //create q char for diamond block queue
    char q;
    
    //loop that loads diamondData (blocks that must be collected for goal to appear)
    while (currentChar + 1 <= totalChars) {
        
        //get next diamond x and y coordinates
        x = [diamondData characterAtIndex:currentChar + 1]; int xInt = [NSString stringWithFormat:@"%c", x].intValue - 1;
        y = [diamondData characterAtIndex:currentChar + 2]; int yInt = [NSString stringWithFormat:@"%c", y].intValue - 1;
        q = [diamondData characterAtIndex:currentChar + 3]; int qInt = [NSString stringWithFormat:@"%c", q].intValue;
        
        //create blockNode to give properties
        ASBlockNode *blockNode;
        
        //create diamond block (Dxyq) q = place in queue
        blockNode = [block diamond];
        blockNode.position = CGPointMake((int)((xInt + .5f) * cellSize), (int)((yInt + .5f) * cellSize));
        blockNode.tag = qInt;
        currentChar += 4;
        
        [board.diamondSet addObject:blockNode];
    }
    
    return board;
}

@end
