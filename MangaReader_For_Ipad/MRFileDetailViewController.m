//
//  MRFileDetailViewController.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/14/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRFileDetailViewController.h"
#import "FileManager.h"

@interface MRFileDetailViewController()
@property NSURL* fileURL;
@end
@implementation MRFileDetailViewController

-(id)initWithFileURL:(NSURL*)url
{
    if(self=[super init])
    {
        _fileURL=url;
    }
    
    return self;
}

-(void)viewDidLoad
{
    //Default View
    UIView *view=[[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self setView:view];
}

-(void)configureDetailViewForItemAtURL:(NSURL*)url
{
    _fileURL=url;
    UIView *view=[[UIView alloc] init];
    self.title=[_fileURL lastPathComponent];
    
    if([[FileManager alloc] isValidArchiveFile:_fileURL])
    {
    }
    
    if([[FileManager alloc] isValidImageFile:_fileURL])
    {
        view=[self getViewForImageDetailOfImage:_fileURL];
    }
    
    [self setView:view];
}

-(UIView*)getViewForArchiveDetailOfArchive:(NSURL*)url
{
    //meta data's needed to be fetched from database
    
    
}

-(UIView*)getViewForImageDetailOfImage:(NSURL*)url
{
    UIImage *image=[[UIImage alloc] initWithContentsOfFile:[url path]];
    UIImageView* imageView=[[UIImageView alloc] initWithImage:image];
    
    UIView *view=[[UIView alloc] initWithFrame:self.view.frame];
    [view addSubview:imageView];
    //imageView.frame=CGRectMake(view.frame.origin.x,view.frame.origin.y+300,view.frame.size.width,400);
    imageView.contentMode=UIViewContentModeCenter;
    return view;
}
@end