//
//  MRFileListCollectionViewCell.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/23/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRFileListCollectionViewCell.h"

@implementation MRFileListCollectionViewCell


-(UILabel*)textLabel
{
    if(!_textLabel)
    {
        _textLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,self.bounds.size.height-50,self.bounds.size.width,50)];
        _textLabel.font=[UIFont fontWithName:@"Helvetica" size:17];
        _textLabel.textAlignment=NSTextAlignmentCenter;
        _textLabel.backgroundColor=[UIColor colorWithWhite:0.7 alpha:0.6];
        
        [self.contentView addSubview:_textLabel];
        [self bringSubviewToFront:_textLabel];
        _textLabel.textColor=[UIColor blackColor];

    }
    return _textLabel;
}

-(UIImageView*)imageView
{
    if(!_imageView)
    {
        _imageView=[[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.contentView insertSubview:_imageView belowSubview:_textLabel];
        [self bringSubviewToFront:_textLabel];
    }
    return _imageView;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    _textLabel.text=@"";
    _imageView.image=nil;
}
@end