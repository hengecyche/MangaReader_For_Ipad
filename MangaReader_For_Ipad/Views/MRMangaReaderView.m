//
//  MRMangaReaderView.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 6/2/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRMangaReaderView.h"

@interface MRMangaReaderView()

@end

@implementation MRMangaReaderView

-(UIImageView*)mainImage
{
    if(!_mainImage)
    {
        _mainImage=[[UIImageView alloc] initWithFrame:self.bounds];
        _mainImage.contentMode=UIViewContentModeScaleAspectFill;
        [self addSubview:_mainImage];
    }
    
    return _mainImage;
}

@end