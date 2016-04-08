//
//  MRArchiveManager.h
//  MangaReader For Ipad
//
//  Created by hengecyche on 3/12/16.
//  Copyright © 2016 hengecyche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Unrar4iOS/Unrar4iOS.h>
#import "SSZipArchive.h"
#import "FilePathURL.h"

@interface MRArchiveManager:NSObject

-(id)initWithArchive:(NSURL*)url;

-(NSArray*)getFileList;

-(NSURL*)getThumbnailForArchive;

//returns the destination of the extraction
-(NSURL*)extractArchiveAtDestination:(NSURL*)destURL;
@end