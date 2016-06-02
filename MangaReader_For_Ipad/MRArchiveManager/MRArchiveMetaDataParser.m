//
//  MRArchiveMetaDataParser.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/15/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRArchiveMetaDataParser.h"
#import "MRArchiveManager.h"
#import "Constants.h"

@interface MRArchiveMetaDataParser()
@end

@implementation MRArchiveMetaDataParser
-(NSDictionary*)getMetaDataOfArchiveWithURL:(NSURL*)url
{
    NSArray *objects=[NSArray arrayWithObjects:[url lastPathComponent],@"NOT_READ_YET",[url pathExtension],[NSNumber numberWithInt:0],[NSNumber numberWithBool:YES],[NSDate date],[NSNumber numberWithDouble:[self getTotalNumberOfImagesInArchive:url]],nil];
    
    NSArray *keys=[NSArray arrayWithObjects:@"archiveName",@"archiveStatus",@"archiveType",@"currentPage",@"isManga",@"lastAccessedDate",@"numberOfImagesInArchive",nil];
    
    NSDictionary *metaDict=[NSDictionary dictionaryWithObjects:
                            objects
                            forKeys:
                            keys
                            ];
    return metaDict;
}

-(double)getTotalNumberOfImagesInArchive:(NSURL*)url
{
    MRArchiveManager *archiveManager=[[MRArchiveManager alloc] initWithArchive:url];
    NSArray *array=[archiveManager getFileList];
    return [array count];
}
@end

/*
 @dynamic archiveName;
 @dynamic archiveStatus;
 @dynamic archiveType;
 @dynamic currentPage;
 @dynamic isManga;
 @dynamic lastAccessedDate;
 @dynamic numberOfImagesInArchive;
 */