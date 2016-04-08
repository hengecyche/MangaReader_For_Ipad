//
//  CoreDataHandler.h
//  LNReader
//
//  Created by hengecyche on 1/21/16.
//  Copyright © 2016 Animeout. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHandler:NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *context;
@property (readonly, strong, nonatomic) NSManagedObjectModel *model;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *coordinator;

-(CoreDataHandler*)setUpCoreData;
- (void)saveContext;
@end
