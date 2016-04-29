//
//  FilePath.m
//  MangaReader For Ipad
//
//  Created by hengecyche on 3/6/16.
//  Copyright © 2016 hengecyche. All rights reserved.
//

#import "FilePathURL.h"

@implementation FilePathURL

+(NSURL*)databaseDirectory
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSURL *newURL=[[self documentDirectory] URLByAppendingPathComponent:@"Database" isDirectory:YES];
    if([newURL checkResourceIsReachableAndReturnError:nil]==NO)
    {
        NSError *error;
        if(![fileManager createDirectoryAtURL:newURL withIntermediateDirectories:YES attributes:nil error:&error])
        {

            NSLog(@"Error Occurred: %ld - %@",(long)error.code,error.localizedDescription);
            return nil;
        }
    }
    return newURL;
}

+(NSURL*)documentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSURL *url=[NSURL fileURLWithPath:[paths objectAtIndex:0]];
    return url;
}

+(NSURL*)thumbDirectory
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];

    NSURL *url=[urls objectAtIndex:0];
    
    NSURL *newURL=[url URLByAppendingPathComponent:@"Thumbs" isDirectory:YES];
    if([newURL checkResourceIsReachableAndReturnError:nil]==NO)
    {
        NSError *error;
        if(![fileManager createDirectoryAtURL:newURL withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Error Occurred: %ld - %@",(long)error.code,error.localizedDescription);
            return nil;
        }
    }
    return newURL;
}

+(NSURL*)tempDirectory
{
    NSURL *tempDirectory=[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]] isDirectory:YES];
    
    return tempDirectory;
}
@end