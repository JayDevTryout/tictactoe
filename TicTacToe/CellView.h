//
//  CellView.h
//  TicTacToe
//
//  Created by j on 1/4/15.
//  Copyright (c) 2015 j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellView;

@protocol CellViewClick <NSObject>

- (void)handleCellSelected:(CellView *)view;

@end

@interface CellView : UIView

@property (nonatomic, weak) id<CellViewClick> delegate;
@property (nonatomic, assign) int index;

-(void) setCell:(int)player;
-(void) reset;
-(void) setWin;

@end
