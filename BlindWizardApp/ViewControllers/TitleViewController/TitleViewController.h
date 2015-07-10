//
//  TitleViewController.h
//  BlindWizardApp
//
//  Created by N A on 6/22/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIButton *leaderboardButton;
- (IBAction)unwindToTitleViewController:(UIStoryboardSegue *)segue;
@end
