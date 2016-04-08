//
//  MRDirectoryParser.h
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 4/8/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//


#import "Constants.h"
#import "FileManager.h"
@interface MRDirectoryParser:NSObject
-(NSArray*)getFileListFromDirectoryWithURL:(NSURL*)url;
-(NSURL*)fetchFileListFromDocumentDirectory;


@end
