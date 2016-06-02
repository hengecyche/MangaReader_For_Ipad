//
//  AppDelegate.m
//  MangaReader For Ipad
//
//  Created by hengecyche on 1/3/16.
//  Copyright © 2016 hengecyche. All rights reserved.
//

#import "MRAppDelegate.h"
#import "FileManager.h"
#import "FilePathURL.h"

#import "MRArchiveManager.h"
#import "MRCoreData.h"

#import "MRFileListTableViewController.h"
#import "MRFileDetailViewController.h"
#import "MRFileListCollectionViewController.h"

@interface MRAppDelegate ()

@end

@implementation MRAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled"))
       //NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
    
    self.cdh=[[CoreDataHandler alloc] init];
    //[[[MRCoreData alloc] init] demo];
    
    _window=[[UIWindow alloc]
             initWithFrame:
             [[UIScreen mainScreen]
              bounds]];
    
    //fileListController
   /* UINavigationController *tableFileListViewController=[[UINavigationController alloc]
                                                         initWithRootViewController:
                                                         [[MRFileListTableViewController alloc] init]];
    
    //fileDetailController
    UINavigationController *tableFileDetailViewController=[[UINavigationController alloc]
                                                           initWithRootViewController:
                                                           [[MRFileDetailViewController alloc]
                                                            init]];
    
    NSArray *viewControllers=[NSArray arrayWithObjects:
                              tableFileListViewController,tableFileDetailViewController,nil];
    
    //splitViewController
    UISplitViewController *rootView=[[UISplitViewController alloc] init];
    rootView.viewControllers=viewControllers;*/
    
    UINavigationController *rootView=[[UINavigationController alloc] initWithRootViewController:[[MRFileListCollectionViewController alloc] initWithURL:[FilePathURL documentDirectory]]];
    
    _window.rootViewController=rootView;
    [_window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[MRArchiveManager alloc] emptyTempDirectory];
}


@end
