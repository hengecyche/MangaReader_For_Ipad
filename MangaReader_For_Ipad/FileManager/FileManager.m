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
-(NSString*)getExtensionFromFileWithURL:(NSURL*)url;
@end

@implementation FileManager
#pragma mark - VALIDATION
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
    if([self isDirectory:url]) return NO;
    if(![IMAGE_FILE_TYPES containsString:ext])
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - Editing Functions
-(BOOL)moveFileWithURL:(NSURL*)currURL inDestination:(NSURL*)destURL
{

    return YES;
}

#pragma mark - Helper
-(NSString*)getValidThumbNameOfArchive:(NSURL*)archiveURL
{
    NSArray *archivePathComp=[archiveURL pathComponents];
    
    NSString *validThumbName=[NSString stringWithFormat:@"thumb_%@_%@.jpg",
                         [archivePathComp objectAtIndex:([archivePathComp count]-2)],
                              [[[archiveURL lastPathComponent] componentsSeparatedByString:@"."] firstObject]
                              ];
    return validThumbName;
}

-(NSString*)getExtensionFromFileWithURL:(NSURL*)url
{
    return [[url path] pathExtension];
}

-(NSArray*)getFileNameListFromDirectory:(NSURL*)url
{
    NSFileManager *fileMng=[NSFileManager defaultManager];
    NSArray *fileList=[fileMng contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    NSMutableArray *fileNameList=[[NSMutableArray alloc] init];
    for(NSURL *fileURL in fileList)
    {
        [fileNameList addObject:[fileURL lastPathComponent]];
    }
    
    return [NSArray arrayWithArray:fileNameList];
}
@end
