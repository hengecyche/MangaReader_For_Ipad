//
//  InteractiveImageView.m
//  MangaReader For Ipad
//
//  Created by hengecyche on 1/10/16.
//  Copyright © 2016 hengecyche. All rights reserved.
//

#import "InteractiveImageView.h"

#define DOUBLE_TAP_DELAY 0.5
BOOL multipleTouches;

@interface InteractiveImageView()

@end

@implementation InteractiveImageView
@synthesize delegate;

-(id)initWithImage:(UIImage*)image
{
    NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self=[super initWithImage:image];
    if(self)
    {
        self.userInteractionEnabled=YES;
        self.multipleTouchEnabled=YES;
        multipleTouches=NO;
    }
    return self;
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSLog(@"Number of touches: %lu",(unsigned long)[touches count]);
    NSLog(@"Touches for view: %u",[[event touchesForView:self] count]);
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    NSLog(@"Tap Count: %lu",(unsigned long)[touch tapCount]);
    NSLog(@"x=%f y=%f",point.x,point.y);
    
    NSLog(@"%f",event.timestamp);
}
@end
