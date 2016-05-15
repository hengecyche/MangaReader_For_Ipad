//
//  Archive_Meta+CoreDataProperties.h
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/15/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Archive_Meta.h"

NS_ASSUME_NONNULL_BEGIN

@interface Archive_Meta (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *archiveName;
@property (nullable, nonatomic, retain) NSString *archiveStatus;
@property (nullable, nonatomic, retain) NSString *archiveType;
@property (nullable, nonatomic, retain) NSNumber *currentPage;
@property (nullable, nonatomic, retain) NSNumber *isManga;
@property (nullable, nonatomic, retain) NSDate *lastAccessedDate;
@property (nullable, nonatomic, retain) NSNumber *numberOfImagesInArchive;

@end

NS_ASSUME_NONNULL_END
