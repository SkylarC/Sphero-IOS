//
//  ViewController.h
//  RobotUISample
//
//  Created by Jon Carroll on 12/9/11.
//  Copyright (c) 2011 Orbotix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RobotUIKit/RobotUIKit.h>
#import <RobotKit/RobotKit.h>
#import "CircularUIView.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController <RUIColorPickerDelegate> {
    BOOL robotOnline;
    RUICalibrateGestureHandler *calibrateHandler;
    
    //Views that make up the drive joystick
    IBOutlet UIView *driveWheel;
    IBOutlet UIImageView *drivePuck;
    IBOutlet CircularUIView *circularView;
    
    
    UIImageView * theimageView;
	UIButton * choosePhoto;
	UIButton * takePhoto;
    
    BOOL ballMoving;
}

-(void)setupRobotConnection;
-(void)handleRobotOnline;

//Joystick drive related methods
-(float)clampWithValue:(float)value min:(float)min max:(float)max;
-(void)updateMotionIndicator:(RKDriveAlgorithm*)driveAlgorithm;
-(void)handleJoystickMotion:(id)sender;


@property (nonatomic, retain) IBOutlet UIImageView * theimageView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhoto;
@property (nonatomic, retain) IBOutlet UIButton * takePhoto;


//UI Interaction
-(IBAction)colorPressed:(id)sender;
-(IBAction)sleepPressed:(id)sender;
-(IBAction)boostPressed:(id)sender;
-(IBAction)boostRealeased:(id)sender;
-(IBAction)whistlePressed:(id)sender;
-(IBAction)turnaroundPressed:(id)sender;
-(IBAction)turnaroundRealeased:(id)sender;
-(IBAction)stopPressed:(id)sender;
-(IBAction)stopRealeased:(id)sender;
-(IBAction)rightturnPressed:(id)sender;
-(IBAction)rightturnRealeased:(id)sender;
-(IBAction)leftturnPressed:(id)sender;
-(IBAction)leftturnRealeased:(id)sender;

-(IBAction) getPhoto:(id) sender;


@end

