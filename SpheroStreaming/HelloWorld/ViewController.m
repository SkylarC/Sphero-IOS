//
//  ViewController.m
//  HelloWorld
//
//  Created by Jon Carroll on 12/8/11.
//  Copyright (c) 2011 Orbotix, Inc. All rights reserved.
//

#import "ViewController.h"

#import "RobotKit/RobotKit.h"

@implementation ViewController
@synthesize randomMain, /*enemy, player,*/ sphero, /*startbutton,*/ targetSpheroLoc;

////////////////////////////////////////////////////


//////////////////////////
//View Handelers
//////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //SpaceFighter
    targetSpheroLoc = sphero.center;
    
    /*Register for application lifecycle notifications so we known when to connect and disconnect from the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    /*Only start the blinking loop when the view loads*/
    robotOnline = NO;
}


//////////////
- (void)viewDidUnload
{
    [self disableSpheroStreaming];
    [RKStabilizationCommand sendCommandWithState:RKStabilizationStateOff];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [RKBackLEDOutputCommand sendCommandWithBrightness:1.0];
    [RKStabilizationCommand sendCommandWithState:RKStabilizationStateOff];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //   [glView startAnimation];
    
    [self animateSphero];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self disableSpheroStreaming];
    [RKStabilizationCommand sendCommandWithState:RKStabilizationStateOff];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    //    [glView stopAnimation];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
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




//////////////////
//Sphero
//
//
/////////////////

//Set up Sphero for Gameplay

- (void)handleRobotOnline {
    /*The robot is now online, we can begin sending commands*/
    //Give Command  here to Turn off stability and turn on Sphero Streaming
    //
    //
    if(!robotOnline) {
        
        [RKRGBLEDOutputCommand sendCommandWithRed:0.5 green:0.5 blue:0.5];
        [RKBackLEDOutputCommand sendCommandWithBrightness:1.0];
        [RKStabilizationCommand sendCommandWithState:RKStabilizationStateOff];
        [self performSelector:@selector(enableSpheroStreaming) withObject:nil afterDelay:1.0]; 
    }
    robotOnline = YES;
}


-(void)setupRobotConnection {
    /*Try to connect to the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    if ([[RKRobotProvider sharedRobotProvider] isRobotUnderControl]) {
        [[RKRobotProvider sharedRobotProvider] openRobotConnection];        
    }
}



///////////////////////////////
//SpheroStreaming
///////////////////////////////

////////////////////////////////////////////////////////////////   
///////////Enable

-(void)enableSpheroStreaming {
    //SPHERO SENSOR STREAMING CODE
    
    
    NSLog(@"Turning on data streaming");
    [[RKDeviceMessenger sharedMessenger] addDataStreamingObserver:self selector:@selector(handleDataStreaming:)];
    [RKSetDataStreamingCommand sendCommandWithSampleRateDivisor:20 packetFrames:1 sensorMask:RKDataStreamingMaskAccelerometerXFiltered | RKDataStreamingMaskAccelerometerYFiltered | RKDataStreamingMaskAccelerometerZFiltered  packetCount:0];
    //END SPHERO SENSOR STREAMING CODE
}

////////////////////////////////////////////////////////////////////
/////////Disable

-(void)disableSpheroStreaming {
    //SPHERO SENSOR STREAMING CODE
    //Disable sensor data streaming from Sphero by removing ourself as the observer
    NSLog(@"Turning off data streaming");
    [[RKDeviceMessenger sharedMessenger] removeDataStreamingObserver:self];
    // Send command to stop the data streaming from Sphero
    [RKSetDataStreamingCommand sendCommandWithSampleRateDivisor:0 packetFrames:0 sensorMask:RKDataStreamingMaskOff packetCount:0];
    
}


//////////////////////////////////////////////////////////////////////
//SPHERO SENSOR STREAMING CODE
//Observer method that will be called as sensor data arrives from Sphero

- (void)handleDataStreaming:(RKDeviceAsyncData *)data
{
    //NSLog(@"handleDataStreaming: data - %@", data);
    
    if ([data isKindOfClass:[RKDeviceSensorsAsyncData class]]) {
        RKDeviceSensorsAsyncData *sensors_data = (RKDeviceSensorsAsyncData *)data;
        
        //NSLog(@"sensors_data.dataFrames - %@", sensors_data.dataFrames);
        
        for (RKDeviceSensorsData *data in sensors_data.dataFrames) {
            RKAccelerometerData *accelerometer_data = data.accelerometerData;
            
            
            NSLog(@"%1.2f, %1.2f, %1.2f", accelerometer_data.acceleration.x, accelerometer_data.acceleration.y, accelerometer_data.acceleration.z);
            
            ////////////////////////////////////////////////////////////////////     
            //Accelerometer Values Floats  
            ///////////////////////////////////////////////////////////////////     
            
            
            //Z Values but not needed.
            
            //float z = accelerometer_data.acceleration.z;
            //NSLog(@"z - %1.3f", z);
            ///////////////////////////////////////
            
            float y = accelerometer_data.acceleration.y + 1.0;
            if(y < 0.0) y = 0.0;
            if(y > 2.0) y = 2.0;
            y = y * 0.5;
            ///////////////////////////////////////
            
            float x = accelerometer_data.acceleration.x;
            y = accelerometer_data.acceleration.y * -1.0;
            float xOffset = x * 20.0;
            float yOffset = y * 20.0;
            ///////////////////////////////////////////
            
            CGPoint newCenter = CGPointMake(sphero.center.x + xOffset, sphero.center.y + yOffset);
            
            //PlaceSphero Back in center
            //Creates a boundry around the frame of the Phone so you can't lose him.
            
            if(newCenter.x < 0.0) newCenter.x = 0.0;
            if(newCenter.x > self.view.frame.size.height) newCenter.x = self.view.frame.size.height;
            if(newCenter.y < 0.0) newCenter.y = 0.0;
            if(newCenter.y > self.view.frame.size.width - 20.0) newCenter.y = self.view.frame.size.width - 20.0;
            
            targetSpheroLoc = newCenter;
            
            
        }}}


//////////////////////////////////////////////////////////////////
//Animate Sphero
/////////////////////////////////////////////////////////////////////
//Make Linear movements for Sphero's Image View

-(void)animateSphero {
    [UIView animateWithDuration:0.06 
                          delay:0.0
                        options:UIViewAnimationCurveLinear 
                     animations:^{
                         sphero.center = targetSpheroLoc;
                     }
                     completion:^(BOOL finished) {
                         [self animateSphero];
                     }];
}
////////////////////////////////////////////////////////////////// 

-(void) dealloc {
    [super dealloc];
}




@end
