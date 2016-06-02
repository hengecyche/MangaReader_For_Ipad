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
#import "MRFileDetailViewController.h"

@interface MRFileListTableViewController()
-(UITableView*)getTableViewForTableViewController;
@property NSArray *fileList;
@end

@implementation MRFileListTableViewController

#pragma mark - Initializers
-(id)init
{
    if(self=[super init])
    {
        _fileList=(NSArray*)[[MRDirectoryParser alloc] fetchFileListFromDocumentDirectory];
            self.title=@"Root Directory";
    }
    return self;
}

-(id)initWithURL:(NSURL*)url
{
    if(self=[super init])
    {
        _fileList=(NSArray*)[[MRDirectoryParser alloc] getFileListFromDirectoryWithURL:url];
        self.title=[url lastPathComponent];
    }
    
    return self;
}

#pragma mark - Configuring Table View
- (void)viewDidLoad {
    [super viewDidLoad];
    self.splitViewController.delegate=self;
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
        
    }
    
    NSURL *url=[_fileList objectAtIndex:indexPath.row];
    cell.textLabel.text=[url lastPathComponent];
    cell.textLabel.textColor=[UIColor blackColor];
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


#pragma mark - Delegate
-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSURL* url=[_fileList objectAtIndex:indexPath.row];
    
    if([[FileManager alloc] isDirectory:url])
    {
        MRFileListTableViewController *viewController=[[MRFileListTableViewController alloc] initWithURL:url];
        [self.navigationController pushViewController:viewController animated:YES];
    }else
    {
    
        //NSLog(@"%@",[url lastPathComponent]);
        UINavigationController *nav=self.splitViewController.viewControllers[1];
        MRFileDetailViewController *detailView=(MRFileDetailViewController*)nav.topViewController;

        [detailView configureDetailViewForItemAtURL:url];
        [detailView.view setNeedsDisplay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
