//
//  CellView.m
//  TicTacToe
//
//  Created by j on 1/4/15.
//  Copyright (c) 2015 j. All rights reserved.
//

#import "CellView.h"
#import "Game.h"

#define O @"O"
#define X @"X"
#define BLANK @""

@interface CellView ()

- (void)handleSelected:(UITapGestureRecognizer *)recognizer;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITapGestureRecognizer *singleFingerTap;

@end

@implementation CellView

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor darkGrayColor];
        
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:frame.size.height - 6];
        [self addSubview:_label];
        
        _singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelected:)];
        [self addGestureRecognizer:_singleFingerTap];
    }
    return self;
}

- (void)handleSelected:(UITapGestureRecognizer *)recognizer
{
    [_delegate handleCellSelected:self];
}

-(void) setCell:(int)player
{
    [self removeGestureRecognizer:_singleFingerTap];
    switch (player) {
        case PLAYER_X:
            _label.text = X;
            break;
        case PLAYER_O:
            _label.text = O;
            break;
        default:
            break;
    }
}

-(void) reset
{
    [self removeAllGestureRecognizers];
    [self addGestureRecognizer:_singleFingerTap];
    _label.textColor = [UIColor blackColor];
    _label.text = BLANK;
}

-(void) setWin
{
    _label.textColor = [UIColor redColor];
}

-(void) removeAllGestureRecognizers
{
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        [self removeGestureRecognizer:recognizer];
    }
}

@end
