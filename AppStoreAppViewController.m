//
//  AppStoreAppViewController.m
//  AppStoreRanking
//
//  Created by Kevin Gibbon on 12-07-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppStoreAppViewController.h"
#import "SCNetworkRequest.h"
#import "AppStoreSelectionTableViewController.h"

@implementation AppStoreObject
@synthesize name;
@synthesize category;
@synthesize price;
@synthesize numberReviews;
@synthesize rating;
@synthesize lastUpdated;
@synthesize url;
@synthesize type;

-(void)encodeWithCoder:(NSCoder*)coder
{
	[coder encodeObject:name];
    [coder encodeObject:price];
    [coder encodeObject:numberReviews];
    [coder encodeObject:rating];
    [coder encodeObject:lastUpdated];
    [coder encodeObject:url];
    [coder encodeObject:type];
    [coder encodeObject:category];
}

-(id)initWithCoder:(NSCoder*)coder
{
	if (self=[super init]) {
		[self setName:[coder decodeObject]];
        [self setPrice:[coder decodeObject]];
        [self setNumberReviews:[coder decodeObject]];
        [self setRating:[coder decodeObject]];
        [self setLastUpdated:[coder decodeObject]];
        [self setUrl:[coder decodeObject]];
        [self setType:[coder decodeObject]];
        [self setCategory:[coder decodeObject]];
	}
	return self;
}
@end

@interface AppStoreAppViewController ()

@end

@implementation AppStoreAppViewController 

@synthesize appStoreTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFilter:(NSString *)ranking:(NSString *)price:(NSString*)lastUpdated
{
    self = [super init];
    if (self) {
        self.title = [NSString stringWithFormat:@"%@ %@ %@", ranking, price, lastUpdated];
        appStoreParseQuery = [PFQuery queryWithClassName:@"AppStoreApp"];
        if ([ranking isEqualToString:BELOW_2_STARS])
        {
            [appStoreParseQuery whereKey:@"rating" lessThan:[NSNumber numberWithInt:2]];
        }
        else if ([ranking isEqualToString:BELOW_3_STARS])
        {
            [appStoreParseQuery whereKey:@"rating" lessThan:[NSNumber numberWithInt:3]];
        }
        else if ([ranking isEqualToString:BELOW_4_STARS])
        {
            [appStoreParseQuery whereKey:@"rating" lessThan:[NSNumber numberWithInt:4]];
        }
        else if ([ranking isEqualToString:BELOW_5_STARS])
        {
            [appStoreParseQuery whereKey:@"rating" lessThan:[NSNumber numberWithInt:5]];
        }
        else if ([ranking isEqualToString:ONLY_5_STARS])
        {
            [appStoreParseQuery whereKey:@"rating" equalTo:[NSNumber numberWithInt:5]];
        }
        if ([price isEqualToString:ONLY_PAID])
        {
            [appStoreParseQuery whereKey:@"type" equalTo:@"P"];
        }
        else if ([price isEqualToString:ONLY_FREE])
        {
            [appStoreParseQuery whereKey:@"type" equalTo:@"F"];
        }
        else if ([price isEqualToString:ABOVE_4_99])
        {
            [appStoreParseQuery whereKey:@"type" equalTo:@"P"];
            [appStoreParseQuery whereKey:@"price" greaterThan:[NSNumber numberWithFloat:4.99]];
        }
        if ([lastUpdated isEqualToString:OVER_6_MONTHS])
        {
            static NSInteger doNotIncludeSince = 60*60*24*7*26; // 26 week
            NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-doNotIncludeSince];
            [appStoreParseQuery whereKey:@"lastUpdated" lessThan:expirationDate];
        }
        else if ([lastUpdated isEqualToString:OVER_1_YEAR])
        {
            static NSInteger doNotIncludeSince = 60*60*24*7*52; // 52 week
            NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-doNotIncludeSince];
            [appStoreParseQuery whereKey:@"lastUpdated" lessThan:expirationDate];
        }
        else if ([lastUpdated isEqualToString:OVER_2_YEARS])
        {
            static NSInteger doNotIncludeSince = 60*60*24*7*104; // 104 week
            NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-doNotIncludeSince];
            [appStoreParseQuery whereKey:@"lastUpdated" lessThan:expirationDate];
        }
        [appStoreParseQuery orderByDescending:@"estimatedRevenue"];
        [appStoreParseQuery whereKey:@"category" notEqualTo:@"Games"];
    }
    return self;
}

- (id)initWithKeyword:(NSString *)keyword
{
    self = [super init];
    if (self) {
        self.title = [NSString stringWithFormat:@"\"%@\"", keyword];
        appStoreParseQuery = nil;
    }
    return self;
}

-(NSString*) getdFileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"6.dat"]];
	return fileName;
}

-(NSArray*) retrieveAppStoreObjects {
	NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getdFileName]];
	return array;
}

-(void) addAppStoreObject: (AppStoreObject*)appStoreObject {
	if ([self retrieveAppStoreObject:appStoreObject] == nil)
	{
		NSMutableArray *existingArray = [[self retrieveAppStoreObjects] mutableCopy];
		if (existingArray == nil) {
			existingArray = [[NSMutableArray alloc] init];
		}
		[existingArray addObject:appStoreObject];
		[NSKeyedArchiver archiveRootObject:existingArray toFile:[self getdFileName]];
	}
}

-(void) saveAppStoreArray: (NSMutableArray*)appStoreArray {
    [NSKeyedArchiver archiveRootObject:appStoreArray toFile:[self getdFileName]];
}

-(AppStoreObject*)retrieveAppStoreObject: (AppStoreObject*)appStoreObject {
	NSArray *existingArray = [self retrieveAppStoreObjects];	
	
	for (id element in existingArray)
    {
		AppStoreObject* appStoreInArray = element;
		if ([appStoreInArray.name isEqualToString:appStoreObject.name])
		{
			return appStoreInArray;
		}
	}
	return nil;
}

-(NSInteger)numberDownloadsPerReview
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:@"numreviewtodownloads"];
}

- (void)addAppStoreItemData:(NSMutableData*)data:(AppStoreObject*)appStoreObject
{
    NSMutableData *dataReturn = (NSMutableData*) data;
    NSString *dataString = [[NSString alloc] initWithData:dataReturn encoding:NSASCIIStringEncoding];
    
    NSString *date = [self retrieveValue:dataString :@"<span class=\"label\">Updated: </span>" :@"</li>"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMMdd','yyyy"];
    NSDate *myDate = [df dateFromString: [date stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [appStoreObject setLastUpdated:myDate];
    if (myDate == nil)
    {
        NSString *date = [self retrieveValue:dataString :@"<span class=\"label\">Released: </span>" :@"</li>"];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMMdd','yyyy"];
        NSDate *myDate = [df dateFromString: [date stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [appStoreObject setLastUpdated:myDate];
    }
    
    
    NSString *ratings = [self retrieveValue:dataString :@"<div>All Versions:</div>\n    <div class=\'rating\' role=\'img\' tabindex=\'-1\' aria-label=\'" :@"\'><div>"];
    
    NSArray *parts = [ratings componentsSeparatedByString:@", "];
    if ([parts count] == 2)
    {   
        NSString *ratingPart = [parts objectAtIndex:0];
        ratingPart = [ratingPart substringWithRange:NSMakeRange(0, 1)];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [appStoreObject setRating:[f numberFromString:ratingPart]];
        [appStoreObject setNumberReviews:[f numberFromString:[[[parts lastObject] componentsSeparatedByString:@" "]objectAtIndex:0]]];
    }
    
    if (appStoreObject.numberReviews == nil)
    {
        NSString *ratings = [self retrieveValue:dataString :@"<div>Current Version:</div>\n  <div class='rating' role='img' tabindex='-1' aria-label='" :@"'><div>"];
        
        NSArray *parts = [ratings componentsSeparatedByString:@", "];
        if ([parts count] == 2)
        {   
            NSString *ratingPart = [parts objectAtIndex:0];
            ratingPart = [ratingPart substringWithRange:NSMakeRange(0, 1)];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            [appStoreObject setRating:[f numberFromString:ratingPart]];
            [appStoreObject setNumberReviews:[f numberFromString:[[[parts lastObject] componentsSeparatedByString:@" "]objectAtIndex:0]]];
        }
    }
    
    if (appStoreObject.rating != nil && appStoreObject.numberReviews != nil && appStoreObject.lastUpdated != nil)
    {
        if (appStoreObject.price == nil || [appStoreObject.price isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            [appStoreObject setType:@"F"];
        }
        else {
            [appStoreObject setType:@"P"];
        }
        if (appStoreObject.price == nil)
        {
            appStoreObject.price = [NSNumber numberWithInt:0];
        }
        [items addObject:appStoreObject];
    }
    if (appStoreParseQuery)
    {
        numThreads --;
        if (numThreads == 0)
        {
            [urls removeLastObject];
            if ([urls count] == 0)
            {
                [self saveAppStoreArray:items];
                [self saveToParse];
            }
            else {
                [self processUrl:[urls lastObject]];
            }
        }
    }
    else {
        [appStoreTableView reloadData];
    }
}

- (void)processUrl:(NSString*)url
{
    SCNetworkRequestDefaults *defaults = [[SCNetworkRequestDefaults alloc] init];
    [defaults setBaseURL:@"http://itunes.apple.com"];
    SCNetworkRequest *request = [[SCNetworkRequest alloc] initWithURL:url defaults:defaults method:SCNetworkRequestMethod_Get content:nil response:^(NSObject *data) {
        NSMutableData *dataReturn = (NSMutableData*) data;
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization 
                              JSONObjectWithData:dataReturn //1
                              
                              options:kNilOptions 
                              error:&error];
        for (NSDictionary *part in [[json objectForKey:@"feed"] valueForKey:@"entry"])
        {
            AppStoreObject *appStoreObject = [[AppStoreObject alloc] init];
            [appStoreObject setName:[[part objectForKey:@"title"] objectForKey:@"label"]];
            [appStoreObject setCategory:[[[part objectForKey:@"category"] objectForKey:@"attributes"] objectForKey:@"label"]];
            BOOL containsObject = NO;
            for (AppStoreObject *inner in items)
            {
                if ([inner.name isEqualToString:appStoreObject.name])
                {
                    containsObject = YES;
                    break;
                }
            }
            if (!containsObject)
            {
                NSString *price = [[part objectForKey:@"im:price"] objectForKey:@"label"];
                price = [price stringByReplacingOccurrencesOfString:@"$" withString:@""];
                NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                [f setNumberStyle:NSNumberFormatterDecimalStyle];
                [appStoreObject setPrice:[f numberFromString:price]];
                
                [appStoreObject setUrl:[[part objectForKey:@"id"] objectForKey:@"label"]];
                
                numThreads++;
                SCNetworkRequest *urlRequest = [[SCNetworkRequest alloc] initWithURL:appStoreObject.url defaults:nil method:SCNetworkRequestMethod_Get content:nil response:^(NSObject *data) {
                    [self addAppStoreItemData:(NSMutableData*)data :appStoreObject];
                }];
                [urlRequest start];
            }
        }
    }];
    [request start];
}

- (void)saveToParse
{
    for (AppStoreObject *appStoreObject in items)
    {
        if (appStoreObject.url != nil && appStoreObject.rating != nil  && appStoreObject.numberReviews != nil && appStoreObject.lastUpdated != nil && appStoreObject.name != nil)
        {
            PFQuery *query = [PFQuery queryWithClassName:@"AppStoreApp"];
            [query whereKey:@"name" equalTo:appStoreObject.name];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                PFObject *appStoreParseObject;
                BOOL exsists = NO;
                if (!error) {
                    if ([objects count] == 1 && [objects lastObject] != nil)
                    {
                        appStoreParseObject = [objects lastObject];
                        exsists = YES;
                    }
                    if (!exsists)
                    {
                        if (appStoreObject.price == nil)
                        {
                            appStoreObject.price = [NSNumber numberWithInt:0];
                        }
                        appStoreParseObject = [PFObject objectWithClassName:@"AppStoreApp"];
                        [appStoreParseObject setObject:appStoreObject.category forKey:@"category"];
                        [appStoreParseObject setObject:appStoreObject.type forKey:@"type"];
                        [appStoreParseObject setObject:appStoreObject.url forKey:@"url"];
                        [appStoreParseObject setObject:appStoreObject.rating forKey:@"rating"];
                        [appStoreParseObject setObject:appStoreObject.price forKey:@"price"];
                        [appStoreParseObject setObject:appStoreObject.numberReviews forKey:@"numberReviews"];
                        [appStoreParseObject setObject:appStoreObject.lastUpdated forKey:@"lastUpdated"];
                        [appStoreParseObject setObject:appStoreObject.name forKey:@"name"];
                        NSLog(@"Updating %@", appStoreParseObject);
                        [appStoreParseObject saveInBackground];

                    }
                } 
                
            }];
        }
        else {
            NSLog(@"Can't update %@", appStoreObject);
        }
    }
}

- (void)loadFromParse
{
    appStoreParseQuery.limit = 50;
    appStoreParseQuery.skip = (page - 1) * 50;
    [appStoreParseQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Loaded: %i items from parse", [objects count]);
            for (PFObject *appStoreParseObject in objects)
            {
                AppStoreObject *appStoreObject = [[AppStoreObject alloc] init];
                [appStoreObject setType:[appStoreParseObject objectForKey:@"type"]];
                [appStoreObject setCategory:[appStoreParseObject objectForKey:@"category"]];
                [appStoreObject setUrl:[appStoreParseObject objectForKey:@"url"]];
                [appStoreObject setRating:[appStoreParseObject objectForKey:@"rating"]];
                [appStoreObject setPrice:[appStoreParseObject objectForKey:@"price"]];
                [appStoreObject setNumberReviews:[appStoreParseObject objectForKey:@"numberReviews"]];
                [appStoreObject setLastUpdated:[appStoreParseObject objectForKey:@"lastUpdated"]];
                [appStoreObject setName:[appStoreParseObject objectForKey:@"name"]];
                [items addObject:appStoreObject];
            }
            isRefreshingNewPage = NO;
            [appStoreTableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isRefreshingNewPage != YES)
    {
        lastScrollPosition = scrollView.contentOffset.y;
        for (id element in appStoreTableView.visibleCells)
            
        {
            NSIndexPath *path = [appStoreTableView indexPathForCell:element];
            if ([items count] > 0 && ([items count] - path.row) < 30)
            {
                [self loadNextPage];
                break;
            }
        }
    }  
}

- (void) loadNextPage {
    if (isRefreshingNewPage == NO)
    {
        page++;
        isRefreshingNewPage = YES;
        [self loadFromParse];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (appStoreParseQuery)
    {
        [self loadFromParse];
        isRefreshingNewPage = NO;
    }
    else {
        isRefreshingNewPage = YES;
    }
    
    numThreads = 0;
	page = 1;    
    items = [[NSMutableArray alloc] init];
    
    //-------- ADD TO LOAD FROM FILE
    //[items addObjectsFromArray:[self retrieveAppStoreObjects]];
    ////-------- 
    
    //-------- ADD TO INGEST DATA FROM TOP APP STORE LISTINGS
    /*
     urls = [[NSMutableArray alloc] initWithObjects:@"/us/rss/toppaidapplications/limit=300/json", @"/us/rss/toppaidapplications/limit=300/genre=6018/json", @"/us/rss/toppaidapplications/limit=300/genre=6000/json", @"/us/rss/toppaidapplications/limit=300/genre=6022/json", @"/us/rss/toppaidapplications/limit=300/genre=6017/json", @"/us/rss/toppaidapplications/limit=300/genre=6016/json", @"/us/rss/toppaidapplications/limit=300/genre=6015/json", @"/us/rss/toppaidapplications/limit=300/genre=6013/json", @"/us/rss/toppaidapplications/limit=300/genre=6012/json", @"/us/rss/toppaidapplications/limit=300/genre=6020/json", @"/us/rss/toppaidapplications/limit=300/genre=6011/json", @"/us/rss/toppaidapplications/limit=300/genre=6010/json", @"/us/rss/toppaidapplications/limit=300/genre=6009/json", @"/us/rss/toppaidapplications/limit=300/genre=6021/json", @"/us/rss/toppaidapplications/limit=300/genre=6008/json", @"/us/rss/toppaidapplications/limit=300/genre=6007/json", @"/us/rss/toppaidapplications/limit=300/genre=6006/json", @"/us/rss/toppaidapplications/limit=300/genre=6005/json", @"/us/rss/toppaidapplications/limit=300/genre=6004/json", @"/us/rss/toppaidapplications/limit=300/genre=6003/json", @"/us/rss/toppaidapplications/limit=300/genre=6002/json", @"/us/rss/toppaidapplications/limit=300/genre=6001/json", @"/us/rss/toppaidapplications/limit=300/genre=6014/json",nil];
    
    [urls addObjectsFromArray:[[NSArray alloc] initWithObjects:@"/us/rss/topfreeapplications/limit=300/json", @"/us/rss/topfreeapplications/limit=300/genre=6018/json", @"/us/rss/topfreeapplications/limit=300/genre=6000/json", @"/us/rss/topfreeapplications/limit=300/genre=6022/json", @"/us/rss/topfreeapplications/limit=300/genre=6017/json", @"/us/rss/topfreeapplications/limit=300/genre=6016/json", @"/us/rss/topfreeapplications/limit=300/genre=6015/json", @"/us/rss/topfreeapplications/limit=300/genre=6013/json", @"/us/rss/topfreeapplications/limit=300/genre=6012/json", @"/us/rss/topfreeapplications/limit=300/genre=6020/json", @"/us/rss/topfreeapplications/limit=300/genre=6011/json", @"/us/rss/topfreeapplications/limit=300/genre=6010/json", @"/us/rss/topfreeapplications/limit=300/genre=6009/json", @"/us/rss/topfreeapplications/limit=300/genre=6021/json", @"/us/rss/topfreeapplications/limit=300/genre=6008/json", @"/us/rss/topfreeapplications/limit=300/genre=6007/json", @"/us/rss/topfreeapplications/limit=300/genre=6006/json", @"/us/rss/topfreeapplications/limit=300/genre=6005/json", @"/us/rss/topfreeapplications/limit=300/genre=6004/json", @"/us/rss/topfreeapplications/limit=300/genre=6003/json", @"/us/rss/topfreeapplications/limit=300/genre=6002/json", @"/us/rss/topfreeapplications/limit=300/genre=6001/json", @"/us/rss/topfreeapplications/limit=300/genre=6014/json",nil]];
    
    [urls addObjectsFromArray:[[NSArray alloc] initWithObjects:@"/us/rss/topgrossingapplications/limit=300/json", @"/us/rss/topgrossingapplications/limit=300/genre=6018/json", @"/us/rss/topgrossingapplications/limit=300/genre=6000/json", @"/us/rss/topgrossingapplications/limit=300/genre=6022/json", @"/us/rss/topgrossingapplications/limit=300/genre=6017/json", @"/us/rss/topgrossingapplications/limit=300/genre=6016/json", @"/us/rss/topgrossingapplications/limit=300/genre=6015/json", @"/us/rss/topgrossingapplications/limit=300/genre=6013/json", @"/us/rss/topgrossingapplications/limit=300/genre=6012/json", @"/us/rss/topgrossingapplications/limit=300/genre=6020/json", @"/us/rss/topgrossingapplications/limit=300/genre=6011/json", @"/us/rss/topgrossingapplications/limit=300/genre=6010/json", @"/us/rss/topgrossingapplications/limit=300/genre=6009/json", @"/us/rss/topgrossingapplications/limit=300/genre=6021/json", @"/us/rss/topgrossingapplications/limit=300/genre=6008/json", @"/us/rss/topgrossingapplications/limit=300/genre=6007/json", @"/us/rss/topgrossingapplications/limit=300/genre=6006/json", @"/us/rss/topgrossingapplications/limit=300/genre=6005/json", @"/us/rss/topgrossingapplications/limit=300/genre=6004/json", @"/us/rss/topgrossingapplications/limit=300/genre=6003/json", @"/us/rss/topgrossingapplications/limit=300/genre=6002/json", @"/us/rss/topgrossingapplications/limit=300/genre=6001/json", @"/us/rss/topgrossingapplications/limit=300/genre=6014/json",nil]];
    
    [urls addObjectsFromArray:[[NSArray alloc] initWithObjects:@"/us/rss/topfreeipadapplications/limit=300/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6018/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6000/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6022/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6017/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6016/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6015/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6013/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6012/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6020/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6011/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6010/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6009/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6021/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6008/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6007/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6006/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6005/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6004/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6003/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6002/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6001/json", @"/us/rss/topfreeipadapplications/limit=300/genre=6014/json",nil]];
    
    [urls addObjectsFromArray:[[NSArray alloc] initWithObjects:@"/us/rss/toppaidipadapplications/limit=300/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6018/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6000/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6022/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6017/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6016/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6015/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6013/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6012/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6020/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6011/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6010/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6009/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6021/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6008/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6007/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6006/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6005/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6004/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6003/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6002/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6001/json", @"/us/rss/toppaidipadapplications/limit=300/genre=6014/json",nil]];
    
    [urls addObjectsFromArray:[[NSArray alloc] initWithObjects:@"/us/rss/topgrossingipadapplications/limit=300/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6018/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6000/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6022/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6017/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6016/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6015/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6013/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6012/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6020/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6011/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6010/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6009/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6021/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6008/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6007/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6006/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6005/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6004/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6003/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6002/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6001/json", @"/us/rss/topgrossingipadapplications/limit=300/genre=6014/json", nil]];
    [self processUrl:[urls lastObject]];*/
    ////-------- 
    
    //-------- ADD TO SAVE CONTENTS FROM ITEM ARRAY INTO PARSE DB
    //[self saveToParse];
    ////-------- 

    
}

// Parses the text given the entire text, start pattern and ending pattern.
- (NSString*) retrieveValue :(NSString*) value :(NSString*) startString : (NSString*) endString
{
    NSRange range = [value rangeOfString:startString];
    if (range.location != NSNotFound)
    {
        NSRange newRange = NSMakeRange (NSMaxRange(range), [value length] - NSMaxRange(range));
        NSInteger location = [value rangeOfString:endString options:NSLiteralSearch range:newRange].location;
        NSRange newRange2 = NSMakeRange ( NSMaxRange(range), location - NSMaxRange(range));
        return [value substringWithRange:newRange2];
    }
    return nil;
}

- (void)viewDidUnload
{
    [self setAppStoreTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppStoreObject *appStoreObject =[items objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: appStoreObject.url]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:@"UITableViewCell"];
    }
    AppStoreObject *appStoreObject =[items objectAtIndex:indexPath.row];
    [cell.textLabel setText:appStoreObject.name];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.usesGroupingSeparator = YES;
    numberFormatter.groupingSeparator = @",";
    numberFormatter.groupingSize = 3;
    NSString *income;
    if ([appStoreObject.type isEqualToString:@"F"])
    {
        income = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[NSNumber numberWithFloat:[appStoreObject.numberReviews floatValue] * [self numberDownloadsPerReview]] floatValue] * 0.15]];
    }
    else
    {
        income = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[appStoreObject.price floatValue] * [appStoreObject.numberReviews floatValue] * [self numberDownloadsPerReview]]];
    }
    NSString *numDownloads = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[appStoreObject.numberReviews floatValue] * [self numberDownloadsPerReview]]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@$%@ DLs:%@ Rating*:%@",appStoreObject.type,income,numDownloads,[appStoreObject.rating stringValue]]];
    cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
    return cell;
}
@end
