//
//  RobotKit.h
//  RobotKit
//
//  Copyright 2010 Orbotix Inc. All rights reserved.
//

#import <RobotKit/RKMath.h>
#import <RobotKit/RKAccelerometerFilter.h>

#import <RobotKit/RKDriveControl.h>
#import <RobotKit/RKDeviceConnection.h>
#import <RobotKit/RKRobot.h>
#import <RobotKit/RKRobotControl.h>
#import <RobotKit/RKRobotProvider.h>
#import <RobotKit/RKJoyStickDriveAlgorithm.h>
#import <RobotKit/RKTiltDriveAlgorithm.h>

#import <RobotKit/RKResponseCodes.h>
#import <RobotKit/RKDeviceMessenger.h>

// Commands
#import <RobotKit/RKPingCommand.h>
#import <RobotKit/RKVersioningCommand.h>
#import <RobotKit/RKCalibrateCommand.h>
#import <RobotKit/RKRGBLEDOutputCommand.h>
#import <RobotKit/RKBackLEDOutputCommand.h>
#import <RobotKit/RKRollCommand.h>
#import <RobotKit/RKRotationRateCommand.h>
#import <RobotKit/RKJumpToBootloaderCommand.h>
#import <RobotKit/RKJumpToMainAppCommand.h>
#import <RobotKit/RKSetDataStreamingCommand.h>
#import <RobotKit/RKStabilizationCommand.h>
#import <RobotKit/RKRawMotorValuesCommand.h>
#import <RobotKit/RKGoToSleepCommand.h>
#import <RobotKit/RKConfigureCollisionDetectionCommand.h>
#import <RobotKit/RKInitMacroExecutiveCommand.h>
#import <RobotKit/RKSaveTemporaryMacroChunkCommand.h>

// Responses
#import <RobotKit/RKPingResponse.h>
#import <RobotKit/RKVersioningResponse.h>
#import <RobotKit/RKCalibrateResponse.h>
#import <RobotKit/RKRGBLEDOutputResponse.h>
#import <RobotKit/RKBackLEDOutputResponse.h>
#import <RobotKit/RKRollResponse.h>
#import <RobotKit/RKRotationRateResponse.h>
#import <RobotKit/RKJumpToBootloaderResponse.h>
#import <RobotKit/RKJumpToMainAppResponse.h>
#import <RobotKit/RKSetDataStreamingResponse.h>
#import <RobotKit/RKStabilizationResponse.h>
#import <RobotKit/RKRawMotorValuesResponse.h>
#import <RobotKit/RKGoToSleepResponse.h>
#import <RobotKit/RKConfigureCollisionDetectionResponse.h>
#import <RobotKit/RKInitMacroExecutiveResponse.h>
#import <RobotKit/RKSaveTemporaryMacroChunkResponse.h>

#import <RobotKit/RKDeviceAsyncData.h>
#import <RobotKit/RKDeviceSensorsAsyncData.h>
#import <RobotKit/RKDeviceSensorsData.h>
#import <RobotKit/RKAccelerometerData.h>
#import <RobotKit/RKMagnetometerData.h>
#import <RobotKit/RKAttitudeData.h>
#import <RobotKit/RKGyroData.h>
#import <RobotKit/RKBackEMFData.h>
#import <RobotKit/RKCollisionDetectedAsyncData.h>

#import <RobotKit/RKAchievement.h>
#import <RobotKit/RKSpheroWorldAuth.h>


// Multiplayer
#if defined (SRCLIBRARY)
#import <RobotKit/Multiplayer/RKMultiplayer.h>
#import <RobotKit/Multiplayer/RKRemotePlayer.h>
#import <RobotKit/Multiplayer/RKRemoteRobot.h>
#import <RobotKit/Multiplayer/RKRemoteSphero.h>
#import <RobotKit/Multiplayer/RKMultiplayerGame.h>
#else
#import <RobotKit/RKMultiplayer.h>
#import <RobotKit/RKRemotePlayer.h>
#import <RobotKit/RKRemoteRobot.h>
#import <RobotKit/RKRemoteSphero.h>
#import <RobotKit/RKMultiplayerGame.h>
#endif
/*
//Macros
#import <RobotKit/RKMCRGB.h>
#import <RobotKit/RKMCRawMotor.h>
#import <RobotKit/RKMCRoll.h>
#import <RobotKit/RKMCLoopFor.h>
#import <RobotKit/RKMCLoopEnd.h>
#import <RobotKit/RKMCFrontLED.h>
#import <RobotKit/RKMCRGBSD2.h>
#import <RobotKit/RKMCRollSD1.h>
#import <RobotKit/RKMCRollSD1SPD1.h>
#import <RobotKit/RKMCRollSD1SPD2.h>
#import <RobotKit/RKMCRotateOverTime.h>
#import <RobotKit/RKMCRotateOverTimeSD1.h>
#import <RobotKit/RKMCRotateOverTimeSD2.h>
#import <RobotKit/RKMCSD1.h>
#import <RobotKit/RKMCSD2.h>
#import <RobotKit/RKMCSleep.h>
#import <RobotKit/RKMCSlew.h>
#import <RobotKit/RKMCSPD1.h>
#import <RobotKit/RKMCSD2.h>
#import <RobotKit/RKMCStabilization.h>
#import <RobotKit/RKMCStreamEnd.h>
#import <RobotKit/RKMCWaitUntilStop.h>
#import <RobotKit/RKMCCalibrate.h>
#import <RobotKit/RKMCDelay.h>
#import <RobotKit/RKMCEmit.h>
#import <RobotKit/RKMCGoTo.h>
#import <RobotKit/RKMCGoSub.h>
#import <RobotKit/RKMCRotationRate.h>

*/



