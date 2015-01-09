//
//  GameController.m
//  TicTacToe
//
//  Created by j on 1/4/15.
//  Copyright (c) 2015 j. All rights reserved.
//

#import "GameController.h"

typedef NS_ENUM(int, GAME_STATE) {
    STARTED,
    OVER
};

@interface GameController ()

-(void) newGame:(id)sender;

@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) NSMutableArray *cells;

@property (nonatomic, assign) int xType;
@property (nonatomic, assign) int oType;

@end

@implementation GameController


-(id) initWithXType:(int)xType withOType:(int)oType
{
    _xType = xType;
    _oType = oType;
    
    return [super initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _cells = [[NSMutableArray alloc] initWithCapacity:9];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New game"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(newGame:)];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // vars
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    int containerEdge = (screenWidth - 20);
    int cellEdge = (containerEdge - 10)/3;
    
    // container
    UIView *container = [[UIView alloc] initWithFrame:
                         CGRectMake((screenWidth - containerEdge)/2,
                                    (screenHeight - containerEdge)/2,
                                     containerEdge,
                                     containerEdge)];
    container.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:container];
    
    // cells
    int index = 0;
    int y = 0;
    for (int i=0; i<3; i++) {
        
        int x = 0;
        for (int j=0; j<3; j++) {
            
            CellView *view = [[CellView alloc] initWithFrame:CGRectMake(x, y, cellEdge, cellEdge)];
            view.delegate = self;
            [container addSubview:view];
            view.index = index++;
            [_cells addObject:view];
            x += cellEdge+5;
        }
        y += cellEdge+5;
    }
    
    // start game
    _game = [[Game alloc] initWithXType:_xType withOType:_oType withDelegate:self];
}

#pragma mark cell view protocol

- (void)handleCellSelected:(CellView *)view
{
    if (_game.playersTurn == PLAYER_X && _xType == MACHINE)
        return;
    if (_game.playersTurn == PLAYER_O && _oType == MACHINE)
        return;
    
    int index = view.index;
    [_game updateCellAtIndex:index];
}

#pragma mark game protocol

-(void) updateCellatIndex:(int)index forPlayer:(int)player checkForWinner:(int*)winningTrio checkForGameOver:(BOOL)gameOver
{
    CellView *view = (CellView *)[_cells objectAtIndex:index];
    [view setCell:player];
    
    if (winningTrio != nil)
    {
        int i=0;
        int index=0;
        for (CellView *view in _cells)
        {
            if (i == winningTrio[index])
            {
                [view setWin];
                if (index < 2)
                    index++;
            }
            else
            {
                [view setCell:-1];
            }
            i++;
        }
    }
}

#pragma mark helpers

-(void) newGame:(id)sender
{
    for (CellView *view in _cells)
        [view reset];
    
    [_game reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
