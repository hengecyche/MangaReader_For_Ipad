//
//  MRMangaReaderVC.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 6/18/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRMangaReaderVC.h"
@interface MRMangaReaderVC()<UIScrollViewDelegate>
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) NSURL *imgURL;
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
    UIScrollView *mainView=[[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _imageView=[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[_imgURL path]]];
    [_imageView setFrame:mainView.bounds];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [mainView addSubview:_imageView];
    [mainView setContentSize:CGSizeMake(_imageView.bounds.size.width,_imageView.bounds.size.height)];
    mainView.scrollEnabled=YES;
    mainView.bounces=NO;
    mainView.maximumZoomScale=8.0;
    mainView.minimumZoomScale=1.0;
    mainView.delegate=self;
    self.view=mainView;
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return _imageView;
}


@end