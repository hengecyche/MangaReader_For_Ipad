//
//  MRCoreData.h
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 4/9/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//


#import "Constants.h"
#import <CoreData/CoreData.h>
@class CoreDataHandler;

@interface MRCoreData:NSObject

-(CoreDataHandler*)cdh;

-(NSArray*)fetchDataFromEntityWithEntityName:(NSString*)entity;
@end