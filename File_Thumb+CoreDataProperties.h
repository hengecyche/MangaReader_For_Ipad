//
//  File_Thumb+CoreDataProperties.h
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/19/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "File_Thumb.h"

NS_ASSUME_NONNULL_BEGIN

@interface File_Thumb (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *fileID;
@property (nullable, nonatomic, retain) NSString *filePath;
@property (nullable, nonatomic, retain) NSString *thumbPath;

@end

NS_ASSUME_NONNULL_END
