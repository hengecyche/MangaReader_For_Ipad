//
//  FilePath.h
//  MangaReader For Ipad
//
//  Created by hengecyche on 3/6/16.
//  Copyright © 2016 hengecyche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilePathURL:NSObject

+(NSURL*)documentDirectory;
+(NSURL*)thumbDirectory;
+(NSURL*)tempDirectory;
@end