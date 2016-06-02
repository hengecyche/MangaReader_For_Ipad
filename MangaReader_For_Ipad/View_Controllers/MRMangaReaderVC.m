//
//  MRMangaReaderVC.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 6/2/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRMangaReaderVC.h"
#import "FileManager.h"
#import "MRMangaReaderView.h"

@interface MRMangaReaderVC()

@property (nonatomic,retain) NSString *originalURL;
@property (nonatomic,retain) NSArray *imgFileList;
@property (nonatomic) NSString *fileType;
@end

@implementation MRMangaReaderVC
-(id)initWithMetaData:(NSDictionary*)metaData
{
    if(self=[super init])
    {
        _originalURL=[metaData objectForKey:@"ORIGINAL_FILE_URL"];
        _imgFileList=[metaData objectForKey:@"MANGA_IMAGE_LIST"];
        _fileType=[metaData valueForKey:@"FILE_TYPE"];
        self.title=[metaData valueForKey:@"FILE_NAME"];
    }
    
    return self;
}

-(void)viewDidLoad
{
    NSURL *url=[_imgFileList objectAtIndex:0];
    NSLog(@"%@",url);
    UIImage *img=[UIImage imageWithContentsOfFile:[url path]];
    
    
    MRMangaReaderView *mangaRdr=[[MRMangaReaderView alloc] initWithFrame:self.view.bounds];
    mangaRdr.userInteractionEnabled=YES;
    mangaRdr.multipleTouchEnabled=YES;
    mangaRdr.scrollEnabled=YES;
    mangaRdr.contentSize=CGSizeMake(img.size.width,img.size.height);
    
    mangaRdr.mainImage.image=img;
    
    UITapGestureRecognizer *gesRec=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    gesRec.numberOfTapsRequired=2;
    
    [self.view addSubview:mangaRdr];
    
    [self.view addGestureRecognizer:gesRec];
    /*UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.scrollEnabled=true;
    scrollView.backgroundColor=[UIColor whiteColor];
    scrollView.bounces=NO;
    scrollView.minimumZoomScale=1.0;
    scrollView.maximumZoomScale=16.0;
    [self.view addSubview:scrollView];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue,^{
        float x=0,y=20;
        for(NSURL *url in _imgFileList)
        {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(x,y,self.view.bounds.size.width,20)];
            label.text=[url lastPathComponent];
            label.textColor=[UIColor blackColor];
            y+=20;
            [scrollView addSubview:label];
            
            UIImageView *mangaView=[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[url path]]];
            mangaView.contentMode=UIViewContentModeScaleAspectFit;
            [mangaView setFrame:CGRectMake(x,y,self.view.bounds.size.width,400)];
            y+=mangaView.frame.size.height;
            
            [scrollView addSubview:mangaView];
        }
        scrollView.contentSize=CGSizeMake(self.view.bounds.size.width,y);
    });*/
}

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

@end