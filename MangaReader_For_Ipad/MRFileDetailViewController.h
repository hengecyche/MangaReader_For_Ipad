//
//  MRFileDetailViewController.h
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/14/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "Constants.h"
#import <UIKit/UIKit.h>
@interface MRFileDetailViewController:UIViewController
-(id)initWithFileURL:(NSURL*)url;
-(void)configureDetailViewForItemAtURL:(NSURL*)url;
@end