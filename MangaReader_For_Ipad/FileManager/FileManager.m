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
@property (nonatomic) NSArray *allowedFileExtensions;
@end

@implementation FileManager

-(id)init
{
    if(self=[super init])
    {
        self.allowedFileExtensions=[NSArray arrayWithObjects:@"rar",@"cbr",@"zip",@"cbz",nil];
    }
    return self;
}

//Fetch all files from a directory in a URL
-(NSArray*)getFilesFromDirectoryWithURL:(NSURL*)url
{
    
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    
    NSArray *keys=[NSArray arrayWithObjects:NSURLNameKey,NSURLAddedToDirectoryDateKey,NSURLIsDirectoryKey,NSURLIsHiddenKey,NSURLIsRegularFileKey,NSURLVolumeURLKey,nil];
    

    NSDirectoryEnumerator* dirEnumerator=[fileManager enumeratorAtURL:url includingPropertiesForKeys:keys options:NSDirectoryEnumerationSkipsPackageDescendants|NSDirectoryEnumerationSkipsSubdirectoryDescendants errorHandler:nil];

    NSMutableArray *files=[[NSMutableArray alloc] init];
    int i=0;
    for(NSURL *fileURL in dirEnumerator)
    {
        [files addObject:fileURL];
        i++;
    }
    
    NSArray *returnFiles=[NSArray arrayWithArray:files];
    return returnFiles;
}

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

@end
