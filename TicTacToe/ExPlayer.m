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
#define LOSS -10
#define WON 10
#define DREW 0

// OUTCOMES
#define DRAW 2

@interface ExPlayer()

@property (nonatomic, assign) int opponent;

@end

@implementation ExPlayer

-(id)initForPlayer:(int)player
{
    self = [super init];
    if (self)
    {
        self.player = player;
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
        return random() % 9;
    
    int move = -1;
    int highScore = INT_MIN;
    for (int i=0; i<9; i++)
    {
        if (game[i]==-1)
        {
            int score = [self getScore:game move:i player:self.player];
            
            NSLog(@"MOVE TO: %d - score: %d", i, score);
            
            if (score > highScore)
            {
                move = i;
                highScore = score;
            }
        }
    }
    return move;
}

-(int)getScore:(int*)game move:(int)index player:(int)player
{
    int gameProgress[9];
    progressGame(game, gameProgress, index, player);
    
    int outCome = [self checkOutcome:gameProgress];
    
    if (outCome == self.player)
    {
        return WON;
    }
    else if (outCome == _opponent)
    {
        return LOSS;
    }
    else if (outCome == DRAW)
    {
        return DREW;
    }
    
    // no outcome continue to progress
    int nextPlayer = [self getOtherPlayer:player];
    int score = (nextPlayer==self.player) ? INT_MIN : INT_MAX;
    
    for (int i=0; i<9; i++)
    {
        if (gameProgress[i]==-1)
        {
            if (nextPlayer == self.player)
                score = MAX(score, [self getScore:gameProgress move:i player:nextPlayer]);
            else
                score = MIN(score, [self getScore:gameProgress move:i player:nextPlayer]);
        }
    }
    
    return score;
}

-(int)checkOutcome:(int*)game
{
    for (int i=0; i<8; i++)
    {
        if ( game[TRIOS[i][0]] != -1 )
        {
            if (game[TRIOS[i][0]] == game[TRIOS[i][1]] && game[TRIOS[i][1]] == game[TRIOS[i][2]])
            {
                return game[TRIOS[i][0]];
            }
        }
    }
    if ([self isGameOver:game])
        return DRAW;
    
    return -1;
}

-(BOOL)isGameOver:(int*)game
{
    for (int i=0; i<9; i++)
    {
        if (game[i] == -1)
            return NO;
    }
    return YES;
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

void progressGame(int* game, int* newGame, int index, int player)
{
    for (int i=0; i<9; i++)
    {
        newGame[i] = game[i];
    }
    newGame[index] = player;
}

-(int)getOtherPlayer:(int)player
{
    return (player+1) % 2;
}

-(void)printGame:(int*)game
{
    NSString *s = @"";
    
    for (int i=0; i<9; i++)
    {
        s = [s stringByAppendingFormat:@"%d,", game[i]];
    }
    
    NSLog(@"%@", [s substringToIndex:[s length] - 1]);
}

@end