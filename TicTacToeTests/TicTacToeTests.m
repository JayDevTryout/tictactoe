//
//  TicTacToeTests.m
//  TicTacToeTests
//
//  Created by j on 1/3/15.
//  Copyright (c) 2015 j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ExPlayer.h"
#import "Game.h"

@interface TicTacToeTests : XCTestCase

@property (nonatomic, strong) ExPlayer *player;

@end

@implementation TicTacToeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _player  = [[ExPlayer alloc] initForPlayer:PLAYER_X];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    
    NSLog(@"START TEST");
    
    int game[9] = {PLAYER_O, -1, -1, PLAYER_X, PLAYER_X, PLAYER_O, -1, PLAYER_O, -1};
    NSLog(@"MOVE: %d", [_player getMove:game]);
    
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
