//
//  MRImageBrowserViewController.h
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/26/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MRImageListProcessor:NSObject
-(id)initWithURL:(NSURL*)url;
-(NSArray*)getMangaImageList;
@end