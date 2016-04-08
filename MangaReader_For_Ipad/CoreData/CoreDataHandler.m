//
//  CoreDataHandler.m
//  LNReader
//
//  Created by hengecyche on 1/21/16.
//  Copyright © 2016 Animeout. All rights reserved.
//

#import "CoreDataHandler.h"
#import "FilePathURL.h"

@implementation CoreDataHandler
#define modelName "MangaReader"

#pragma mark - Core Data Initialization
-(id)init
{
    
    self=[super init];
    if(self)
    {
        _model=[self managedObjectModel];
        _coordinator=[self persistentStoreCoordinator];
        _context=[self managedObjectContext];
        self=[self setUpCoreData];
    }
    return self;
}

-(void)loadStore
{
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(CoreDataHandler*)setUpCoreData
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        [self loadStore];
    });
    return self;
}

#pragma mark - Database Path


-(NSURL*)storeURL
{
    NSString *url=[NSString stringWithFormat:@"%s.%s",modelName,"sqlite"];
    return [[FilePathURL databaseDirectory] URLByAppendingPathComponent:url];
}

#pragma mark - Core Data Components
- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_model != nil) {
        return _model;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%s",modelName] withExtension:@"momd"];
    _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _model;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_coordinator != nil) {
        return _coordinator;
    }
    
    // Create the coordinator and store
    
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    
    return _coordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_context != nil) {
        return _context;
    }
    
    if (!_coordinator) {
        return nil;
    }
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setPersistentStoreCoordinator:_coordinator];
    return _context;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    if([_context hasChanges])
    {
        NSError* error=nil;
        if([_context save:&error]){NSLog(@"_context SAVED changes to persistent store");}
        else
        {
            NSLog(@"Failed to save Context: Error:%@",error);
            //need to add alert msg controller
        }
    }else NSLog(@"Skipped _context save, there are no changes");
}

@end