//
//  Cell.m
//  TicTacToe
//
//  Created by j on 1/5/15.
//  Copyright (c) 2015 j. All rights reserved.
//

#import "Player.h"
#import "Game.h"

const int CORNERS[4] = {0,2,6,8};
const int EDGES[4] = {1,3,5,7};
const int FIRST_MOVES[5] = {0,2,4,6,8};

@interface Player()

-(int) inspectTrios;
-(int) getOffensiveMove:(int*)trioIndices count:(int)count;
-(int) defendFork:(int*)threatTrios count:(int)count;
-(int) findIntersect:(int*)trio1 intersect:(int*)trio2;
-(int) defendCornerAttack;
-(int) makeEarlyMove;

@property (nonatomic, assign) int opponent;
@property (nonatomic, assign) int winIndex;

@property (nonatomic, assign) int* game;
@property (nonatomic, strong) NSMutableSet* blanks;
@property (nonatomic, assign) int totalMoves;

@end

@implementation Player


-(id)initForPlayer:(int)player
{
    self = [super init];
    if (self)
    {
        _player = player;
        _opponent = (player+1) % 2;
        
        _blanks = [[NSMutableSet alloc] init];
    }
    return self;
}

-(int)getMove:(int*)game
{
    _game = game;
    [_blanks removeAllObjects];
    _totalMoves = 0;
    for (int i=0; i<9; i++)
    {
        int cellContent = _game[i];
        
        if (cellContent == _player)
            _totalMoves++;
        else if (cellContent == _opponent)
            _totalMoves++;
        else
            [_blanks addObject:@(i)];
    }
    return [self inspectTrios];
}


-(int)inspectTrios
{
    // collect data
    int potentialTrioIndices[8];
    int potentialTriosCount = 0;
    
    int threatTrioIndices[8];
    int threatTriosCount = 0;
    int threatIndices[9];
    int threatCount = 0;
    
    // loop
    int playerIndices[3];
    int opponentIndices[3];
    int blankIndices[3];
    
    int playerCount = 0;
    int opponentCount = 0;
    int blankCount = 0;

    int winIndex = -1;
    int block2Index = -1;
    
    for (int i=0; i<8; i++)
    {
        playerCount = 0;
        opponentCount = 0;
        blankCount = 0;
        
        int lastOppIndex = 0;
        
        for (int j=0; j<3; j++)
        {
            int cellIndex = TRIOS[i][j];
            
            if (_game[cellIndex] == _player)
            {
                playerIndices[playerCount] = cellIndex;
                playerCount++;
            }
            else if (_game[cellIndex] == _opponent)
            {
                opponentIndices[opponentCount] = cellIndex;
                lastOppIndex = cellIndex;
                opponentCount++;
            }
            else if (_game[cellIndex] == -1)
            {
                blankIndices[blankCount] = cellIndex;
                blankCount++;
            }
        }
        if (playerCount == 2 && blankCount == 1)
        {
            //win
            winIndex = blankIndices[0];
        }
        else if (opponentCount == 2 && blankCount == 1)
        {
            //block opponent win
            block2Index = blankIndices[0];
        }
        else if (opponentCount == 1 && blankCount == 2)
        {
            // keep track of opponent threats (fork move)
            threatTrioIndices[threatTriosCount] = i;
            threatTriosCount++;
            
            BOOL loadThreat = YES;
            for (int k=0; k<threatCount; k++)
            {
                if (threatIndices[k] == lastOppIndex)
                    loadThreat = NO;
            }
            if (loadThreat)
                threatIndices[threatCount++] = lastOppIndex;
            
        }
        else if (playerCount == 1 && blankCount == 2)
        {
            // keep track of potential win trios
            potentialTrioIndices[potentialTriosCount] = i;
            potentialTriosCount++;
        }
    }
    
    // decision
    if (winIndex > -1)
    {
        NSLog(@"WIN");
        return winIndex;
    }
    
    if (block2Index > -1)
    {
        NSLog(@"BLOCK 2");
        return block2Index;
    }
    
    if (_totalMoves == 3)
    {
        // special corner case
        int cellIndex = [self defendCornerAttack];
        if (cellIndex > -1)
            return cellIndex;
    }
    
    if (threatCount > 1)
    {
        // defend fork move
        int cellIndex = [self defendFork:threatTrioIndices count:threatTriosCount];
        if (cellIndex > -1)
            return cellIndex;
    }
    
    if (potentialTriosCount > 0)
    {
        // try a little offense
        int cellIndex = [self getOffensiveMove:potentialTrioIndices count:potentialTriosCount];
        if (cellIndex > -1)
            return cellIndex;
    }
    
    return [self makeEarlyMove];
}


-(int) getOffensiveMove:(int*)trioIndices count:(int)count
{
    for (int i=0; i<count; i++) {
        
        NSMutableSet *set = [[NSMutableSet alloc] init];

        for (int j=0; j<3; j++)
            [set addObject:@(TRIOS[trioIndices[i]][j])];
 
        NSMutableSet *intersect = [[NSMutableSet alloc] init];
        [intersect setSet:_blanks];
        [intersect intersectSet:set];
        
        if ([intersect count] > 0)
        {
            NSLog(@"OFFENSE");
            return [[intersect anyObject] integerValue];
        }
    }
    return -1;
}


-(int) defendFork:(int*)threatTrios count:(int)count
{
    int horizTrio = -1;
    int vertTrio = -1;
    int diagTrio = -1;
    
    for (int i=0; i<count; i++) {
        
        if (threatTrios[i] < 3)
            horizTrio = threatTrios[i];
        else if (threatTrios[1] < 6)
            vertTrio = threatTrios[i];
        else
            diagTrio = threatTrios[i];
    }
    
    if (horizTrio>0 && vertTrio>0)
        return [self findIntersect:(int*)TRIOS[horizTrio] intersect:(int*)TRIOS[vertTrio]];
    else if (horizTrio>0 && diagTrio>0)
        return [self findIntersect:(int*)TRIOS[horizTrio] intersect:(int*)TRIOS[diagTrio]];
    else if (vertTrio>0 && diagTrio>0)
        return [self findIntersect:(int*)TRIOS[vertTrio] intersect:(int*)TRIOS[diagTrio]];
    
    return -1;
}

-(int) findIntersect:(int*)trio1 intersect:(int*)trio2
{
    NSMutableSet *set1 = [[NSMutableSet alloc] init];
    NSMutableSet *set2 = [[NSMutableSet alloc] init];
    
    for (int i=0; i<3; i++) {
        
        [set1 addObject:@(trio1[i])];
        [set2 addObject:@(trio2[i])];
    }
    
    NSMutableSet *intersect = [[NSMutableSet alloc] init];
    
    [set1 intersectSet:set2];
    [intersect setSet:_blanks];
    [intersect intersectSet:set1];
    
    if ([intersect count] > 0)
    {
        NSLog(@"DEFEND FORK");
        return [[intersect anyObject] integerValue];
    }
 
    return -1;
}

-(int) makeEarlyMove
{
    if (_totalMoves == 0)
    {
        NSLog(@"RANDOM");
        return FIRST_MOVES[random() % 6];
    }
    
    if ([_blanks containsObject:@(4)]) // middle
    {
        NSLog(@"MIDDLE");
        return 4;
    }
    
    for (int i=0; i<4; i++) {
        
        if ([_blanks containsObject:@(CORNERS[i])]) // corners
        {
            NSLog(@"CORNER");
            return CORNERS[i];
        }
    }
    
    return [[_blanks anyObject] integerValue];
}

-(int) defendCornerAttack
{
    if ((_game[0] == _opponent && _game[8] == _opponent) || (_game[2] == _opponent && _game[6] == _opponent))
    {
        NSLog(@"CORNER ATTACK");
        for (int i=0; i<4; i++)
        {
            if ([_blanks containsObject:@(EDGES[i])])
                return EDGES[i];
        }
    }
    return -1;
}

@end
