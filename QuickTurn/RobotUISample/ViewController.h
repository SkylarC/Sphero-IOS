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

@interface ViewController : UIViewController <RUIColorPickerDelegate, 
    RKMultiplayerDelegateProtocol> {
    BOOL robotOnline;
    RKRemotePlayer      *remotePlayer;//RKMultiplayer class representing the remote player and their robot
    RUICalibrateGestureHandler *calibrateHandler;
    
    
    //NSString *passedValue; //String transfers from ViewController
    
    //UILabel *aimInfoLabel;
    //UILabel *shootInfoLabel;
    //UILabel *busyLabel;
    ///UILabel *connectionLabel;
}

//@property (nonatomic, retain) NSString *passedValue;
@property (nonatomic, retain) IBOutlet UILabel *connectionLabel;

-(void)setupRobotConnection;
-(void)handleRobotOnline;

//-(float)clampWithValue:(float)value min:(float)min max:(float)max;

//UI Interaction
-(IBAction)sleepPressed:(id)sender;

-(IBAction)infoPressed:(id)sender;

-(IBAction)switchBack:(id)sender;

-(IBAction)stopPressed:(id)sender;
-(IBAction)stopRealeased:(id)sender;

-(IBAction)turnPressed:(id)sender;
-(IBAction)turnRealeased:(id)sender;

/*
 -(void)controlLoop;
 //Called when the available list of multiplayer games has updated
 //array contains RKMultiplayerGame objects representing available games
 -(void)multiplayerDidUpdateAvailableGames:(NSArray*)games;
 
 //Sent to all clients in a game when another joins for updating UI
 -(void)multiplayerPlayerDidJoinGame:(RKRemotePlayer*)player;
 
 //Sent to all clients in a game when another player leaves for updating UI
 -(void)multiplayerPlayerDidLeaveGame:(RKRemotePlayer*)player;
 
 //Sent on game state change for updating UI
 -(void)multiplayerGameStateDidChangeToState:(RKMultiplayerGameState)newState;
 
 //Called when game data is recieved from another player
 -(void)multiplayerDidRecieveGameData:(NSDictionary*)data;
*/


@end

