//
//  calibrateview.h
//  Calibration
//
//  Created by Skylar Castator on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SMRotaryProtocol.h"

@interface calibrateview : UIControl{
    UIImageView*  controlKnobView;
	UIImageView*  wheelView;
    UIButton* turnoffButton;
    
    float calibrationAngle;
}

@property (retain) id <SMRotaryProtocol> delegate;


@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *cloves;
@property int currentValue;


- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber;


@end
