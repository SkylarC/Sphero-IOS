![logo](http://update.orbotix.com/developer/sphero-small.png)

# Sphero Streaming

Sphero Streaming
Sphero Streaming


As shown in the video below, Sphero can be used as a remote control in different game environments. The Sphero uses its accelerometer data and indicates where the object on the screen needs to move.


 

This sample code demonstrates how to connect to a Sphero and use its streaming Accelerometer Data to move an object on the screen. 




viewController.h

Code:
@interface ViewController : UIViewController <UIAlertViewDelegate>{
    BOOL robotOnline;
    
    //Sphero Stuff
    
    CGPoint targetSpheroLoc; //Sphero's Center
    
    NSTimer *randomMain;
    
    IBOutlet UIImageView *sphero;  //Sphero
}

@property(nonatomic, retain)  UIImageView *sphero;


@property CGPoint targetSpheroLoc;

@property(nonatomic, retain)  NSTimer *randomMain;



-(void)enableSpheroStreaming;
-(void)disableSpheroStreaming;



-(void)setupRobotConnection;
-(void)handleRobotOnline;

-(void)animateSphero;


viewController.m


Code:

//////////////////////////
//View Handelers
//////////////////////////

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
Start robot connection

Code:
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

Create float values for Sphero 

Code:
///////////////////////////////
//SpheroStreaming
///////////////////////////////

////////////////////////////////////////////////////////////////   
///////////Enable

-(void)enableSpheroStreaming {
    //SPHERO SENSOR STREAMING CODE
    
    
    NSLog(@"Turning on data streaming");
    [[RKDeviceMessenger sharedMessenger] addDataStreamingObserver:self selector:@selector(handleDataStreaming:)];
    [RKSetDataStreamingCommand sendCommandWithSampleRateDivisor:20 packetFrames:1 sensorMask:RKDataStreamingMaskAccelerometerXFilter  ed | RKDataStreamingMaskAccelerometerYFiltered | RKDataStreamingMaskAccelerometerZFiltered  packetCount:0];
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
Animation

Code:

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

