//
//  MRSplitViewController.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/14/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRSplitViewController.h"
#import "MRFileListTableViewController.h"

@interface MRSplitViewController()<UISplitViewControllerDelegate>

@end

@implementation MRSplitViewController

-(id)init
{
    if(self=[super init])
    {
        self.delegate=self;
    }
    return self;
}

-(UIInterfaceOrientation)splitViewControllerPreferredInterfaceOrientationForPresentation:(UISplitViewController *)splitViewController
{
    return UIInterfaceOrientationPortrait;
}


@end
