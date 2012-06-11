//
//  ViewController.h
//  Calibration
//
//  Created by Skylar Castator on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RobotKit/RobotKit.h>
#import <RobotUIKit/RobotUIKit.h>
#import "SMRotaryProtocol.h"
#import "CircularUIView.h"

@interface ViewController : UIViewController<SMRotaryProtocol, RUIColorPickerDelegate>  {
    BOOL ledON;
    
    BOOL robotOnline;
    BOOL calibrateON;
    BOOL robotInitialized;
    
    RUICalibrateGestureHandler *calibrateHandler;
    
    //Views that make up the drive joystick
    IBOutlet UIView *driveWheel;
    IBOutlet UIImageView *drivePuck;
    IBOutlet CircularUIView *circularView;

    
    id<RKRobotControlProtocol> robotControl;
    
    IBOutlet UIButton*     calibrateButton;
    BOOL ballMoving;

}

//Joystick drive related methods
-(float)clampWithValue:(float)value min:(float)min max:(float)max;
-(void)updateMotionIndicator:(RKDriveAlgorithm*)driveAlgorithm;
-(void)handleJoystickMotion:(id)sender;

-(void)setupRobotConnection;
-(void)handleRobotOnline;
-(void)toggleLED;

@property (nonatomic, assign) UIButton *calibrateButton;
//@property (nonatomic, assign) CircularUIView *circularView;

/*! The robot control that is used to communicate with the robot. */
@property (nonatomic, assign) id<RKRobotControlProtocol>    robotControl;

-(IBAction)calibrationtouch :(id)sender;

@end

