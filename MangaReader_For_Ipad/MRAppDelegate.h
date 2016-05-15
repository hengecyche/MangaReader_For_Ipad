//
//  AppDelegate.h
//  MangaReader For Ipad
//
//  Created by hengecyche on 1/3/16.
//  Copyright © 2016 hengecyche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHandler.h"
@interface MRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CoreDataHandler *cdh;
@end

