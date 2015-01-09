//
//  ViewController.h
//  TicTacToe
//
//  Created by j on 1/3/15.
//  Copyright (c) 2015 j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

-(IBAction)startButtonClicked:(id)sender;

@property IBOutlet UIPickerView* xPicker;
@property IBOutlet UIPickerView* oPicker;

@end

