//
//  ViewController.m
//  RobotUISample
//
//  Created by Jon Carroll on 12/9/11.
//  Copyright (c) 2011 Orbotix, Inc. All rights reserved.
//

#import "ViewController.h"

#import "RobotKit/RobotKit.h"

#import "RobotUIKit/RobotUIKit.h"

//static NSString * const TwoPhonesGameType = @"twophones";

@implementation ViewController

//@synthesize passedValue;
@synthesize connectionLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
   //  connectionLabel.text = passedValue;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    /*Register for application lifecycle notifications so we known when to connect and disconnect from the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];

    /*Only start the blinking loop when the view loads*/
    robotOnline = NO;

    //Setup a calibration gesture handler on our view to handle rotation gestures and give visual feeback to the user.
    calibrateHandler = [[RUICalibrateGestureHandler alloc] initWithView:self.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [calibrateHandler release]; calibrateHandler = nil;
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


/*
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
 
 #pragma mark -
 #pragma mark UI Interaction
 
 -(IBAction)colorPressed:(id)sender {
 //RobotUIKit resources like images and nib files stored in an external bundle and the path must be specified
 NSString* rootpath = [[NSBundle mainBundle] bundlePath];
 NSString* ruirespath = [NSBundle pathForResource:@"RobotUIKit" ofType:@"bundle" inDirectory:rootpath];
 NSBundle* ruiBundle = [NSBundle bundleWithPath:ruirespath];
 
 //Present the color picker and set the starting color to white
 RUIColorPickerViewController *colorPicker = [[RUIColorPickerViewController alloc] initWithNibName:@"RUIColorPickerViewController" bundle:ruiBundle];
 [colorPicker setCurrentRed:1.0 green:1.0 blue:1.0];
 colorPicker.delegate = self;
 [self presentModalLayerViewController:colorPicker animated:YES];
 [colorPicker release];
 }
 
 //Color picker delegate callbacks
 -(void) colorPickerDidChange:(UIViewController*)controller withRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b {
 //Send the color to Sphero when the user picks a new color in the picker
 [RKRGBLEDOutputCommand sendCommandWithRed:r green:g blue:b];
 }
 
 
 -(void) colorPickerDidFinish:(UIViewController*)controller withRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b {
 //Use this callback to dismiss the color picker, since we are presenting it as a modalLayerViewController it will dismiss itself
 }

 */

-(IBAction)rightturnPressed:(id)sender{
    [RKAbortMacroCommand sendCommand];
    [RKStabilizationCommand sendCommandWithState:(RKStabilizationStateOn)];

    
    [RKStabilizationCommand sendCommandWithState:(RKStabilizationStateOff)];   //Raw motors need Stabilization turned off
    
    [RKRawMotorValuesCommand sendCommandWithLeftMode:1.0 leftPower:255 rightMode:2.0 rightPower:255];  //Raw motor Command
    
    [RKRGBLEDOutputCommand sendCommandWithRed:1.0 green:0.0 blue:0.0];     //Change LED Colour: Red
    
    [RKBackLEDOutputCommand sendCommandWithBrightness:1.0];    //Turn on Back LED
    
}

-(IBAction)rightturnRealeased:(id)sender{
    
    [RKStabilizationCommand sendCommandWithState:(RKStabilizationStateOn)];    //Turn stabilization back on stopping the raw motors
    
    [RKRollCommand sendCommandWithHeading:0.0 velocity:0.0];       // Come to a stop  
    
    [RKRGBLEDOutputCommand sendCommandWithRed:.0 green:0.0 blue:1.0];    //Change LED Colour: Blue
    
    [RKBackLEDOutputCommand sendCommandWithBrightness:0.0];    //Turn off Back LED
    
}


//////////////////////////////////////////////Flip 180////////////////////////////////////


-(IBAction)turnPressed:(id)sender{
    [RKAbortMacroCommand sendCommand];
    [RKStabilizationCommand sendCommandWithState:(RKStabilizationStateOn)];

    
    [RKRollCommand sendCommandWithHeading:0 velocity:0.6];
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:1.0 blue:0.0];    //Change LED Colour: Red
}

-(IBAction)turnRealeased:(id)sender{
    
    [RKRollCommand sendCommandWithHeading:0 velocity:0.0];
    [RKRGBLEDOutputCommand sendCommandWithRed:1.0 green:1.0 blue:1.0];  //Change LED Colour: Green
    
    
    RKMacroObject *macro = [RKMacroObject new];
    

                   
    [macro addCommand:[RKMCRoll commandWithSpeed:0 heading:0 delay:1000]];
    //[macro addCommand:[RKMCRotateOverTime commandWithRotation:1.0 delay:1000]];
    [macro addCommand:[RKMCCalibrate commandWithHeading:180 delay:0]];
    [macro addCommand:[RKMCRGB commandWithRed:0 green:0 blue:1.0 delay:1000]];
    [macro addCommand:[RKMCCalibrate commandWithHeading:0 delay:0]];
    [macro addCommand:[RKMCRGB commandWithRed:1.0 green:1.0 blue:1.0 delay:1000]];
    [macro addCommand:[RKMCRoll commandWithSpeed:0 heading:0 delay:1000]];
    [macro playMacro];

}


///////////////////////////////////////////Stop and Recalibrate Pressed////////////////////////////////



-(IBAction)stopPressed:(id)sender{
    [RKAbortMacroCommand sendCommand];
    [RKStabilizationCommand sendCommandWithState:(RKStabilizationStateOn)];

    
    [RKStabilizationCommand sendCommandWithState:(RKStabilizationStateOff)];   //turn off driving and make sphero not roll at all
    
    [RKRGBLEDOutputCommand sendCommandWithRed:1.0 green:0.0 blue:0.0];    //Change LED Colour: Red
    
    [RKBackLEDOutputCommand sendCommandWithBrightness:1.0];
    
}



-(IBAction)stopRealeased:(id)sender{
    
    [RKStabilizationCommand sendCommandWithState:(RKStabilizationStateOn)];    //Turn stabilization back on to drive
    
    [RKCalibrateCommand sendCommandWithHeading:0];
    
    [RKRGBLEDOutputCommand sendCommandWithRed:.0 green:1.0 blue:0.0];  //Change LED Colour: Green
    
    [RKBackLEDOutputCommand sendCommandWithBrightness:0];
    
}
//////////////////////////////////////////////////////////////////////////////////////////
-(IBAction)sleepPressed:(id)sender {
    //RobotUIKit resources like images and nib files stored in an external bundle and the path must be specified
    NSString* rootpath = [[NSBundle mainBundle] bundlePath];
    NSString* ruirespath = [NSBundle pathForResource:@"RobotUIKit" ofType:@"bundle" inDirectory:rootpath];
    NSBundle* ruiBundle = [NSBundle bundleWithPath:ruirespath];
    
    //Present the slide to sleep view controller
    RUISlideToSleepViewController *sleep = [[RUISlideToSleepViewController alloc] initWithNibName:@"RUISlideToSleepViewController" bundle:ruiBundle];
    sleep.view.frame = self.view.bounds;
    [self presentModalLayerViewController:sleep animated:YES];
    [sleep release];
}

//////////////////////////////////////////////////////////////////////////////////
//Pass Controller
/////////////////////////////////////////////////////////////////////////////////

//#pragma mark -
//#pragma mark Pass Button Pressed

//- (IBAction)passPressed
//{
/*
    //Send the message to our opponent indicating we are passing control of the robot to them
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"ur turn" forKey:@"PASS"];
    [[RKMultiplayer sharedMultiplayer] sendDataToAll:dict];
    [dict release];
    
    //Hide the robot controls and present the color picker since we don't have control
    NSString* rootpath = [[NSBundle mainBundle] bundlePath];
    NSString* ruirespath = [NSBundle pathForResource:@"RobotUIKit" ofType:@"bundle" inDirectory:rootpath];
    RUIColorPickerViewController *cpc = [[RUIColorPickerViewController alloc] initWithNibName:@"RUIColorPickerViewController" bundle:[NSBundle bundleWithPath:ruirespath]];
    cpc.delegate = self;
    cpc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [cpc setRed:1.0 green:1.0 blue:1.0];
    [self presentModalViewController:cpc animated:YES];
    [cpc release];*/
    
//}

/////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////
//Back button
//Switch back to Room Size View
////////////////////////////////////
//-(IBAction) switchBack : (id) sender{
   // [RKAbortMacroCommand sendCommand];
   // [RKStabilizationCommand sendCommandWithState:(RKStabilizationStateOn)];
    
    /////////////////    
    //Music    
    ////////////////
    
  //  NSString *path = [[NSBundle mainBundle] pathForResource:@"CARTOON-BOING-DULL" ofType:@"wav"];
   // if(sPlayer)[sPlayer release];
   // sPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
   // [sPlayer prepareToPlay];
    // sPlayer.delegate = self;
  //  [sPlayer play];
   // [self dismissModalViewControllerAnimated:YES];
    
    
//}
/*
-(IBAction)infoPressed:(id)sender{
   //Place animation here to change layers  
    
    //Connecting fades out
    aimInfoLabel.alpha  =1;
    [self fadeIn : aimInfoLabel withDuration: 1 andWait : 0 ];
    
    //Connecting fades out
    shootInfoLabel.alpha  =1;
    [self fadeIn : shootInfoLabel withDuration: 1 andWait : 0 ];
    
    //Connecting fades out
    aimInfoLabel.alpha  =1;
    [self fadeIn : aimInfoLabel withDuration: 1 andWait : 0 ];
    
    //Connected
   // connected.alpha  =1;
   // [self fadeOut : connected withDuration: 3 andWait : 2 ];
}*/
///////////////////////////////////////
/*

-(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration   andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade Out" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToDissolve.alpha = 0.0;
    [UIView commitAnimations];
}

-(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade In" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
    
}*/

/**
 Fade in from fade out
 *//*
-(void) fadeInFromFadeOut: (UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration
{
    viewToFadeIn.hidden=NO;
    [self fadeOut:viewToFadeIn withDuration:1 andWait:0];
    [self fadeIn:viewToFadeIn withDuration:duration andWait:0];
    
}
*/

 /*

//////////////////////////////////////////////////////////////////////////////////
//MultiPLayer Functions
//////////////////////////////////////////////////////////////////////////////////
 
 #pragma mark -
 #pragma mark RKMultiplayer Delegate Methods
 
 //This is the callback when multiplayer games for your app are found.  You might use this callback to display the available games in a tableview or autmatically join the first game found such as in this case
 -(void)multiplayerDidUpdateAvailableGames:(NSArray*)games {
 NSLog(@"did update available games");
 
 //If there is at least one available game to join
 if([games count] > 0) {
 RKMultiplayerGame *game = [[games objectAtIndex:0] retain];
 //We want to stop updating the list of available multiplayer games now that we found one
 [[RKMultiplayer sharedMultiplayer] stopGettingAvailableMultiplayerGames];
 
 //We want to join the advertised game we found
 [[RKMultiplayer sharedMultiplayer] joinAdvertisedGame:game];
 }
 }
 
 //Sent to all clients in a game when another joins for updating UI
 -(void)multiplayerPlayerDidJoinGame:(RKRemotePlayer*)player {
 //Save an ivar to the remote player
 remotePlayer = player;
 
 //If we are the host (device with robot connected) we need to start the game at this point
 if([[RKMultiplayer sharedMultiplayer] isHost]) {
 [[RKMultiplayer sharedMultiplayer] startGame];
 }
 }
 
 //Sent to all clients in a game when another player leaves for updating UI
 -(void)multiplayerPlayerDidLeaveGame:(RKRemotePlayer*)player {
 //We can igrnore this since we are listening for the multiplayerGameStateDidChangeToState callback
 }
 
 //Sent on game state change for updating UI
 -(void)multiplayerGameStateDidChangeToState:(RKMultiplayerGameState)newState {
 if(newState==RKMultiplayerGameStateStarted) {
 
//Hide the connection message and show the robot controls
 connectionLabel.hidden = YES;
 //passButton.hidden = NO;
 //If we aren't the host we want to go to the flipside view until control is passed to us
 if(![[RKMultiplayer sharedMultiplayer] isHost]) {
 //NSString* rootpath = [[NSBundle mainBundle] bundlePath];
 //NSString* ruirespath = [NSBundle pathForResource:@"RobotUIKit" ofType:@"bundle" inDirectory:rootpath];
 //RUIColorPickerViewController *cpc = [[RUIColorPickerViewController alloc] initWithNibName:@"RUIColorPickerViewController" bundle:[NSBundle bundleWithPath:ruirespath]];
 //cpc.delegate = self;
 //cpc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
 //[cpc setRed:1.0 green:1.0 blue:1.0];
 //[self presentModalViewController:cpc animated:YES];
 //[cpc release];
 }
 //Start the RCDrive control loop
 [self controlLoop];
 } else if(newState==RKMultiplayerGameStateEnded) {
 //If a the other user disconnects the game is over
 [[RKMultiplayer sharedMultiplayer] leaveCurrentGame];
 
 //Reset the UI
 connectionLabel.hidden = NO;
 //passButton.hidden = YES;
 
 //Dismiss the color picker if it is on screen
 if(self.modalViewController) {
 [self dismissModalViewControllerAnimated:NO];
 }
 
 //Look for other games or host a new one depending on if we had a ball
 if([[RKMultiplayer sharedMultiplayer] isHost]) {
 [[RKMultiplayer sharedMultiplayer] hostGameOfType:TwoPhonesGameType playerName:@"TwoPhonesOneBall"];
 } else {
 [[RKMultiplayer sharedMultiplayer] getAvailableMultiplayerGamesOfType:TwoPhonesGameType];
 }
 
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"The other player has disconnected, the game is over" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
 [alert show];
 [alert release];
 }
 }
 
 //Called when game data is recieved from another player
 -(void)multiplayerDidRecieveGameData:(NSDictionary*)data {
 //The responses recieved here have the payload we passed in wrapped in routing information about the sender and reciever
 //What we passed in is stored in a dictionary with the key payload, we will need to pull it out
 NSDictionary *payload = [data objectForKey:@"PAYLOAD"];
 if([[payload valueForKey:@"PASS"] isEqualToString:@"ur turn"]) {
 //The other player has sent us the message indicating control of the robot has been passed to us, dismiss the modal view
 [self dismissModalViewControllerAnimated:YES];
 }
 }
 */

@end
