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
        //self=(MRFileListTableView*)[self configureTableView];
    }
    return self;
}

-(UITableView*)configureTableView
{
    UIScreen *screen=[UIScreen mainScreen];
    NSLog(@"\n Height:%f \n Width:%f ",screen.bounds.size.height,screen.bounds.size.width);
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    tableView.contentMode=UIViewContentModeScaleToFill;
    
    tableView.backgroundColor=[UIColor blackColor];
    tableView.tableHeaderView=[self getHeaderViewForTableView];
    //tableView.tableFooterView=[self getFooterViewForTableView];
    return tableView;
}

-(UIView*)getHeaderViewForTableView
{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
    
    headerView.backgroundColor=[UIColor blackColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = headerView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [headerView.layer insertSublayer:gradient atIndex:0];
    
    headerView.contentMode=UIViewContentModeScaleToFill;
    return headerView;
}

-(UIView*)getFooterViewForTableView
{
    UIView *footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 50)];
    [footerView setBackgroundColor:[UIColor blackColor]];
    footerView.contentMode=UIViewContentModeScaleToFill;
    return footerView;
}
@end
