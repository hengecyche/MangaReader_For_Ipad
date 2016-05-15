//
//  MRArchiveMetaDataParser.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/15/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRArchiveMetaDataParser.h"
#import "MRArchiveManager.h"
@implementation MRArchiveMetaDataParser
+(NSDictionary*)getMetaDataOfArchiveWithURL:(NSURL*)url
{
    
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