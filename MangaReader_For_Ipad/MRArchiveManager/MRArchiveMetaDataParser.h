//
//  MRArchiveMetaDataParser.h
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/15/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRArchiveManager.h"

@interface MRArchiveMetaDataParser:NSObject
+(NSDictionary*)getMetaDataOfArchiveWithURL:(NSURL*)url;
@end
