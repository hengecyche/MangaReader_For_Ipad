//
//  MRFileDetailViewController.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/14/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRFileDetailViewController.h"
#import "FileManager.h"
#import "MRArchiveMetaDataParser.h"
#import "MRArchiveDetailView.h"

@interface MRFileDetailViewController()
@property NSURL* fileURL;
@property NSDictionary *archiveMeta;
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

-(UIView*)getCurrentView
{
    return [[UIView alloc] initWithFrame:[self getFrameIncludingNavBar]];
}

#pragma mark - Configure View For Particular File Type
-(void)configureDetailViewForItemAtURL:(NSURL*)url
{
    _fileURL=url;
    //[self.view setNeedsDisplay];
    self.title=[_fileURL lastPathComponent];
    
    if([[FileManager alloc] isValidArchiveFile:_fileURL])
    {
        [self getViewForArchiveDetailOfArchive:url];
        return;
    }
    
    if([[FileManager alloc] isValidImageFile:_fileURL])
    {
        [self setViewForImageDetailOfImage:_fileURL];
        return;
    }
    
    UIView *view=[self getCurrentView];
    [self setView:view];
}

-(void)getViewForArchiveDetailOfArchive:(NSURL*)url
{
    //meta data's needed to be fetched from database
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *meta=[[MRArchiveMetaDataParser alloc] getMetaDataOfArchiveWithURL:url];
        [self performSelectorOnMainThread:@selector(setViewForArchiveDetailWithMetaData:) withObject:meta waitUntilDone:NO];
    });

}

-(void)setViewForArchiveDetailWithMetaData:(NSDictionary*)meta
{
    NSEnumerator *enumerator=[meta keyEnumerator];
    NSString *key;
    NSMutableString *text=[[NSMutableString alloc] init];
    while(key=[enumerator nextObject])
    {
        NSString *string=[NSString stringWithFormat:@"%@: %@ \n",key,[meta objectForKey:key]];
        [text appendString:string];
    }
    
    MRArchiveDetailView *view=[[MRArchiveDetailView alloc] initWithFrame:[self getFrameIncludingNavBar]];

    MRArchiveManager *archiveMng=[[MRArchiveManager alloc] initWithArchive:_fileURL];
    
    view.archiveThumb=[UIImage imageWithContentsOfFile:[[archiveMng getThumbnailForArchive] path]];
    
    [archiveMng emptyTempDirectory];
    [view getView];
    //NSLog(@"%@",text);
    


    [self setView:view];
}


-(void)setViewForImageDetailOfImage:(NSURL*)url
{
    UIView *view=[self getCurrentView];
    
    UIImage *image=[[UIImage alloc] initWithContentsOfFile:[url path]];
    //NSLog(@"%fX%f",image.size.width,image.size.height);
    
    UIImageView* imageView=[[UIImageView alloc] initWithFrame:[view frame]];
    imageView.image=image;
    imageView.contentMode=UIViewContentModeScaleToFill;
    [imageView sizeToFit];
    [view addSubview:imageView];
    
    //imageView.frame=CGRectMake(view.frame.origin.x,view.frame.origin.y+300,view.frame.size.width,400);

    [self setView:view];
}

#pragma mark - Calculations
-(CGRect)getFrameIncludingNavBar
{
    CGFloat originY=[UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height;
    NSLog(@"originY:%f",originY);
    return CGRectMake(0,originY,self.view.frame.size.width,self.view.frame.size.height);
}

-(UIImage*)getThumbImage
{
    //first check database to see if there is thumbnail for the object at path otherwise get a new thumb and put that in database and return the value for view
    UIImage *aka;
    return aka;
}
@end