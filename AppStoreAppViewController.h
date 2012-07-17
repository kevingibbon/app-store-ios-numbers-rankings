//
//  AppStoreAppViewController.h
//  AppStoreRanking
//
//  Created by Kevin Gibbon on 12-07-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AppStoreObject: NSObject <NSCoding>
@property (strong) NSString *name;
@property (strong) NSString *category;
@property (strong) NSNumber *price;
@property (strong) NSNumber *numberReviews;
@property (strong) NSNumber *rating;
@property (strong) NSDate *lastUpdated;
@property (strong) NSString *url;
@property (strong) NSString *type;
@end

@interface AppStoreAppViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *items;
    NSInteger numThreads;
    NSMutableArray *urls;
    NSInteger page;
    CGFloat lastScrollPosition;
    BOOL isRefreshingNewPage;
    PFQuery *appStoreParseQuery;
}
@property (weak, nonatomic) IBOutlet UITableView *appStoreTableView;
- (id)initWithFilter:(NSString *)ranking:(NSString *)price:(NSString*)lastUpdated;
- (id)initWithKeyword:(NSString *)keyword;
- (void)addAppStoreItemData:(NSMutableData*)data:(AppStoreObject*)appStoreObject;


@end



