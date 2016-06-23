//
//  MRMangaReaderVC.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 6/2/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRMangaReaderPVC.h"
#import "FileManager.h"
#import "MRMangaReaderVC.h"
#import "Constants.h"
#import "Archive_Meta.h"
#import "CoreDataHandler.h"
#import "MRAppDelegate.h"


static NSString *ENTITY_NAME = @"Archive_Meta";
@interface MRMangaReaderPVC()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIContentContainer,UITraitEnvironment>

//meta data
@property (nonatomic,retain) NSURL *originalURL;
@property (nonatomic,retain) NSArray *imgFileList;
@property (nonatomic) NSString *fileType;

//core data
@property (nonatomic,retain) CoreDataHandler *cdh;
@property (nonatomic,retain) Archive_Meta *currModel;

//needed for view data
@property NSMutableArray *imgVCList;
@property MRMangaReaderVC *currVC;

@property int currIndex;

@end

@implementation MRMangaReaderPVC
-(id)initWithMetaData:(NSDictionary*)metaData
{
    if(self=[super init])
    {
        NSDictionary *options=[NSDictionary dictionaryWithObject:UIPageViewControllerOptionInterPageSpacingKey
                                                           forKey:[NSNumber numberWithFloat:10]];
         
        
        self=[self initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                             navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                           options:options];
        
        _originalURL=[metaData objectForKey:@"ORIGINAL_FILE_URL"];
        _imgFileList=[metaData objectForKey:@"MANGA_IMAGE_LIST"];
        _fileType=[metaData valueForKey:@"FILE_TYPE"];
        self.title=[metaData valueForKey:@"FILE_NAME"];
        
        _imgVCList=[[NSMutableArray alloc] init];
        
        //core data
        if([_fileType isEqual:@"ARCHIVE_FILE"])
        {
            _cdh=[(MRAppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
            [self loadCurrentArchiveMeta];
            
            _currModel.lastAccessedDate=[NSDate date];
        }
        
    }
    
    return self;
}

-(void)viewDidLoad
{
    self.dataSource=self;
    self.delegate=self;
    
    //self.navigationController.toolbar.items=[self getThumbnailOfAllImages];
    [self.navigationController setToolbarHidden:NO animated:NO];

    
    //determining current page to start From
    if([_fileType isEqual:@"IMAGE_FILE"])
    {
        _currIndex=(int)[_imgFileList indexOfObject:_originalURL];
    }
    if([_fileType isEqual:@"ARCHIVE_FILE"])
    {
        _currIndex=[_currModel.currentPage intValue];
    }
    
    
    _currVC=[self getVCForImageAtIndex:_currIndex];
    [self setViewControllers:@[_currVC]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:^(BOOL finished){
                      //if(finished) NSLog(@"Hello World We Are Done Animating");
                  }
     ];
    
    
    /*UISwipeGestureRecognizer *swipeRec=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRec.numberOfTouchesRequired=1;
    [self.view addGestureRecognizer:swipeRec];*/
    
    //tap gesture for hidding/unhidding nav bar
    UITapGestureRecognizer *gesRec=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    gesRec.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:gesRec];
    
}

#pragma mark - MRMangaReaderVC getters
-(MRMangaReaderVC*)getVCForImageAtIndex:(int)index
{
    return [[MRMangaReaderVC alloc] initWithURL:[_imgFileList objectAtIndex:index]];
}

#pragma mark- DATASOURCE METHODS
- (MRMangaReaderVC *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(MRMangaReaderVC *)viewController
{
    
    //int index=(int)[_imgVCList indexOfObject:viewController];
    int index=_currIndex;
    index-=1;
    if(index<0) return nil;

    return [self getVCForImageAtIndex:index];
}


- (MRMangaReaderVC *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(MRMangaReaderVC *)viewController
{
    //int index=(int)[_imgVCList indexOfObject:viewController];
    int index=_currIndex;
    index+=1;
    if(index>=[_imgFileList count]) return nil;
    
    return [self getVCForImageAtIndex:index];
}

#pragma mark - DELEGATE METHODS
- (void)pageViewController:(MRMangaReaderPVC *)pageViewController willTransitionToViewControllers:(NSArray<MRMangaReaderVC *> *)pendingViewControllers
{
    _currVC=[pendingViewControllers lastObject];
    _currIndex=(int)[_imgFileList indexOfObject:_currVC.imgURL];
}


- (void)pageViewController:(MRMangaReaderVC *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<MRMangaReaderVC *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        if([_fileType isEqual:@"IMAGE_FILE"])
        {
            [self setTitleForImage];
        }
        
        //remembering current page
        _currModel.currentPage=[NSNumber numberWithInt:_currIndex];
        
        int index=_currIndex+1;
        
        //add to complete list when index reaches last page;
        if([_imgFileList count]==index)
        {
            ARCHIVE_STATUS status=COMPLETED;
            _currModel.archiveStatus=[NSNumber numberWithInt:status];
        }
        [_cdh saveContext];
    }
}

-(void)setTitleForImage
{
    NSURL *img=[_imgFileList objectAtIndex:_currIndex];
    if([[FileManager alloc] isValidImageFile:img])
    {
        self.title=img.lastPathComponent;
    }
}
#pragma mark - Tool Bar Method
/*
-(NSArray*)getThumbnailOfAllImages
{
    NSMutableArray *thumbList=[[NSMutableArray alloc] init];
    for(NSURL *img in _imgFileList)
    {
            UIImage *image=[UIImage imageWithContentsOfFile:[img path]];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0,0,44,44)];
            [button setImage:image forState:UIControlStateNormal];
            button.contentMode=UIViewContentModeScaleToFill;
            UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:button];
            item.target=self;
            item.action=@selector(handleToolbarButtonSelection:);
            item.title=[NSString stringWithFormat:@"Page %lu",(unsigned long)[_imgFileList indexOfObject:img]];
            [thumbList addObject:item];
    }
    return [NSArray arrayWithArray:thumbList];
}

-(void)handleToolbarButtonSelection:(UIBarButtonItem*)item
{
    NSLog(@"%@",item.title);
}*/

#pragma mark - Gesture Handlers
-(void)handleTap:(UITapGestureRecognizer*)sender
{
    if(sender.state==UIGestureRecognizerStateEnded)
    {
        
        if(self.navigationController.navigationBar.hidden)
        {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.navigationController setToolbarHidden:NO animated:YES];
            [self reloadView];
        }else
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.navigationController setToolbarHidden:YES animated:YES];
            [self reloadView];
        }
    }
}


#pragma mark - Core Data
-(void)loadCurrentArchiveMeta
{
    NSFetchRequest *fetchReq=[NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
    
    //predicate
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"archiveURL=%@",[_originalURL absoluteString]];
    [fetchReq setPredicate:predicate];
    
    //limit
    [fetchReq setFetchLimit:1];
    
    //
    NSError *error=nil;
    NSArray *fetchedResult=[_cdh.context executeFetchRequest:fetchReq error:&error];
    if(error)
    {
        NSLog(@"\n Error Code: %ld \n Error Description:%@",error.code,error.localizedDescription);
    }
    
    /*for(Archive_Meta *meta in fetchResult)
    {
        [_cdh.context deleteObject:meta];
    }*/
    
    if([fetchedResult count]==0)
    {
        [self addArchiveInDatabase];
        return;
    }
    
    _currModel=[fetchedResult objectAtIndex:0];
    
}

-(void)addArchiveInDatabase
{
    Archive_Meta *arcmeta=[NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:_cdh.context];
    
    /*@property (nullable, nonatomic, retain) NSString *archiveURL;
     @property (nullable, nonatomic, retain) NSNumber *archiveStatus;
     @property (nullable, nonatomic, retain) NSString *archiveType;
     @property (nullable, nonatomic, retain) NSNumber *currentPage;
     @property (nullable, nonatomic, retain) NSNumber *isManga;
     @property (nullable, nonatomic, retain) NSDate *lastAccessedDate;
     @property (nullable, nonatomic, retain) NSNumber *numberOfImagesInArchive;*/
    
    //archiveURL
    arcmeta.archiveURL=[_originalURL absoluteString];
    
    //archiveStatus
    ARCHIVE_STATUS status=READING;
    arcmeta.archiveStatus=[NSNumber numberWithInt:status];
    
    //archiveType
    NSString *type=[[[_originalURL path] pathExtension] lowercaseString];
    if([@"zip,cbz" containsString:type])
    {
        arcmeta.archiveType=@"ZIP";
    }
    
    if([@"rar,cbr" containsString:type])
    {
        arcmeta.archiveType=@"RAR";
    }
    
    //currentPage will be 0 since first open
    arcmeta.currentPage=[NSNumber numberWithInt:0];
    
    //isManga
    arcmeta.isManga=[NSNumber numberWithBool:YES];
    
    //lastAccessedDate
    arcmeta.lastAccessedDate=[NSDate date];
    
    //number of Images In Archive
    arcmeta.numberOfImagesInArchive=[NSNumber numberWithDouble:(double)[_imgFileList count]];
    
    [_cdh saveContext];
    [self loadCurrentArchiveMeta];
}



#pragma mark - Orientation Delegates

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //changes frame of all VC
        [self reloadView];
    }];
}

-(void)reloadView
{
    MRMangaReaderVC *vc=[[MRMangaReaderVC alloc] initWithURL:[_imgFileList objectAtIndex:_currIndex]];
    [self setViewControllers:@[vc]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:^(BOOL finished){
                      //if(finished) NSLog(@"Hello World We Are Done Animating");
                  }
     ];
}
@end
