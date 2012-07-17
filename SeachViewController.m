//
//  SeachViewController.m
//  AppStoreRanking
//
//  Created by Kevin Gibbon on 12-07-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SeachViewController.h"
#import "AppStoreAppViewController.h"
#import "SCNetworkRequest.h"

@interface SeachViewController ()

@end

@implementation SeachViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    AppStoreAppViewController *appStoreAppViewController = [[AppStoreAppViewController alloc] initWithKeyword:searchBar.text];
    [[self navigationController] pushViewController:appStoreAppViewController animated:YES];
    NSString *sstring = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&country=us&entity=software", [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    SCNetworkRequest *urlRequest = [[SCNetworkRequest alloc] initWithURL:sstring defaults:nil method:SCNetworkRequestMethod_Get content:nil response:^(NSObject *data) {
        
        NSMutableData *dataReturn = (NSMutableData*) data;
        NSError* error;
        NSDictionary* json = [NSJSONSerialization 
                              JSONObjectWithData:dataReturn //1
                              
                              options:kNilOptions 
                              error:&error];
        for (NSDictionary *part in [json objectForKey:@"results"])
        {
            NSString *url = [part objectForKey:@"trackViewUrl"];
            AppStoreObject *appStoreObject = [[AppStoreObject alloc] init];
            [appStoreObject setName:[NSString stringWithFormat:@"%@ - %@",[part objectForKey:@"trackName"],[part objectForKey:@"sellerName"]]];
            [appStoreObject setUrl:url];
            [appStoreObject setPrice:[part objectForKey:@"price"]];
            [appStoreObject setCategory:[((NSArray*)[part objectForKey:@"genres"]) objectAtIndex:0]];
            SCNetworkRequest *urlRequest = [[SCNetworkRequest alloc] initWithURL:url defaults:nil method:SCNetworkRequestMethod_Get content:nil response:^(NSObject *data) {
                [appStoreAppViewController addAppStoreItemData:(NSMutableData*)data :appStoreObject];
            }];
            [urlRequest start];
        }
        
    }];
    [urlRequest start];
    }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
