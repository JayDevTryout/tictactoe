//
//  ExPlayer.h
//  TicTacToe
//
//  Created by j on 1/18/15.
//  Copyright (c) 2015 j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExPlayer : NSObject

-(id)initForPlayer:(int)player;
-(int)getMove:(int*)game;

@property (nonatomic, assign) int player;

@end
