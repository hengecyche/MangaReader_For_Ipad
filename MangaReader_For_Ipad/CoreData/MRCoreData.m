//
//  MRCoreData.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 4/9/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRCoreData.h"
#import "Constants.h"
#import "CoreDataHandler.h"
#import "MRAppDelegate.h"

@implementation MRCoreData

-(NSArray*)fetchDataFromEntityWithEntityName:(NSString*)entity
{
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:ENTITY_FILE];
    
    self.cdh.context;
}

-(CoreDataHandler*)cdh
{
    MRAppDelegate *del=(MRAppDelegate*)[[UIApplication sharedApplication] delegate];
    return del.cdh;
}
@end
