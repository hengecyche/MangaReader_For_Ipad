//
//  Constants.h
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 4/8/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef Constants_h
#define Constants_h


//core data Entity constant
static NSString *const ENTITY_ARCHIVE=@"Archive_Meta";
static NSString *const ENTITY_FILE=@"File_System";

//supported file list constant
static NSString *const ARCHIVE_FILE_TYPES=@"zip,cbz,rar,cbr";
static NSString *const IMAGE_FILE_TYPES=@"jpg,png,jpeg,gif";

typedef enum ARCHIVE_STATUS
{
    NOT_READ_YET,
    READING,
    COMPLETED
    
} ARCHIVE_STATUS;
#endif /* Header_h */