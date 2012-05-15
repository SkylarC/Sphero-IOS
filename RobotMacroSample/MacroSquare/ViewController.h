//
//  ViewController.h
//  HelloWorld
//
//  Created by Jon Carroll on 12/8/11.
//  Copyright (c) 2011 Orbotix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    BOOL ledON;
    BOOL robotOnline;
    NSString *robotSpeed;
    NSString *robotDelay;
    UILabel     *sliderLabel;
    UILabel     *sliderLabel2;
}
@property (nonatomic,retain) NSString *robotSpeed;
@property (nonatomic,retain) NSString *robotDelay;
@property (nonatomic,retain) IBOutlet UILabel *sliderLabel;
@property (nonatomic,retain) IBOutlet UILabel *sliderLabel2;

-(IBAction) sliderChanged:(id) sender;
//-(IBAction) sliderChanged2:(id) sender;
-(void)setupRobotConnection;
-(void)handleRobotOnline;
-(IBAction)MacroSquare:(id) sender;
-(IBAction)MacroSquare2:(id) sender;
-(IBAction)MacroColor:(id) sender;
-(IBAction)AbortMacro:(id) sender;
@end

