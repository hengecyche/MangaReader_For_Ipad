//
//  MRImageBrowserViewController.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/26/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRImageListProcessor.h"
#import "MRArchiveManager.h"

#import "FilePathURL.h"
#import "FileManager.h"

@interface MRImageListProcessor()
@property (nonatomic,retain) NSURL *url;
@property (nonatomic) NSURL *dirWithImages;
@property (nonatomic,retain) NSArray *mangaImageList;
@property (nonatomic,retain) MRArchiveManager *archiveMng;
@end


@implementation MRImageListProcessor
-(id)initWithURL:(NSURL*)url
{
    if(self=[super init])
    {
        _url=url;
        [self handlePreStartUp];
    }
    return self;
}

-(NSArray*)getMangaImageList
{
    return _mangaImageList;
}

-(void)handlePreStartUp
{
    if([[FileManager alloc] isValidImageFile:_url])
    {
        _dirWithImages=[_url URLByDeletingLastPathComponent];
    }
    
    if([[FileManager alloc] isValidArchiveFile:_url])
    {
        _archiveMng=[[MRArchiveManager alloc] initWithArchive:_url];        
        _dirWithImages=[self getURLOfExtractedArchive];
    }
    
    NSError *err;
    if(![_dirWithImages checkResourceIsReachableAndReturnError:&err])
    {
        NSLog(@"Couldn't process file");
        return;
        //Add a alertView
    }
    
    _mangaImageList=[self getImageListFromDirectory:_dirWithImages];
}


#pragma mark - Image Utiliry Methods

-(NSArray*)getImageListFromDirectory:(NSURL*)dirURL
{
    NSFileManager *fileMng=[NSFileManager defaultManager];
    
    NSArray *fileList=[fileMng contentsOfDirectoryAtURL:dirURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    
    NSMutableArray *imageList=[[NSMutableArray alloc] init];
    
    for(NSURL *fileURL in fileList)
    {
        if([[FileManager alloc] isValidImageFile:fileURL])
        {
            [imageList addObject:fileURL];
        }
    }
    
    
    return [NSArray arrayWithArray:imageList];
}
#pragma mark - Archive Validation And Extraction
-(NSURL*)getURLOfExtractedArchive
{
    NSURL *dest=[FilePathURL extractionDirectory];
    NSString *dirName=[self getValidDirectoryNameForExtraction];
    
    NSURL *expectedDest=[dest URLByAppendingPathComponent:dirName];
    
    if(![self validateExtractionDestinationAtURL:expectedDest])
    {
        [_archiveMng extractArchiveAtDestination:expectedDest];
    }
    
    return expectedDest;
}

-(BOOL)validateExtractionDestinationAtURL:(NSURL*)dest
{
    NSFileManager *fileMng=[NSFileManager defaultManager];
    BOOL isDirectory;
    
    //if the directory doesn't exist
    if(![fileMng fileExistsAtPath:[dest path] isDirectory:&isDirectory]) return NO;
    //if the url is not directory
    if(!isDirectory) return NO;
    
    NSArray *archiveFileList=[_archiveMng getFileList];
    NSArray *directoryFileList=[[FileManager alloc] getFileNameListFromDirectory:(NSURL*)dest];

    if([archiveFileList count]!=[directoryFileList count]) return NO;
    
    return YES;
}




-(NSString*)getValidDirectoryNameForExtraction{
    NSArray *pathComponents=[_url pathComponents];
    NSString *validDirName=[NSString stringWithFormat:@"extracted_%@_%@",
                              [pathComponents objectAtIndex:([pathComponents count]-2)],
                              [[[_url lastPathComponent] componentsSeparatedByString:@"."] firstObject]
                              ];
    return validDirName;
}

@end
