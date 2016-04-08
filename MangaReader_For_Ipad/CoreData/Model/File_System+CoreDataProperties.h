//
//  File_System+CoreDataProperties.h
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 4/9/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "File_System.h"

NS_ASSUME_NONNULL_BEGIN

@interface File_System (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *fileId;
@property (nullable, nonatomic, retain) NSString *fileName;
@property (nullable, nonatomic, retain) NSNumber *isDirectory;
@property (nullable, nonatomic, retain) NSString *fileURL;
@property (nullable, nonatomic, retain) NSString *fileThumb;

@end

NS_ASSUME_NONNULL_END
