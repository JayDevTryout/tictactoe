//
//  ViewController.m
//  TicTacToe
//
//  Created by j on 1/3/15.
//  Copyright (c) 2015 j. All rights reserved.
//

#import "MenuController.h"
#import "GameController.h"

@interface MenuController ()

@property (nonatomic, strong) NSArray* pickerData;

@end

@implementation MenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"TicTacToe";
    
    _pickerData = @[@"Human", @"Machine"];
    
    self.xPicker.delegate = self;
    self.xPicker.dataSource = self;
    self.oPicker.delegate = self;
    self.oPicker.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)startButtonClicked:(id)sender {
    
    GameController *gc = [[GameController alloc] initWithXType:[self.xPicker selectedRowInComponent:0]
                                                     withOType:[self.oPicker selectedRowInComponent:0]];
    
    [self.navigationController pushViewController:gc animated:YES];
}

#pragma mark picker view datasource/delegate

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}


@end
