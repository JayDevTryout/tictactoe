//
//  GameController.h
//  TicTacToe
//
//  Created by j on 1/4/15.
//  Copyright (c) 2015 j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "CellView.h"

@interface GameController : UIViewController <CellViewClick, GameProtocol>

-(id) initWithXType:(int)xType withOType:(int)yType;

@end
