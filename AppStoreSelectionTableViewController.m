//
//  AppStoreSelectionTableViewController.m
//  AppStoreRanking
//
//  Created by Kevin Gibbon on 12-07-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppStoreSelectionTableViewController.h"
#import "AppStoreAppViewController.h"

@interface AppStoreSelectionTableViewController ()

@end

@implementation AppStoreSelectionTableViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    rankings = [[NSArray alloc] initWithObjects:ALL_RANKINGS,BELOW_2_STARS, BELOW_3_STARS, BELOW_4_STARS, ONLY_5_STARS, nil];
    rankingSelected = 0;
    prices = [[NSArray alloc] initWithObjects:FREE_PAID, ONLY_PAID, ONLY_FREE, ABOVE_4_99, nil];
    priceSelected = 0;
    lastUpdatedDates = [[NSArray alloc] initWithObjects:ALL_DATES, OVER_6_MONTHS, OVER_1_YEAR, OVER_2_YEARS, nil];
    lastUpdatedSelected = 0;
    sort = [[NSArray alloc] initWithObjects:NUMBER_RANKINGS, nil];
    sortSelected = 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"YES" forKey:@"enabledAutoCheck"];
    
    // Set the new settings and save
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:@"UITableViewCell"];
    }
    
    if (indexPath.row == 0)
    {
        [cell.textLabel setText:[NSString stringWithFormat:@"Rankings: %@",[rankings objectAtIndex:rankingSelected]]];
    }
    else if (indexPath.row == 1)
    {
        [cell.textLabel setText:[NSString stringWithFormat:@"Price: %@",[prices objectAtIndex:priceSelected]]];
    }
    else if (indexPath.row == 2)
    {
        [cell.textLabel setText:[NSString stringWithFormat:@"Last Updated: %@",[lastUpdatedDates objectAtIndex:lastUpdatedSelected]]];
    }
    else if (indexPath.row == 3)
    {
        [cell.textLabel setText:[NSString stringWithFormat:@"Sort: %@",[sort objectAtIndex:sortSelected]]];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if ((rankingSelected + 1) < [rankings count])
        {
            rankingSelected++;
        }
        else {
            rankingSelected = 0;
        }
    }
    else if (indexPath.row == 1)
    {
        if ((priceSelected + 1) < [prices count])
        {
            priceSelected++;
        }
        else {
            priceSelected = 0;
        }
    }
    else if (indexPath.row == 2)
    {
        if ((lastUpdatedSelected + 1) < [lastUpdatedDates count])
        {
            lastUpdatedSelected++;
        }
        else {
            lastUpdatedSelected = 0;
        }
    }
    else if (indexPath.row == 3)
    {
        if ((sortSelected + 1) < [sort count])
        {
            sortSelected++;
        }
        else {
            sortSelected = 0;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}

- (IBAction)rankingsButtonPressed:(id)sender {
    AppStoreAppViewController *appStoreAppViewController = [[AppStoreAppViewController alloc] initWithFilter:[rankings objectAtIndex:rankingSelected] :[prices objectAtIndex:priceSelected] :[lastUpdatedDates objectAtIndex:lastUpdatedSelected]];
    [[self navigationController] pushViewController:appStoreAppViewController animated:YES];
}

- (IBAction)ingestDataButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not implemented" message:@"Data ingest is not currently implemented. Look at the AppStoreAppViewController.processUrl() for more info."
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];	
    return;
}
@end
