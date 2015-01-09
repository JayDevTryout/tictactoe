//
//  Game.h
//  TicTacToe
//
//  Created by j on 1/5/15.
//  Copyright (c) 2015 j. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HUMAN 0
#define MACHINE 1

extern const int TRIOS[8][3];

typedef enum {
    PLAYER_X = 0,
    PLAYER_O = 1
} PLAYER;

@protocol GameProtocol <NSObject>

-(void) updateCellatIndex:(int)index forPlayer:(int)player checkForWinner:(int*)winningTrio checkForGameOver:(BOOL)gameOver;

@end

@interface Game : NSObject

-(id) initWithXType:(int)xType withOType:(int)oType withDelegate:(id<GameProtocol>)delegate;
-(void)reset;
-(void)updateCellAtIndex:(int)index;

@property (nonatomic, assign) int playersTurn;

@end
