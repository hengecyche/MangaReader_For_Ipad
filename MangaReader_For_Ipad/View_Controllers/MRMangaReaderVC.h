//
//  MRMangaReaderVC.h
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 6/18/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MRMangaReaderVC:UIViewController

@property (nonatomic) NSURL *imgURL;
-(id)initWithURL:(NSURL*)url;
@end