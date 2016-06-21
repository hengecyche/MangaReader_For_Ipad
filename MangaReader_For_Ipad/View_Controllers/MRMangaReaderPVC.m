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

@interface MRMangaReaderPVC()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

//meta data
@property (nonatomic,retain) NSString *originalURL;
@property (nonatomic,retain) NSArray *imgFileList;
@property (nonatomic) NSString *fileType;

//core data
@property (nonatomic,retain) NSManagedObjectContext *coreContext;

//needed for view data
@property NSArray *imgVCList;
@property MRMangaReaderVC *currVC;
@property (nonatomic) int currIndex;
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
        
        _imgVCList=[self getVCsForAllImages];
        
        _currIndex=0;
    }
    
    return self;
}

-(void)viewDidLoad
{
    self.dataSource=self;
    self.delegate=self;
    
    //self.navigationController.toolbar.items=[self getThumbnailOfAllImages];
    [self.navigationController setToolbarHidden:NO animated:NO];

    
    NSLog(@"%@",_imgVCList);
    int index=0;
    if([_fileType isEqual:@"IMAGE_FILE"])
    {
        index=(int)[_imgFileList indexOfObject:_originalURL];
    }
    [self setViewControllers:@[[_imgVCList objectAtIndex:index]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:^(BOOL finished){
                      //if(finished) NSLog(@"Hello World We Are Done Animating");
                  }
     ];
    
    
    /*UISwipeGestureRecognizer *swipeRec=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRec.numberOfTouchesRequired=1;
    [self.view addGestureRecognizer:swipeRec];*/
    
    UITapGestureRecognizer *gesRec=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    gesRec.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:gesRec];
    
}

#pragma mark - MRMangaReaderVC getters
-(NSArray*)getVCsForAllImages
{
    NSMutableArray *vcList=[[NSMutableArray alloc] init];
    
    for(NSURL *imgURL in _imgFileList)
    {
        MRMangaReaderVC *vc=[[MRMangaReaderVC alloc] initWithURL:imgURL];
        [vcList addObject:vc];
    }
    return [NSArray arrayWithArray:vcList];
}

#pragma mark- DATASOURCE METHODS
- (MRMangaReaderVC *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(MRMangaReaderVC *)viewController
{
    int index=(int)[_imgVCList indexOfObject:viewController];
    index-=1;
    if(index<0) return nil;
    return [_imgVCList objectAtIndex:index];
}

- (MRMangaReaderVC *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(MRMangaReaderVC *)viewController
{
    int index=(int)[_imgVCList indexOfObject:viewController];
    index+=1;
    if(index>=[_imgVCList count]) return nil;
    return [_imgVCList objectAtIndex:index];
}

#pragma mark - DELEGATE METHODS
- (void)pageViewController:(MRMangaReaderPVC *)pageViewController willTransitionToViewControllers:(NSArray<MRMangaReaderVC *> *)pendingViewControllers
{
}


- (void)pageViewController:(MRMangaReaderPVC *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<MRMangaReaderVC *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    //Need Code For CoreData handling
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
        }else
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.navigationController setToolbarHidden:YES animated:YES];
        }
    }
}


#pragma mark - Core Data

@end