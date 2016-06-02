//
//  Header.h
//  MangaReader_For_Ipad
//
//  Created by hengecyche on 5/18/16.
//  Copyright © 2016 hengeCyche. All rights reserved.
//

#import "Constants.h"
#import <UIKit/UIKit.h>

@interface MRArchiveDetailView:UIView

@property (nonatomic) UIImage *archiveThumb;
@property (nonatomic) NSString *archiveName;
@property (nonatomic) NSString *archiveStatus;
@property (nonatomic) NSString *currentPage;
@property (nonatomic) NSString *totalPages;


-(MRArchiveDetailView*)getView;

@end
