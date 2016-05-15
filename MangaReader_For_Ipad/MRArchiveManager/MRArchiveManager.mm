//
//  MRArchiveManager.m
//  MangaReader For Ipad
//
//  Created by hengecyche on 3/12/16.
//  Copyright © 2016 hengecyche. All rights reserved.
//


#import "Constants.h"
#import "MRArchiveManager.h"


@interface MRArchiveManager()<NSFileManagerDelegate>

@property (nonatomic) NSURL* archiveURL;
@property (nonatomic) NSString* archiveExtension;

-(NSURL*)handleZIPExtractionAtDestination:(NSURL*)destinationURL;
-(NSURL*)handleRARExtractionAtDestination:(NSURL*)destinationURL;
@end

@implementation MRArchiveManager

#pragma mark - Initiating Methods
-(id)initWithArchive:(NSURL*)url
{
    if(self=[super init])
    {
        if(url && [url isFileURL])
        {
            if([ARCHIVE_FILE_TYPES containsString:[url pathExtension]])
            {
                _archiveURL=url;
                _archiveExtension=[url pathExtension];
            }else
            {
                NSLog(@"This Application Doesn't handle the file type!");
                return nil;
            }
        }else
        {
            NSLog(@"Invalid URL(Either Url is nil or there is syntax error with the URL): %@",url);
            return nil;
        }
    }
    
    return self;
}

#pragma mark - Thumbnail Related Methods
-(NSURL*)getThumbnailForArchive
{
    NSArray *files=[self getFileList];
    NSMutableArray *fileList=[NSMutableArray arrayWithArray:files];
    [fileList sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSString *fileForThumb=[self getValidThumbFileForFileArray:[NSArray arrayWithArray:fileList]];
    
    NSURL *thumbURL=[[NSURL alloc] init];
    
    if([self isRARArchive])
    {
        thumbURL=[self saveThumbnailOfRARArchiveWithFilename:fileForThumb];
    }else if([self isZIPArchive])
    {
        thumbURL=[self saveThumbnailOfZIPArchiveWithFilename:fileForThumb];
    }
    
    
    if(!thumbURL && ![thumbURL checkResourceIsReachableAndReturnError:nil])
    {
        NSLog(@"Couldn't get the Thumbnail's URL");
        return nil;
    }
    
    [self emptyTempDirectory];
    return thumbURL;
    
}

-(NSURL*)saveThumbnailOfRARArchiveWithFilename:(NSString*)fileName
{

    NSURL *thumbDir=[FilePathURL thumbDirectory];
    Unrar4iOS *unrar=[[Unrar4iOS alloc] init];
    
    if(![unrar unrarOpenFile:[_archiveURL path]])
    {
        NSLog(@"Couldn't open Rar %@",[_archiveURL lastPathComponent]);
        return nil;
    }
    
    NSData *imageData=[unrar extractStream:fileName];
    
    
    [unrar unrarCloseFile];

    NSURL *finalURL=[thumbDir URLByAppendingPathComponent:[self getThumbNameWithFilename:fileName]];
    
    
    if(![imageData writeToURL:finalURL atomically:YES])
    {
        NSLog(@"Couldn't Write To The File");
        return nil;
    }
    return finalURL;
}



-(NSURL*)getThumbURLForZIPArchiveWithFileName:(NSString*)fileName
{
    //gets files after only extracting it in temp directory
    NSURL *fileListDestination=[self extractArchiveAtDestination:[FilePathURL tempDirectory]];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSArray* fileList=[fileManager contentsOfDirectoryAtURL:fileListDestination includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
    
    NSURL *fileURL=[[NSURL alloc] init];
    
    
    for(NSURL *file in fileList)
    {
        if([[file lastPathComponent] isEqualToString:fileName])
        {
            fileURL=file;
            break;
        }
    }
    
    return fileURL;
}

-(NSURL*)saveThumbnailOfZIPArchiveWithFilename:(NSString*)fileName
{

    NSURL *thumbDir=[FilePathURL thumbDirectory];
    

    NSURL *fileURL=[self getThumbURLForZIPArchiveWithFileName:fileName];
    NSURL *finalURL=[thumbDir URLByAppendingPathComponent:[self getThumbNameWithFilename:fileName]];

    NSFileManager *manager=[NSFileManager defaultManager];
    manager.delegate=self;
    
    NSError* error;
    if(![manager copyItemAtURL:fileURL toURL:finalURL error:&error])
    {
        NSLog(@"Couldn't write files. Error: %ld %@",(long)error.code,error.localizedDescription);
    }
    
    return finalURL;
    
}

-(NSString*)getThumbNameWithFilename:(NSString*)name
{
    NSString *newFileName=[NSString stringWithFormat:@"thumb_%@_%@",[[[_archiveURL lastPathComponent] componentsSeparatedByString:@"."] firstObject],name];
    return newFileName;
}

-(NSString*)getValidThumbFileForFileArray:(NSArray*)array
{
    NSString *file=@"";
    for(NSString *fileName in array)
    {
        NSArray *array=[fileName componentsSeparatedByString:@"."];//if not file
        if([array count]==0) continue;
        
        if(![IMAGE_FILE_TYPES containsString:[array lastObject]]) continue;
        //neet logic to check the extensions
        file=fileName;
        break;
    }
    

    if([file isEqual:@""]) return nil;
    
    return file;
}

#pragma mark - File Listing Methods
//file listing in a archive
-(NSArray*)getFileList
{
    if(!_archiveURL) return nil;
    
    NSArray *fileList;
    if([self isRARArchive])
    {
        fileList=[self getFileListOfRARTypeArchive];
    }else if([self isZIPArchive])
    {
        fileList=[self getFileListOfZIPTypeArchive];
    }
    
    if(!fileList and [fileList count]==0) return nil;
    [self emptyTempDirectory];
    return fileList;
}

//for rar types
-(NSArray*)getFileListOfRARTypeArchive
{
    Unrar4iOS *unrar=[[Unrar4iOS alloc] init];
    [unrar unrarOpenFile:[_archiveURL path]];
    
    NSArray *fileList=[unrar unrarListFiles];
    [unrar unrarCloseFile];
    if(fileList && [fileList count]>0)
    {
        return fileList;
    }else return nil;
        
}



//for zip types!! Since We don't have any method to get list,  we will extract the files in a temporary directory and get the list from there
-(NSArray*)getFileListOfZIPTypeArchive
{
    
    NSURL *zippedDirectory=[self handleZIPExtractionAtDestination:[FilePathURL tempDirectory]];
    
    NSError *error;
    NSArray *fileList=[[NSFileManager alloc] contentsOfDirectoryAtURL:zippedDirectory
                                          includingPropertiesForKeys:nil
                                                           options:(NSDirectoryEnumerationSkipsSubdirectoryDescendants)
                                                             error:&error];
    if(error)
    {
        NSLog(@"Type: ERROR \n Class:%@ \n Method: %@\nCouldn;t read the directory. %ld: %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd),(long)error.code,error.localizedDescription);
        return nil;
    }
    NSMutableArray *filesInArchive=[[NSMutableArray alloc] init];
    for(NSURL *file in fileList)
    {
        [filesInArchive addObject:[file lastPathComponent]];
    }
    
    NSArray *returnArray=[NSArray arrayWithArray:filesInArchive];
    return returnArray;
}

#pragma mark - EXTRACTING METHODS

//seperates the zop of extraction
-(NSURL*)extractArchiveAtDestination:(NSURL*)url
{
    NSURL *finalDestURL;
    if([self isZIPArchive])
    {
        finalDestURL=[self handleZIPExtractionAtDestination:url];
    }else if([self isRARArchive])
    {
        finalDestURL=[self handleRARExtractionAtDestination:url];
    }
    
    NSError *err;
    if([finalDestURL checkResourceIsReachableAndReturnError:&err]==NO)
    {
        return nil;
    }
    return finalDestURL;
}

//handles all ZIP Extraction
-(NSURL*)handleZIPExtractionAtDestination:(NSURL*)destinationURL
{
    NSString *destPath=[[[destinationURL absoluteURL] path]
                     stringByAppendingPathComponent:
                        [[[_archiveURL lastPathComponent] componentsSeparatedByString:@"."]
                         firstObject]];
    
    BOOL result=[SSZipArchive unzipFileAtPath:[_archiveURL path] toDestination:destPath];
    
    if(!result)
    {
        NSLog(@"Couldn't extract the Files.");
        return nil;
    }
   
    NSURL *url = [[NSURL alloc] initFileURLWithPath:destPath];
  
    return url;
}

-(NSURL*)handleRARExtractionAtDestination:(NSURL*)destinationURL
{
    Unrar4iOS *rarFile=[[Unrar4iOS alloc] init];
    [rarFile unrarOpenFile:[_archiveURL path]];
    
    NSString *destPath=[[[destinationURL absoluteURL] path]
                        stringByAppendingPathComponent:
                        [[[_archiveURL lastPathComponent] componentsSeparatedByString:@"."]
                         firstObject]];
    if(![rarFile unrarFileTo:destPath overWrite:YES])
    {
    
    }
    [rarFile unrarCloseFile];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:destPath];
    return url;
}

#pragma mark - Validating Methods

//checks if the extension is zip type archive
-(BOOL)isZIPArchive
{
    if(!_archiveURL) return NO;
    NSString *fileExt=@"zip,cbz";
    if([fileExt containsString:[_archiveURL pathExtension]])
    {
        return YES;
    }else
    {
        return NO;
    }
}

//checks if the extension is rar type archive
-(BOOL)isRARArchive
{
    if(!_archiveURL) return NO;
    NSString *fileExt=@"rar,cbr";
    if([fileExt containsString:[_archiveURL pathExtension]])
    {
        return YES;
    }else return NO;
}

#pragma mark - NSFileManager Delegate
- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error copyingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    if ([error code] == NSFileWriteFileExistsError) //error code for: The operation couldn’t be completed. File exists
        return YES;
    else
        return NO;
}

#pragma mark - Emptying Temp Directory

-(BOOL)emptyTempDirectory
{
    NSURL *tempDirectory=[FilePathURL tempDirectory];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSArray* fileList=[fileManager contentsOfDirectoryAtURL:tempDirectory includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
    
    for(NSURL *url in fileList)
    {
        [fileManager removeItemAtURL:url error:nil];
    }
    return YES;
}
@end