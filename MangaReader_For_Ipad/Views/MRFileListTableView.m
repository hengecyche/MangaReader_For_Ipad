//
//  MRFileListTableView.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 4/29/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRFileListTableView.h"

@interface MRFileListTableView()

@end

@implementation MRFileListTableView

-(id)initForFileListTableView
{
    if(self=[super init])
    {
        self=(MRFileListTableView*)[self configureTableView];
    }
    return self;
}

-(UITableView*)configureTableView
{
    UITableView *tableView=[[UITableView alloc] init];
    tableView.contentMode=UIViewContentModeBottom;
    
    tableView.backgroundColor=[UIColor whiteColor];
    return tableView;
}

@end
