//
//  SplashController.h
//  QuickTurnSphero
//
//  Created by Skylar Castator on 5/7/12.
//  Copyright (c) 2012 Orbotix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <RobotUIKit/RobotUIKit.h>
#import <RobotKit/RobotKit.h>

//@class ViewController;

@interface SplashController : UIViewController{
    //ViewController *ViewControllerData;
    BOOL robotOnline;
    BOOL robotInitialized;
   // RUICalibrateGestureHandler *calibrateHandler;
    
   // UILabel *connectingLabel;
    
}
//@property (nonatomic, retain) ViewController *ViewControllerData; 




-(void)setupRobotConnection;
-(void)handleRobotOnline;

-(IBAction)sleepPressed:(id)sender;
//-(IBAction)passData:(id)sender;


@end
