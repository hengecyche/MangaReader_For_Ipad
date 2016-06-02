 //
//  MRArchiveDetailVIew.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/18/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRArchiveDetailView.h"

@interface MRArchiveDetailView()

@property (nonatomic) UIButton *btnRead;
@end

@implementation MRArchiveDetailView

-(MRArchiveDetailView*)getView
{
    [self setBackgroundColor:[UIColor blackColor]];
    
    UIImageView *archiveImageView=[self getArchiveImageView];
    [self addSubview:archiveImageView];
    
    self.contentMode=UIViewContentModeScaleToFill;
    return self;
}

-(UIImageView*)getArchiveImageView
{
    UIImageView *archiveImage=[[UIImageView alloc] initWithFrame:[self calculateFrameForImageView]];
    archiveImage.image=[self archiveThumb];
    return archiveImage;
}

-(CGRect)calculateFrameForImageView
{
    CGFloat width=self.frame.size.width/3;
    CGFloat height=width*1.5;
    CGFloat originX=[self calculateXForWidth:width];
    
    CGFloat originY=[self calculateY];
    return CGRectMake(originX,originY,width,height);
}

-(CGFloat)calculateXForWidth:(CGFloat)width;
{
    CGFloat viewWidth=self.frame.size.width;

    return (viewWidth/2)-(width/2);
    
}

-(CGFloat)calculateY
{
    NSArray *subviews=[self subviews];
    if([subviews count]==0) return self.frame.origin.y+40;
    
    //NSLog(@"%lu",(unsigned long)[subviews count]);
    UIView *lastView=[subviews objectAtIndex:([subviews count]-1)];
    CGRect frame=lastView.frame;
    return frame.origin.y+frame.size.height+20;
    
}
@end