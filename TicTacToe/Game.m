//
//  Game.m
//  TicTacToe
//
//  Created by j on 1/5/15.
//  Copyright (c) 2015 j. All rights reserved.
//

#import "Game.h"
#import "Player.h"

// All possible trios rows, columns, diagnols (a trio is three x/o's in a row)
const int TRIOS[8][3] = {0,1,2,3,4,5,6,7,8,0,3,6,1,4,7,2,5,8,0,4,8,2,4,6};
int _cells[9];

@interface Game()

-(void)reset;
-(int*) winner;

@property (nonatomic, weak) id<GameProtocol> delegate;
@property (nonatomic, retain) Player *player1;
@property (nonatomic, retain) Player *player2;
@property (nonatomic, assign) int moves;

@end

@implementation Game

-(id) initWithXType:(int)xType withOType:(int)oType withDelegate:(id<GameProtocol>)delegate
{
    self = [super init];
    
    if (self)
    {
        self.delegate = delegate;
        
        if (xType == MACHINE)
            _player1 = [[Player alloc] initForPlayer:PLAYER_X];
        
        if (oType == MACHINE)
            _player2 = [[Player alloc] initForPlayer:PLAYER_O];
        
        [self reset];
    }
    
    return self;
}

-(void)updateCellAtIndex:(int)index
{
    NSLog(@"PLAYER: %d INDEX: %d TOTAL MOVES: %d", _playersTurn, index, _moves);
    
    _cells[index] = _playersTurn;
    
    int* winner = self.winner;
    BOOL gameOver = ((_moves == 8) || (winner != nil));
    [_delegate updateCellatIndex:index forPlayer:_playersTurn checkForWinner:winner checkForGameOver:gameOver];
    
    if ((winner == nil) && (_moves < 8))
    {
        _playersTurn = (_playersTurn+1) % 2;
        [self checkPlayersTurn];
        _moves++;
    }
    else
    {
        if (winner != nil)
            NSLog(@"PLAYER %d WON", _playersTurn);
        NSLog(@"-----------------------------------------");
    }
}

-(void) checkPlayersTurn
{
    if (_player1)
    {
        if (_playersTurn == _player1.player)
        {
            [self performSelector:@selector(go1) withObject:nil afterDelay:0.25];
        }
    }
    if (_player2)
    {
        if (_playersTurn == _player2.player)
        {
            [self performSelector:@selector(go2) withObject:nil afterDelay:0.25];
        }
    }
}

-(void) go1
{
    [self updateCellAtIndex:[_player1 getMove:_cells]];
}

-(void) go2
{
    [self updateCellAtIndex:[_player2 getMove:_cells]];
}

-(int*)winner
{
    for (int i=0; i<8; i++)
    {
        if ( _cells[TRIOS[i][0]] != -1 && (_cells[TRIOS[i][0]] == _cells[TRIOS[i][1]] && _cells[TRIOS[i][1]] == _cells[TRIOS[i][2]]) )
        {
            return (int*)TRIOS[i];
        }
    }
    return nil;
}

-(void)reset
{
    for (int i=0; i<9; i++)
        _cells[i] = -1;
    
    _playersTurn = PLAYER_X;
    _moves = 0;
    [self checkPlayersTurn];
}

@end
