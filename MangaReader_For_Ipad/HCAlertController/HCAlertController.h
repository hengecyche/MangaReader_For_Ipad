//
//  HCAlertController.h
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 6/23/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HCAlertController:UIAlertController
+(HCAlertController*)alertWithTitle:(NSString*)title message:(NSString*)message;
@end
