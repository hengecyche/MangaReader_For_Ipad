//
//  ViewController.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 3/17/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRFileListTableViewController.h"
#import "MRArchiveManager.h"
#import "FileManager.h"
#import "MRDirectoryParser.h"
#import "MRFileListTableView.h"

@interface MRFileListTableViewController()
-(UITableView*)getTableViewForTableViewController;
@property NSArray *fileList;
@end

@implementation MRFileListTableViewController

-(id)init
{
    if(self=[super init])
    {
        _fileList=(NSArray*)[[MRDirectoryParser alloc] fetchFileListFromDocumentDirectory];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
    [self setTableView:[self getTableViewForTableViewController]];
    
    // Do any additional setup after loading the view, typically from a nib.

    
}

-(UITableView*)getTableViewForTableViewController
{
    UITableView *tableView=[[MRFileListTableView alloc] initForFileListTableView];
    
    tableView.dataSource=self;
    tableView.delegate=self;
    
    return tableView;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileListCell"];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileListCell"];
        cell.frame=CGRectMake(0,0,self.tableView.bounds.size.width,50);
        cell.backgroundColor=[UIColor blackColor];
        
    }
    
    NSURL *url=[_fileList objectAtIndex:indexPath.row];
    cell.textLabel.text=[url lastPathComponent];
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_fileList count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
