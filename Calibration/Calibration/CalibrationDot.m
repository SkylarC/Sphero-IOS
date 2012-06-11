//
//  CalibrationDot.m
//  Calibration
//
//  Created by Skylar Castator on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalibrationDot.h"
#import <QuartzCore/QuartzCore.h>
#import "SMCLove.h"
#import <RobotKit/RobotKit.h>

#define TAP_TAG 101
#define INNER_TAG 102
#define OUTTER_TAG 103
#define MIDDLE_TAG 104

@interface  CalibrationDot()

- (void)drawWheel;
- (float) calculateDistanceFromCenter:(CGPoint)point;
- (void) buildClovesEven;
- (void) buildClovesOdd;
- (UIImageView *) getCloveByValue:(int)value;
- (NSString *) getCloveName:(int)position;
@end

static float deltaAngle;
static float minAlphavalue = 0.6;
static float maxAlphavalue = 1.0;

@implementation CalibrationDot

@synthesize delegate, container, numberOfSections, startTransform, cloves, currentValue;


- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber {
    
    if ((self = [super initWithFrame:frame])) {
		
        self.currentValue = 0;
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
		[self drawWheel];
        
	}
    return self;
}



- (void) drawWheel {
    
    container = [[UIView alloc] initWithFrame:self.frame];
    container.tag = TAP_TAG;
    
    
    CGFloat angleSize = 360/ 2*M_PI;
    
    //bkg images 
    
   

    im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    im.image = [UIImage imageNamed:@"Glowing_Blue_Orb.png"];
    im.layer.anchorPoint = CGPointMake(2.0f, 0.5f);
    im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x, 
                                    container.bounds.size.height/2.0-container.frame.origin.y); 
    im.transform = CGAffineTransformMakeRotation(angleSize);
    im.alpha = minAlphavalue;
    
    [container addSubview:im];
    
    rev.hidden = YES;
    rev2.hidden = YES;
    turnoffButton.hidden = YES;
    bg.hidden = YES;
    
    container.userInteractionEnabled = NO;
    [self addSubview:container];
    
    //bkg images 
    rev = [[UIImageView alloc] initWithFrame:self.frame];
    rev.image = [UIImage imageNamed:@"IC.png"];
    rev.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x, 
                                    container.bounds.size.height/2.0-container.frame.origin.y); 
    rev.transform = CGAffineTransformMakeRotation(angleSize);
    rev.alpha = minAlphavalue;
    rev.tag = INNER_TAG;
    [container addSubview:rev];
    
    
    //bkg images 
    rev2 = [[UIImageView alloc] initWithFrame:self.frame];
    rev2.image = [UIImage imageNamed:@"OC.png"];
    rev2.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x, 
                                    container.bounds.size.height/2.0-container.frame.origin.y); 
    rev2.transform = CGAffineTransformMakeRotation(angleSize);
    rev2.alpha = minAlphavalue;
    rev2.tag = OUTTER_TAG;
    [container addSubview:rev2];
    
    
    
    //Sets up Background
    
    bg = [[UIImageView alloc] initWithFrame:self.frame];
    bg.image = [UIImage imageNamed:@"MC.png"];
    [self addSubview:bg];
    bg.tag = MIDDLE_TAG;
    
    
    
    
    turnoffButton = [[UIButton alloc] initWithFrame:CGRectMake(77, 75, 45, 45)];
    [turnoffButton setTitle:@"" forState:UIControlStateNormal ];
    [turnoffButton addTarget:self action:@selector(turnoffView) forControlEvents:UIControlEventTouchDown];
    turnoffButton.backgroundColor = [UIColor colorWithRed:255. green:255. blue:255. alpha:0.0];
    
    [self addSubview:turnoffButton];
    turnoffButton.tag = TAP_TAG;
    
}



-(IBAction)turnoffView {
    
   // [self removeFromSuperview];
    //[rev removeFromSuperview];
   // [rev2 removeFromSuperview];
   // [turnoffButton removeFromSuperview];
    
}





- (UIImageView *) getCloveByValue:(int)value {
    
    UIImageView *res;
    
    NSArray *views = [container subviews];
    
    for (im in views) {
        
        if (im.tag == value)
            res = im;
        
    }
    
    return res;
    
}





//Get section Numbers

- (void) buildClovesEven {
    
    CGFloat fanWidth = M_PI*2/numberOfSections;
    CGFloat mid = 0;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        SMClove *clove = [[SMClove alloc] init];
        clove.midValue = mid;
        clove.minValue = mid - (fanWidth/2);
        clove.maxValue = mid + (fanWidth/2);
        clove.value = i;
        
        
        if (clove.maxValue-fanWidth < - M_PI) {
            
            mid = M_PI;
            clove.midValue = mid;
            clove.minValue = fabsf(clove.maxValue);
            
        }
        
        mid -= fanWidth;
        
        
        NSLog(@"cl is %@", clove);
        
        [cloves addObject:clove];
        
    }
    
}

//get sections
- (void) buildClovesOdd {
    
    CGFloat fanWidth = M_PI*2/numberOfSections;
    CGFloat mid = 0;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        SMClove *clove = [[SMClove alloc] init];
        clove.midValue = mid;
        clove.minValue = mid - (fanWidth/2);
        clove.maxValue = mid + (fanWidth/2);
        clove.value = i;
        
        mid -= fanWidth;
        
        if (clove.minValue < - M_PI) {
            
            mid = -mid;
            mid -= fanWidth; 
            
        }
        
        
        [cloves addObject:clove];
        
        NSLog(@"cl is %@", clove);
        
    }
    
}









///////////////////////////////////
//
////////////////////////////////////




- (float) calculateDistanceFromCenter:(CGPoint)point {
    
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return sqrt(dx*dx + dy*dy);
    
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    rev.hidden = NO;
    rev2.hidden = NO;
    turnoffButton.hidden = NO;
    bg.hidden = NO;
    CGPoint touchPoint = [touch locationInView:self];
    float dist = [self calculateDistanceFromCenter:touchPoint];
    
    if (dist < 40 || dist > 100) 
    {
        // forcing a tap to be on the ferrule
        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return NO;
    }
    
	float dx = touchPoint.x - container.center.x;
	float dy = touchPoint.y - container.center.y;
	deltaAngle = atan2(dy,dx); 
    
    [self spheroHeadingFromRoomHeading:0];
    
    startTransform = container.transform;
    
    im = [self getCloveByValue:currentValue];
    im.alpha = minAlphavalue;
    
    return YES;
    
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    
	CGPoint pt = [touch locationInView:self];
    
    float dist = [self calculateDistanceFromCenter:pt];
    
    if (dist < 40 || dist > 100) 
    {
        // a drag path too close to the center
        NSLog(@"drag path too close to the center (%f,%f)", pt.x, pt.y);
        
        // here you might want to implement your solution when the drag 
        // is too close to the center
        // You might go back to the clove previously selected
        // or you might calculate the clove corresponding to
        // the "exit point" of the drag.
        
    }
	
	float dx = pt.x  - container.center.x;
	float dy = pt.y  - container.center.y;
	float ang = atan2(dy,dx);
    
    float angleDifference = deltaAngle - ang;
    
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    
    transformangle = angleDifference;
    
    calibrationAngle =  -angleDifference * 60.000;
    while (calibrationAngle >= 360.0f) calibrationAngle -= 360.0f;
    while (calibrationAngle < 0.0f) calibrationAngle += 360.0f;
    
    NSLog(@"calibrate (%.f)", calibrationAngle);
   
   // [RKDeviceMessenger sharedMessenger: RK
    //[RKRollCommand sendCommandWithHeading:calibrationAngle velocity:0.0];
    [RKBackLEDOutputCommand sendCommandWithBrightness:1.0];
    //[self performSelector:@selector(recalibrate) withObject:nil afterDelay:(0.2f)];
    [self recalibrate];
    
  
    return YES;

}

-(void)recalibrate {
    //////////////////////////////
    //
    /////////////////////////////
   
   // [RKCalibrateCommand sendCommandWithHeading:[self spheroHeadingFromRoomHeading:calibrationAngle]];
    if ( calibrationAngle > spheroHeadingZero ) {
       
        RKMacroObject *macro = [RKMacroObject new];
        
    //[self spheroHeadingFromRoomHeading:calibrationAngle];
    //[macro addCommand:[RKMCCalibrate commandWithHeading:180 delay:0 ]];
        [macro addCommand:[RKMCCalibrate commandWithHeading:[self spheroHeadingFromRoomHeading:calibrationAngle]+30 delay:255 ]];
        //[macro addCommand:[RKMCEmit commandWithID:002]]; 
        //[macro addCommand:[RKMCCalibrate commandWithHeading:0 delay:255]];
       // [macro addCommand:[RKMCRGB commandWithRed:1.0 green:1.0 blue:1.0 delay:255]];
        
        [macro playMacro];
          NSLog(@"cali (%.f)", calibrationAngle);
      //  [self spheroHeadingFromRoomHeading:calibrationAngle];
        spheroHeadingZero = calibrationAngle;
        
        //macroplay =NO;
    }
    
    if ( calibrationAngle < spheroHeadingZero ) {
  //  [self spheroHeadingFromRoomHeading:0];
 //   spheroHeadingZero = -calibrationAngle;
    
    //if (macroplay == NO) {
    //macroplay =YES;
   // while (calibrationAngle == spheroHeadingZero ) {
         
        [RKRollCommand sendCommandWithHeading:calibrationAngle velocity:0.0];
        [RKBackLEDOutputCommand sendCommandWithBrightness:1.0];
        
        /*
         RKMacroObject *macro = [RKMacroObject new];
         
         //[self spheroHeadingFromRoomHeading:calibrationAngle];
         //[macro addCommand:[RKMCCalibrate commandWithHeading:180 delay:0 ]];
         [macro addCommand:[RKMCCalibrate commandWithHeading:[self spheroHeadingFromRoomHeading:calibrationAngle]-30 delay:255 ]];
         //[macro addCommand:[RKMCEmit commandWithID:002]]; 
         //[macro addCommand:[RKMCCalibrate commandWithHeading:0 delay:255]];
         // [macro addCommand:[RKMCRGB commandWithRed:1.0 green:1.0 blue:1.0 delay:255]];
         
         [macro playMacro];
         */
         NSLog(@"cali (%.f)", calibrationAngle);
         //  [self spheroHeadingFromRoomHeading:calibrationAngle];
         
         spheroHeadingZero = calibrationAngle;
       
  }

}

- (float) spheroHeadingFromRoomHeading: (float) roomHeading
{
    
    angle = roomHeading - spheroHeadingZero;
     
    while (angle >= 360.0f) angle -= 360.0f;
    while (angle < 0.0f) angle += 360.0f;
    NSLog(@"angle (%.f)", angle);
    return angle;
}


- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    
    CGFloat newVal = 0.0;
    
    for (SMClove *c in cloves) {
        
        if (c.minValue > 0 && c.maxValue < 0) { // anomalous case
            
            if (c.maxValue > radians || c.minValue < radians) {
                
                if (radians > 0) { // we are in the positive quadrant
                    
                    newVal = radians - M_PI;
                    
                } else { // we are in the negative one
                    
                    newVal = M_PI + radians;                    
                    
                }
                currentValue = c.value;
                
            }
            
        }
        
        else if (radians > c.minValue && radians < c.maxValue) {
         
            
            newVal = radians - c.midValue;
            currentValue = c.value;
            
        }
        
    }
    
    [RKCalibrateCommand sendCommandWithHeading:calibrationAngle];
    [RKBackLEDOutputCommand sendCommandWithBrightness:0.0];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -newVal);
    container.transform = t;
    
    [UIView commitAnimations];
    
    [self.delegate wheelDidChangeValue:[self getCloveName:currentValue]];
    
    im = [self getCloveByValue:currentValue];
    im.alpha = maxAlphavalue;
    


    
    rev.hidden = YES;
    rev2.hidden = YES;
    turnoffButton.hidden = YES;
    bg.hidden = YES;
    
   
    CGAffineTransform l = CGAffineTransformRotate(container.transform, transformangle);

    container.transform = l;
    [self ddeloc];
    
}
    


-(void)ddeloc{
     transformangle= 0.00f;
    calibrationAngle = 0.f;
    spheroHeadingZero = 0.f;
}



//Get Name of Angle (not important)

- (NSString *) getCloveName:(int)position {
    
    NSString *res = @"";
    
    switch (position) {
        case 0:
            res = @"Circles";
            break;
            
        case 1:
            res = @"Flower";
            break;
            
        case 2:
            res = @"Monster";
            break;
            
        case 3:
            res = @"Person";
            break;
            
        case 4:
            res = @"Smile";
            break;
            
        case 5:
            res = @"Sun";
            break;
            
        case 6:
            res = @"Swirl";
            break;
            
            // case 7:
            //     res = @"3 circles";
            //     break;
            
            // case 8:
            //     res = @"Triangle";
            //     break;
            
        default:
            break;
    }
    
    return res;
}



@end
