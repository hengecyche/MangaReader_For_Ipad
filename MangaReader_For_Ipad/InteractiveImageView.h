#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol InteractiveImageViewDelegate;

@interface InteractiveImageView:UIImageView

@property (nonatomic,assign) id <InteractiveImageViewDelegate> delegate;

@end

@protocol InteractiveImageViewDelegate<NSObject>

@optional
-(void)interactiveImageView:(InteractiveImageView*)imageView gotSingleTapAtPoint:(CGPoint)point;
-(void)interactiveImageView:(InteractiveImageView*)imageView gotDoubleTapAtPoint:(CGPoint)point;
@end
