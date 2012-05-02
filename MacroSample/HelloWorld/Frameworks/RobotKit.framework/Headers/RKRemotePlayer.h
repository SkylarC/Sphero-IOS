//
//  RKRemotePlayer.h
//  RobotKit
//
//  Created by Jon Carroll on 8/8/11.
//  Copyright 2011 Orbotix Inc. All rights reserved.
//
//  Description: Represents a remote player in a multiplayer game

#import <Foundation/Foundation.h>
#if defined (SRCLIBRARY)
#import <RobotKit/Multiplayer/RKRemoteRobot.h>
#else
#import <RobotKit/RKRemoteRobot.h>
#endif

@class RKMultiplayerNetworkWIFI;

/*!
 *  @brief RKRemotePlayer represents a remote player in a multiplayer game
 *
 *  RKRemotePlayer represents a remote player in a multiplayer game.
 *  The class stores meta data about the player along with a robot property
 *  that will allow you to remotely control their robot if one is connected.
 *
 *  See Also:
 *  @sa RKMultiplayer
 *  @sa RKRemoteRobot
 *  @sa RKMultiplayerGame
 */

@interface RKRemotePlayer : NSObject {
    RKMultiplayerNetworkWIFI    *connection;
    NSString                    *name;
    RKRemoteRobot               *robot;
    NSString                    *UID;
    int                         sortOrder;
}

@property (nonatomic, retain) RKMultiplayerNetworkWIFI  *connection;

/*! Human readable name to display for the player.
 */
@property (nonatomic, retain) NSString                  *name;

/*! RKRemoteRobot instance representing the remote player's robot allowing remote control.
 *  If the remote player has no robot this will be nil.
 */
@property (nonatomic, retain) RKRemoteRobot             *robot;

/*! A globally unique identifier string representing the player.  Can be used
 *  to associate messages with a remote player.
 */
@property (nonatomic, retain) NSString                  *UID;

/*! The sort order of this player in the player list.  Used in games where player order
 *  matters.
 */
@property int                                           sortOrder;

/*! Returns the players position in the remotePlayers array regardless of sort order
 */
-(int)getPosition;

/*! Convenience method for sorting the remotePlayers array
 */
+(void)sortPlayers;

/*! Convenience method for getting the player assoicated with a particular unique identifier
 */
+(RKRemotePlayer*)getPlayerWithUID:(NSString*)uid;

@end
