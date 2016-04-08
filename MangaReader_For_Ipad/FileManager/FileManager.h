//
//  FileManager.h
//  MangaReader For Ipad
//
//  Created by hengecyche on 2/4/16.
//  Copyright © 2016 hengecyche. All rights reserved.
//
#import "Constants.h"
@interface FileManager:NSObject
-(BOOL)isDirectory:(NSURL*)url;
-(BOOL)isValidArchiveFile:(NSURL*)url;
-(BOOL)isValidImageFile:(NSURL*)url;
@end