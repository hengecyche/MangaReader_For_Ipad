//
//  MRCoreData.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 4/9/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRCoreData.h"
#import "CoreDataHandler.h"
#import "MRAppDelegate.h"

@implementation MRCoreData

-(NSArray*)fetchDataFromEntityWithEntityName:(NSString*)entity
{
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:entity];
    NSArray *fetchData=[self.cdh.context executeFetchRequest:fetchRequest error:nil];
    return fetchData;
}



-(CoreDataHandler*)cdh
{
    MRAppDelegate *del=(MRAppDelegate*)[[UIApplication sharedApplication] delegate];
    return del.cdh;
}
@end
