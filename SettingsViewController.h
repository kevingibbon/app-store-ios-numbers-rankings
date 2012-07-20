//
//  SettingsViewController.h
//  AppStoreRanking
//
//  Created by Kevin Gibbon on 12-07-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *editField;
- (IBAction)editingFinished:(id)sender;
- (IBAction)editFieldTouched:(id)sender;

@end
