//
//  PlayViewController.h
//  BlindWizardApp
//
//  Created by N A on 6/22/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayViewModel;

@interface PlayViewController : UIViewController
@property (nonatomic, strong) PlayViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UIButton *nextWaveButton;
- (IBAction)nextWave:(id)sender;
@end
