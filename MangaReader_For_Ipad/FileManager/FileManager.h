//
//  FileManager.h
//  MangaReader For Ipad
//
//  Created by hengecyche on 2/4/16.
//  Copyright © 2016 hengecyche. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "FilePathURL.h"
#import <Unrar4iOS/Unrar4iOS.h>
@interface FileManager:NSObject

-(NSArray*)getFilesFromDirectoryWithURL:(NSURL*)url;
-(BOOL)isDirectory:(NSURL*)url;
@end