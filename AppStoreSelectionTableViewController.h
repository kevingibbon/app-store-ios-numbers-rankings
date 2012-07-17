//
//  AppStoreSelectionTableViewController.h
//  AppStoreRanking
//
//  Created by Kevin Gibbon on 12-07-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ALL_RANKINGS @"All rankings"
#define BELOW_2_STARS @"1 or below stars"
#define BELOW_3_STARS @"2 or below stars"
#define BELOW_4_STARS @"3 or below stars"
#define BELOW_5_STARS @"4 or below stars"
#define ONLY_5_STARS @"Only 5 stars"

#define FREE_PAID @"Free and Paid"
#define ONLY_PAID @"Only Paid"
#define ONLY_FREE @"Only Free"
#define ABOVE_4_99 @"Above $4.99"

#define ALL_DATES @"All Dates"
#define OVER_6_MONTHS @"over 6 months"
#define OVER_1_YEAR @"over 1 year"
#define OVER_2_YEARS @"over 2 years"

#define NUMBER_RANKINGS @"Number of Rankings"

@interface AppStoreSelectionTableViewController : UITableViewController
{
    NSArray *rankings;
    NSInteger rankingSelected;
    NSArray *prices;
    NSInteger priceSelected;
    NSArray *lastUpdatedDates;
    NSInteger lastUpdatedSelected;
    NSArray *sort;
    NSInteger sortSelected;
    
}
- (IBAction)rankingsButtonPressed:(id)sender;
- (IBAction)ingestDataButtonPressed:(id)sender;

@end
