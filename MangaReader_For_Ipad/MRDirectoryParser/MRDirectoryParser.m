//
//  MRDirectoryParser.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 4/8/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRDirectoryParser.h"
#import "FilePathURL.h"
@interface MRDirectoryParser(Private)

@end

@implementation MRDirectoryParser

//Fetch all files from a directory in a URL
-(NSArray*)getFileListFromDirectoryWithURL:(NSURL*)url
{
    
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    
    NSArray *keys=[NSArray arrayWithObjects:NSURLNameKey,NSURLAddedToDirectoryDateKey,NSURLIsDirectoryKey,NSURLIsHiddenKey,NSURLIsRegularFileKey,NSURLVolumeURLKey,nil];
    
    
    NSDirectoryEnumerator* dirEnumerator=[fileManager enumeratorAtURL:url includingPropertiesForKeys:keys options:NSDirectoryEnumerationSkipsSubdirectoryDescendants errorHandler:nil];
    
    NSMutableArray *files=[[NSMutableArray alloc] init];
    
    for(NSURL *fileURL in dirEnumerator)
    {
        [files addObject:fileURL];
    }
    
    NSArray *returnFiles=[NSArray arrayWithArray:files];
    return returnFiles;
}

//fetches Files From Document Directory
-(NSArray*)fetchFileListFromDocumentDirectory
{
    return [self getFileListFromDirectoryWithURL:[FilePathURL documentDirectory]];
}


@end