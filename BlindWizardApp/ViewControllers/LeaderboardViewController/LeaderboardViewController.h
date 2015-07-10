//
//  LeaderboardViewController.h
//  BlindWizardApp
//
//  Created by N A on 6/22/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeaderboardViewModel;

@interface LeaderboardViewController : UIViewController
@property (nonatomic, strong) LeaderboardViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UILabel *displayLabel;
@end
