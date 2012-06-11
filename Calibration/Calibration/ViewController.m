//
//  ViewController.m
//  Calibration
//
//  Created by Skylar Castator on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "calibrateview.h"
#import "RobotKit/RobotKit.h"
#import "SMRotaryWheel.h"
#import "CalibrationDot.h"
#import "RobotUIKit/RobotUIKit.h"
#import <QuartzCore/QuartzCore.h>

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define HELP_VIEW_TAG 101


@implementation ViewController

@synthesize calibrateButton;
@synthesize robotControl;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)calibrationtouchview :(id)sender {
    calibrateview *wheel= [[calibrateview alloc] initWithFrame:CGRectMake(0, 0, 480, 320)  
                                                   andDelegate:self 
                                                  withSections:1];
    wheel.center = CGPointMake(240, 160);
    wheel.tag = HELP_VIEW_TAG;
    [self.view addSubview:wheel];
    
    
}



-(IBAction)calibrationtouch :(id)sender {
    calibrateON = YES;
    [self addcalibrateView];
    

}

-(IBAction)calibrationtouchup :(id)sender {
    calibrateON = NO;
    [self addcalibrateView];
   

}

-(void) addcalibrateView {
    
    
    if (calibrateON == YES) {
      
        
        SMRotaryWheel *wheel= [[SMRotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)  
                                                        andDelegate:self 
                                                       withSections:1];
        wheel.center = CGPointMake(355, 160);
        wheel.tag = HELP_VIEW_TAG;
        [self.view addSubview:wheel];
        
        
                 
    } 
    
    if (calibrateON ==NO){
       
        UIView *wheel = [self.view viewWithTag:HELP_VIEW_TAG];
        [wheel removeFromSuperview];
       
    }
    

    //return calibrateON;
    
    
}



/*-(IBAction)calibrationtouch2 :(id)sender {
    calibrateON = YES;
    calibrateButton.hidden = YES;
  //  [self addcalibrateView2];
    
    
}

-(IBAction)calibrationtouchup2 :(id)sender {
    calibrateON = NO;
     
   // [self addcalibrateView2];
    
    
}

-(void) addcalibrateView2 {
    */
    
   /* if (calibrateON == YES) {
        // calibrateON = NO;
        
        SMRotaryWheel *wheel2= [[SMRotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)  
                                                        andDelegate:self 
                                                       withSections:1];
        wheel2.center = CGPointMake(120, 160);
        wheel2.tag = HELP_VIEW_TAG;
        [self.view addSubview:wheel2];
        
        
        
    } */
    
 /*   if (calibrateON ==NO){
        // calibrateON = YES;
        calibrateButton.hidden = NO;
        UIView *wheel2 = [self.view viewWithTag:HELP_VIEW_TAG];
        [wheel2 removeFromSuperview];
        
    }
    
    */
    //return calibrateON;
    
    
//}





-(void)viewDidLoad {
    [super viewDidLoad];
    
    /*Register for application lifecycle notifications so we known when to connect and disconnect from the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    calibrateButton.hidden = NO;
    /*Only start the blinking loop when the view loads*/
    robotOnline = NO;

    calibrateHandler = [[RUICalibrateGestureHandler alloc] initWithView:self.view];
    
    
    
    CalibrationDot *wheel = [[CalibrationDot alloc] initWithFrame:CGRectMake(0, 0, 200, 200)  
                                                    andDelegate:self 
                                                   withSections:8];

    wheel.center = CGPointMake(120, 160);
    [self.view addSubview:wheel];

    
    

    
    calibrateON= NO;
    

}


- (void) wheelDidChangeValue:(NSString *)newValue {
    
 //   self.valueLabel.text = newValue;
    
}


- (void)calibrationViewHeadingDidChange:(SMRotaryWheel*)view
							  toHeading:(float)angle {
	[self.robotControl rotateToHeading:angle];
    
    NSLog(@"angle%.f", angle);
    
    [RKBackLEDOutputCommand sendCommandWithBrightness:1.0];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
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

-(void)handleDidGainControl:(NSNotification*)notification {\
    NSLog(@"didGainControlNotification");
    if(!robotInitialized) return;
    [[RKRobotProvider sharedRobotProvider] openRobotConnection];
}


- (void)handleRobotOnline {
   
    
    [[RKRobotProvider sharedRobotProvider] openRobotConnection];
    
    /*The robot is now online, we can begin sending commands*/
    if(!robotOnline) {
        /*Only start the blinking loop once*/
       // [self toggleLED];
    }
    robotOnline = YES;
    
    //Setup joystick driving
    [RKDriveControl sharedDriveControl].joyStickSize = circularView.bounds.size;
    [RKDriveControl sharedDriveControl].driveTarget = self;
    [RKDriveControl sharedDriveControl].driveConversionAction = @selector(updateMotionIndicator:);
    [[RKDriveControl sharedDriveControl] startDriving:RKDriveControlJoyStick];
    //Set max speed
    [RKDriveControl sharedDriveControl].velocityScale = 0.6;
    
    // start processing the puck's movements
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleJoystickMotion:)];
    [drivePuck addGestureRecognizer:panGesture];
    [panGesture release];
    
}

- (void)handleRobotOffline {
    if(robotOnline) {
        robotOnline = NO;

    }
}



#pragma mark -
#pragma mark Joystick related methods

- (void)handleJoystickMotion:(id)sender
{
    //Don't handle the gesture if we aren't connected to and driving a robot
    if (![RKDriveControl sharedDriveControl].driving) return;
    
    //Handle the pan gesture and pass the results into the drive control
    UIPanGestureRecognizer *pan_recognizer = (UIPanGestureRecognizer *)sender;
    CGRect parent_bounds = circularView.bounds;
    CGPoint parent_center = [circularView convertPoint:circularView.center fromView:circularView.superview] ;
    
    if (pan_recognizer.state == UIGestureRecognizerStateEnded || pan_recognizer.state == UIGestureRecognizerStateCancelled || pan_recognizer.state == UIGestureRecognizerStateFailed || pan_recognizer.state == UIGestureRecognizerStateBegan) {
        ballMoving = NO;
        [[RKDriveControl sharedDriveControl].robotControl stopMoving];
        drivePuck.center = parent_center;
    } else if (pan_recognizer.state == UIGestureRecognizerStateChanged) {
        ballMoving = YES;
        CGPoint translate = [pan_recognizer translationInView:circularView];
        CGPoint drag_point = parent_center;
        drag_point.x += translate.x;
        drag_point.y += translate.y;
        drag_point.x = [self clampWithValue:drag_point.x min:CGRectGetMinX(parent_bounds) max:CGRectGetMaxX(parent_bounds)];
        drag_point.y = [self clampWithValue:drag_point.y min:CGRectGetMinY(parent_bounds) max:CGRectGetMaxY(parent_bounds)];
        [[RKDriveControl sharedDriveControl] driveWithJoyStickPosition:drag_point];        
    }
}

- (void)updateMotionIndicator:(RKDriveAlgorithm*)driveAlgorithm {
    //Don't update the puck position if we aren't driving
    if ( ![RKDriveControl sharedDriveControl].driving || !ballMoving) return;
    
    //Update the joystick puck position based on the data from the drive algorithm
    CGRect bounds = circularView.bounds;
    
    double velocity = driveAlgorithm.velocity/driveAlgorithm.velocityScale;
	double angle = driveAlgorithm.angle + (driveAlgorithm.correctionAngle * 180.0/M_PI);
	if (angle > 360.0) {
		angle -= 360.0;
	}
    double x = ((CGRectGetMaxX(bounds) - CGRectGetMinX(bounds))/2.0) *
    (1.0 + velocity * sin(angle * M_PI/180.0));
    double y = ((CGRectGetMaxY(bounds) - CGRectGetMinY(bounds))/2.0) *
    (1.0 - velocity * cos(angle * M_PI/180.0));
	
    CGPoint center = CGPointMake(floor(x), floor(y));
    
    [UIView setAnimationsEnabled:NO];
    drivePuck.center = center;   
    [UIView setAnimationsEnabled:YES];
}

- (float)clampWithValue:(float)value min:(float)min max:(float)max {
    //A standard clamp function
    if (value < min) {
        return min;
    } else if (value > max) {
        return max;
    } else {
        return value;
    }
}










- (void)toggleLED {
    /*Toggle the LED on and off*/
    if (ledON) {
        ledON = NO;
        [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:0.0];
    } else {
        ledON = YES;
        [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:1.0];
    }
    [self performSelector:@selector(toggleLED) withObject:nil afterDelay:0.5];
}

-(void)setupRobotConnection {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidGainControl:) name:RKRobotDidGainControlNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOffline) name:RKDeviceConnectionOfflineNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOffline) name:RKRobotDidLossControlNotification object:nil];
    
    //Attempt to control the connected robot so we get the notification if one is connected
    
    robotInitialized = NO;
    
    
    if ([[RKRobotProvider sharedRobotProvider] isRobotUnderControl]) {
        robotInitialized = YES;
        
        
        
        [[RKRobotProvider sharedRobotProvider] openRobotConnection];        
    }
    else {
        robotOnline = NO;
        
        
    }
    
    robotInitialized = YES;
}

@end
