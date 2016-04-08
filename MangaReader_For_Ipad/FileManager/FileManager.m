//
//  FileManager.m
//  MangaReader For Ipad
//
//  Created by hengecyche on 2/4/16.
//  Copyright © 2016 hengecyche. All rights reserved.
//


#import "FileManager.h"
#import <UIKit/UIKit.h>

@interface FileManager()
-(NSString*)getExtensionFromFileWithURL:(NSURL*)url
@end

@implementation FileManager
-(BOOL)isDirectory:(NSURL*)url
{
    NSNumber *isDirectory;
    NSError *error=nil;
    [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];

    if(error)
    {
        NSLog(@"File System Couldn't be Determined");
        return NO;
    }
    return [isDirectory boolValue];
}

-(BOOL)isValidArchiveFile:(NSURL*)url
{
    NSString *ext=[self getExtensionFromFileWithURL:url];
    if(![ARCHIVE_FILE_TYPES containsString:ext])
    {
        return NO;
    }
    
    return YES;
}

-(BOOL)isValidImageFile:(NSURL*)url
{
    NSString *ext=[self getExtensionFromFileWithURL:url];
    if(![IMAGE_FILE_TYPES containsString:ext])
    {
        return NO;
    }
    
    return YES;
}

-(NSString*)getExtensionFromFileWithURL:(NSURL*)url
{
    return [[url path] pathExtension];
}
@end
