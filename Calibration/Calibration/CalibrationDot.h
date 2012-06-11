//
//  CalibrationDot.h
//  Calibration
//
//  Created by Skylar Castator on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRotaryProtocol.h"

@interface CalibrationDot :UIControl{
    UIImageView*  controlKnobView;
	UIImageView*  wheelView;
    BOOL macroplay;
    
    
    UIImageView* im, *rev, *rev2, *bg;
    
    NSObject* macroplayer;
    
    UIButton* turnoffButton;
    UIButton* tapbutton;
    float transformangle;
    float calibrationAngle;
    float angle;
    float spheroHeadingZero;
    
}

@property (retain) id <SMRotaryProtocol> delegate;

@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *cloves;
@property int currentValue;



- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber;

@end
