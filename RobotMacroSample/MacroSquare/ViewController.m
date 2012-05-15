//
//  ViewController.m
//  HelloWorld
//
//  Created by Jon Carroll on 12/8/11.
//  Copyright (c) 2011 Orbotix, Inc. All rights reserved.
//

#import "ViewController.h"
#import "RobotKit/RobotKit.h"
#import "RobotKit/RKMacroObject.h"
#import "RobotKit/RKAbortMacroCommand.h"
@implementation ViewController

@synthesize sliderLabel;
@synthesize sliderLabel2;

@synthesize robotSpeed;
@synthesize robotDelay;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    /*Register for application lifecycle notifications so we known when to connect and disconnect from the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];

    /*Only start the blinking loop when the view loads*/
    robotOnline = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)appWillResignActive:(NSNotification*)notification {
    /*When the application is entering the background we need to close the connection to the robot*/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RKDeviceConnectionOnlineNotification object:nil];
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:0.0];
    [[RKRobotProvider sharedRobotProvider] closeRobotConnection];
}

-(void)appDidBecomeActive:(NSNotification*)notification {
    /*When the application becomes active after entering the background we try to connect to the robot*/
    [self setupRobotConnection];
}

- (void)handleRobotOnline {
    /*The robot is now online, we can begin sending commands*/
    if(!robotOnline) {

    }
    robotOnline = YES;
}


-(IBAction) sliderChanged:(id) sender{
	UISlider *slider = (UISlider *) sender;
	int progressAsInt =(int)(slider.value + 0.25f);
	
    NSString *newText =[[NSString alloc] initWithFormat:@"%d",progressAsInt];
    self.sliderLabel.text = newText;
    //[newText release];

}


-(IBAction) sliderChanged2:(id) sender{
	UISlider *slider = (UISlider *) sender;
	int progressAsInt =(int)(slider.value + 0.25f);
	
    NSString *newText2 =[[NSString alloc] initWithFormat:@"%d",progressAsInt];

	sliderLabel2.text = newText2;

    [newText2 release];
}
  
-(IBAction)MacroSquare:(id)sender{
 
    //Non-Efficient
    
    RKMacroObject *macro = [RKMacroObject new];
    
    [macro addCommand:[RKMCRGB commandWithRed:1.0 green:1.0 blue:1.0 delay:0]];
    [macro addCommand:[RKMCRoll commandWithSpeed:0.4 heading:0 delay:3000]];
    [macro addCommand:[RKMCCalibrate commandWithHeading:90 delay:0]];
    [macro addCommand:[RKMCRGB commandWithRed:1.0 green:1.0 blue:1.0 delay:0]];
    [macro addCommand:[RKMCRoll commandWithSpeed:0.4 heading:90 delay:3000]];
    [macro addCommand:[RKMCCalibrate commandWithHeading:180 delay:0]];
    [macro addCommand:[RKMCRGB commandWithRed:1.0 green:1.0 blue:1.0 delay:0]];
    [macro addCommand:[RKMCRoll commandWithSpeed:0.4 heading:180 delay:3000]];
    [macro addCommand:[RKMCCalibrate commandWithHeading:270 delay:0]];
    [macro addCommand:[RKMCRGB commandWithRed:1.0 green:1.0 blue:1.0 delay:0]];
    [macro addCommand:[RKMCRoll commandWithSpeed:0.4 heading:270 delay:3000]];
    [macro addCommand: [RKMCCalibrate commandWithHeading:0 delay:0]];
    [macro addCommand:[RKMCRGB commandWithRed:1.0 green:1.0 blue:1.0 delay:0]];
    [macro addCommand:[RKMCRoll commandWithSpeed:0.0 heading:0 delay:3000]];
    [macro playMacro];
     
}

-(IBAction)MacroSquare2:(id)sender{
    

     //Efficient Macro
     RKMacroObject *macro = [RKMacroObject new];
     [macro addCommand:[RKMCLoopFor commandWithRepeats:4]];
     [macro addCommand:[RKMCRGB commandWithRed:0.0 green:1.0 blue:0.0 delay:0]];
     [macro addCommand:[RKMCRoll commandWithSpeed:0.4 heading:0 delay:3000]];
     [macro addCommand:[RKMCRGB commandWithRed:0.0 green:0.0 blue:1.0 delay:0]];
     [macro addCommand:[RKMCCalibrate commandWithHeading:90 delay:0]];
     [macro addCommand:[RKMCCalibrate commandWithHeading:0 delay:0]];
     [macro addCommand:[RKMCRGB commandWithRed:1.0 green:0.0 blue:0.0 delay:0]];
     [macro addCommand:[RKMCRoll commandWithSpeed:0.0 heading:0 delay:1000]];
     [macro addCommand:[RKMCLoopEnd command]];
     [macro playMacro];
    
}


-(IBAction)MacroColor:(id)sender{
     RKMacroObject *macro = [RKMacroObject new];
    [macro addCommand:[RKMCRGB commandWithRed:1.0 green:1.0 blue:1.0 delay:4000]];
     [macro playMacro];
}

-(IBAction)AbortMacro:(id)sender{
    [RKAbortMacroCommand sendCommand];
    [RKRollCommand sendCommandWithHeading:0 velocity:0.0];
    [RKStabilizationCommand sendCommandWithState:(RKStabilizationStateOn)];
}


-(void)setupRobotConnection {
    /*Try to connect to the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    if ([[RKRobotProvider sharedRobotProvider] isRobotUnderControl]) {
        [[RKRobotProvider sharedRobotProvider] openRobotConnection];        
    }
}

@end
