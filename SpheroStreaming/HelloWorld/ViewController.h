//
//  ViewController.h
//  SpheroStreaming
//
//  Created by Skylar Castator April 12 2012
//  Copyright (c) 2011 Orbotix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


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

@end
