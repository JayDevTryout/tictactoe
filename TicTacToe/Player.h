//
//  Cell.h
//  TicTacToe
//
//  Created by j on 1/5/15.
//  Copyright (c) 2015 j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

-(id)initForPlayer:(int)player;
-(int)getMove:(int*)game;

@property (nonatomic, assign) int player;

@end
