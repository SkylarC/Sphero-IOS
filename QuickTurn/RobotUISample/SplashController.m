//
//  SplashController.m
//  QuickTurnSphero
//
//  Created by Skylar Castator on 5/7/12.
//  Copyright (c) 2012 Orbotix, Inc. All rights reserved.
//

#import "SplashController.h"
//#import "ViewController.h"

#import "RobotKit/RobotKit.h"

#import "RobotUIKit/RobotUIKit.h"

@implementation SplashController
//@synthesize ViewControllerData;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

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
    
    //Setup a calibration gesture handler on our view to handle rotation gestures and give visual feeback to the user.
  //  calibrateHandler = [[RUICalibrateGestureHandler alloc] initWithView:self.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //[calibrateHandler release]; calibrateHandler = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
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
    robotOnline = YES;
}

-(void)setupRobotConnection {
    /*Try to connect to the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    if ([[RKRobotProvider sharedRobotProvider] isRobotUnderControl]) {
        [[RKRobotProvider sharedRobotProvider] openRobotConnection];        
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
-(IBAction)sleepPressed:(id)sender {
    //RobotUIKit resources like images and nib files stored in an external bundle and the path must be specified
    NSString* rootpath = [[NSBundle mainBundle] bundlePath];
    NSString* ruirespath = [NSBundle pathForResource:@"RobotUIKit" ofType:@"bundle" inDirectory:rootpath];
    NSBundle* ruiBundle = [NSBundle bundleWithPath:ruirespath];
    
    //Present the slide to sleep view controller
    RUISlideToSleepViewController *sleep = [[RUISlideToSleepViewController alloc] initWithNibName:@"RUISlideToSleepViewController" bundle:ruiBundle];
 //   sleep.view.frame = self.view.bounds;
   // [self presentModalLayerViewController:sleep animated:YES];
    [sleep release];
}
/////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
//Switch View Button
///////////////////////////////////////////////////////
/*-(void) passData : (id) sender{

    
    ViewController *Change = [[ViewController alloc] initWithNibName:nil bundle:nil];
    self.ViewControllerData = Change;
   // ViewControllerData.passedValue = connectingLabel.text;
    
    [self presentModalViewController:Change animated: YES];

    
}

*/
/////////////////////////////////////////////////////////////////////////////////////


@end
