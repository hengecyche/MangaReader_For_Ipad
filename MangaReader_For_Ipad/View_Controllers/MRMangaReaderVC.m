//
//  MRMangaReaderVC.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 6/18/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRMangaReaderVC.h"
@interface MRMangaReaderVC()<UIScrollViewDelegate>
@property (nonatomic) UIScrollView *mainView;
@property (nonatomic) UIImageView *imageView;
@end


@implementation MRMangaReaderVC

-(id)initWithURL:(NSURL*)url
{
    if(self=[super init])
    {
        _imgURL=url;
    }
    
    return self;
}

-(void)viewDidLoad
{
    [self viewLoadWithFrame:[[UIScreen mainScreen] bounds]];
}
-(void)viewLoadWithFrame:(CGRect)frame
{
    //;
    
    [self setImageView];
    _mainView=[[UIScrollView alloc] initWithFrame:frame];
    
    [_mainView addSubview:_imageView];
    [_mainView setContentSize:CGSizeMake(_imageView.frame.size.width,_imageView.frame.size.height)];
    _mainView.scrollEnabled=YES;
    _mainView.bounces=NO;
    _mainView.maximumZoomScale=6.0;
    _mainView.minimumZoomScale=1.0;
    
    _mainView.delegate=self;
    [self setView:_mainView];
}

-(void)setImageView
{
    UIImage *mainImage=[UIImage imageWithContentsOfFile:[_imgURL path]];
    
    float imgHeight=mainImage.size.height;
    float imgWidth=mainImage.size.width;
    
    CGRect scrBounds=[[UIScreen mainScreen] bounds];
    float scrHeight=scrBounds.size.height;
    float scrWidth=scrBounds.size.width;
    
    float imgViewX = 0,imgViewY=0,imgViewWidth=0,imgViewHeight=0;
    if(imgWidth>imgHeight)
    {
        NSLog(@"Width");
        float heightRatio=imgHeight/imgWidth;
        
        imgViewWidth=scrBounds.size.width;
        imgViewHeight=imgViewWidth*heightRatio;
        

        imgViewY=scrHeight/2-imgViewHeight/2;
        NSLog(@"%f",imgViewY);
    }
    
    if(imgWidth==imgHeight)
    {
        NSLog(@"Equal");
        imgViewWidth=imgViewHeight=scrBounds.size.width;
        imgViewY=scrHeight/2-imgViewWidth/2;
    }
    
    if(imgHeight>imgWidth)
    {
        NSLog(@"Height");
        float widthRatio=imgWidth/imgHeight;
        
        imgViewHeight=scrBounds.size.height;
        imgViewWidth=imgViewHeight*widthRatio;
        
        
        imgViewX=scrWidth/2-imgViewWidth/2;

    }
    
    CGRect frameRect=CGRectMake(imgViewX,imgViewY,imgViewWidth,imgViewHeight);
    _imageView=[[UIImageView alloc] initWithImage:mainImage];
    [_imageView setFrame:frameRect];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
}

#pragma mark - ScrollView Delegate
-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return _imageView;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    //NSLog(@"%f X %f",(*targetContentOffset).x,(*targetContentOffset).y);
    //NSLog(@"%f X %f",velocity.x,velocity.y);
}


@end
