//
//  HCAlertController.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 6/23/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "HCAlertController.h"

@implementation HCAlertController

+(HCAlertController *)alertWithTitle:(NSString*)title message:(NSString*)message
{
    HCAlertController* alert = [self alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"Pressed OK.");
                                                          }];
    [alert addAction:defaultAction];
    return alert;
}

@end
