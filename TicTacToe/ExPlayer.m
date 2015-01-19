//
//  ExPlayer.m
//  TicTacToe
//
//  Created by j on 1/18/15.
//  Copyright (c) 2015 j. All rights reserved.
//

#import "ExPlayer.h"
#import "Game.h"

// SCORES
#define LOSS -6
#define WON 5
#define LOSS_NOW -12
#define WON_NOW 10

// OUTCOMES
#define DRAW 2
#define NO_OUTCOME -1

@interface ExPlayer()

@property (nonatomic, assign) int opponent;

@end

@implementation ExPlayer

-(id)initForPlayer:(int)player
{
    self = [super init];
    if (self)
    {
        _player = player;
        _opponent = [self getOtherPlayer:player];
    }
    return self;
}

-(int)getMove:(int*)game
{
    int moves = 0;
    for (int i=0; i<9; i++)
        if (game[i]!=-1)
            moves++;
    if (moves == 0)
        return 4;
    
    int move = 4;
    int highScore = INT_MIN;
    for (int i=0; i<9; i++)
    {
        if (game[i]==-1)
        {
            int score = [self getScore:game score:0 index:i player:_player];
            if (score > highScore)
            {
                move = i;
                highScore = score;
            }
        }
    }
    
    return move;
}

-(int)getScore:(int*)game score:(int)score index:(int)index player:(int)player
{
    int* gameProgress;
    gameProgress = [self progressGame:game progress:gameProgress index:index player:player];
    int outCome = [self checkOutcome:gameProgress];
    
    if (outCome == _player)
        return score + WON;
    else if (outCome == _opponent)
        return score + LOSS;
    else if (outCome == DRAW)
        return score;
    
    // no outcome continue to progress
    int turn = [self getOtherPlayer:player];
    for (int i=0; i<9; i++)
    {
        if (game[i]==-1)
        {
            score += [self getScore:gameProgress score:score index:i player:turn];
        }
    }
    
    return 0;
}

-(int)checkOutcome:(int*)game
{
    int moves = 0;
    for (int i=0; i<8; i++)
    {
        if ( game[TRIOS[i][0]] != -1)
        {
            moves++;
            if (game[TRIOS[i][0]] == game[TRIOS[i][1]] && game[TRIOS[i][1]] == game[TRIOS[i][2]])
            {
                return game[TRIOS[i][0]];
            }
        }
    }
    if (moves==8)
        return DRAW;
    
    return -1;
}

-(int*)progressGame:(int*)game progress:(int*)newGame index:(int)index player:(int)player
{
    for (int i=0; i<9; i++)
    {
        newGame[i] = game[i];
    }
    newGame[index] = player;
    
    return newGame;
}

-(int)getOtherPlayer:(int)player
{
    return (player+1) % 2;
}

@end