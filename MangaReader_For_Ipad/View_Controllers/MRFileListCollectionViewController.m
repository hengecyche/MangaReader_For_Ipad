//
//  MRFileListCollectionViewController.m
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/23/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "MRFileListCollectionViewController.h"
#import "MRFileListCollectionViewCell.h"
#import "MRImageListProcessor.h"
#import "MRMangaReaderPVC.h"

#import "MRDirectoryParser.h"
#import "FileManager.h"
#import "FilePathURL.h"
#import "MRArchiveManager.h"

#import "HCAlertController.h"





@interface MRFileListCollectionViewController()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property (nonatomic,retain) NSArray *fileList;
@end
@implementation MRFileListCollectionViewController

#pragma mark - Initializers
-(id)initWithURL:(NSURL*)url
{
    if(self=[super init])
    {
        self=(MRFileListCollectionViewController*)[[MRFileListCollectionViewController alloc] initWithCollectionViewLayout:[self collectionViewLayout]];
        [self.collectionView registerClass:[MRFileListCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
        
        _fileList=[[MRDirectoryParser alloc] getFileListFromDirectoryWithURL:url];
        self.title=@"File List";

        
        
    }
    return self;
}

#pragma mark - View Control Methods
-(void)viewDidLoad
{
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];

}

#pragma mark - Datasource Methods
-(NSInteger)collectionView:(UICollectionView*)view numberOfItemsInSection:(NSInteger)section
{
    return [_fileList count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView*)view cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSURL *file=[_fileList objectAtIndex:indexPath.row];
    
    MRFileListCollectionViewCell *cell=[self.collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    
    FileManager *fileManager=[[FileManager alloc] init];
    
    cell.textLabel.text=[file lastPathComponent];
    
    if([fileManager isDirectory:file])
    {
        cell.imageView.image=[UIImage imageNamed:@"directory_icon"];
    }

    if([fileManager isValidImageFile:file])
    {
        cell.imageView.image=[UIImage imageWithContentsOfFile:[file path]];
    }
    
    if([fileManager isValidArchiveFile:file])
    {
        cell.imageView.image=[UIImage imageNamed:@"archive_icon"];
        
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue,^{
            NSURL *thumbURL=[self getThumbnailOfArchiveWithURL:file];
            if(!(thumbURL==nil))
            {
                cell.imageView.image=[UIImage imageWithContentsOfFile:[thumbURL path]];
            }
        });
    }
    
    return cell;
}

#pragma mark - Delegate Methods
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *fileURL=[_fileList objectAtIndex:indexPath.row];
    
    FileManager *fileManager=[[FileManager alloc] init];
    

    if([fileManager isDirectory:fileURL])
    {
        MRFileListCollectionViewController *nextView=[[MRFileListCollectionViewController alloc] initWithURL:fileURL];
        [self.navigationController pushViewController:nextView animated:YES];
    }
    
    if([fileManager isValidImageFile:fileURL] || [fileManager isValidArchiveFile:fileURL])
    {
        [self handleTransitionToMangaViewerWithURL:fileURL];
    }
}


#pragma mark - Manga Viewer Transition Methods

-(void)handleTransitionToMangaViewerWithURL:(NSURL*)fileURL
{
    //activity Indicator before transition begins
    UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setFrame:self.view.bounds];
    [self.view addSubview:activity];
    [self.view bringSubviewToFront:activity];
    
    [activity startAnimating];
    activity.hidesWhenStopped=YES;
    
    //setting up meta data before transition begins
    
    
    dispatch_queue_t transitionQueue;
    transitionQueue = dispatch_queue_create("com.mangareader.transitionQueue", NULL);
    
    dispatch_async(transitionQueue,^{
        //image_MangaList
        MRImageListProcessor *imgListProcessor=[[MRImageListProcessor alloc] initWithURL:fileURL];
        NSArray *mangaImageList=[imgListProcessor getMangaImageList];
        //check to see if the archive has any image files
        if([mangaImageList count]==0)
        {
            HCAlertController *alertCon=[HCAlertController alertWithTitle:@"No Images"
                                                                  message:@"App Couldn't Find Any Image In The Archive!!!"];
            [self presentViewController:alertCon animated:YES
                             completion:^(){
                                 //[activity stopAnimating];
                                 //return;
                             }
             ];
            [activity stopAnimating];
            return;
        }
        
        NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
        
        //file_NAME
        [tempDict setObject:[fileURL lastPathComponent] forKey:@"FILE_NAME"];
        [tempDict setObject:fileURL forKey:@"ORIGINAL_FILE_URL"];
        
        [tempDict setObject:mangaImageList forKey:@"MANGA_IMAGE_LIST"];
        
        //get CoreData And Other Info If File Is Archive
        if([[FileManager alloc] isValidArchiveFile:fileURL])
        {
            [tempDict setObject:@"ARCHIVE_FILE" forKey:@"FILE_TYPE"];
        }
        
        if([[FileManager alloc] isValidImageFile:fileURL])
        {
            [tempDict setObject:@"IMAGE_FILE" forKey:@"FILE_TYPE"];
        }
        
        NSDictionary *dictData=[NSDictionary dictionaryWithDictionary:tempDict];
        
        MRMangaReaderPVC *mReaderPVC=[[MRMangaReaderPVC alloc] initWithMetaData:dictData];
        

        dispatch_async(dispatch_get_main_queue(),^{
            [activity stopAnimating];
            [self transitionToMangaViewer:mReaderPVC];
        });
    });

}

-(void)transitionToMangaViewer:(MRMangaReaderPVC*)mReaderPVC
{
    [self.navigationController pushViewController:mReaderPVC animated:YES];
}

#pragma mark - Utility Methods
- (UICollectionViewLayout *)collectionViewLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(130,130);
    return layout;
}

#pragma mark - Thumbnail Methods
-(NSURL*)getThumbnailOfArchiveWithURL:(NSURL*)url
{
    NSFileManager *manager=[NSFileManager defaultManager];
    
    
    NSString *thumbName=[[FileManager alloc] getValidThumbNameOfArchive:url];
    
    NSURL *destination=[[FilePathURL thumbDirectory] URLByAppendingPathComponent:thumbName];
    
    //if file is in thumb directory return it
    if([manager fileExistsAtPath:[destination path]])
    {
        return destination;
    }
    
    //else get thumbnail from archive directly and copy to thumbDirectory
    MRArchiveManager *archiveMng=[[MRArchiveManager alloc] initWithArchive:url];
   
    NSURL *thumbURL=[archiveMng getThumbnailForArchive];
   
    
    NSError *error;
    
    if(![manager copyItemAtURL:thumbURL toURL:destination error:&error])
    {
        NSLog(@"Error Code: %ld \n Error Description:%@",(long)error.code,error.localizedDescription);
        return nil;
    }
    return destination;
}

@end
