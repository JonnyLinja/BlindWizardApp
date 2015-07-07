//
//  PlayViewController.h
//  BlindWizardApp
//
//  Created by N A on 6/22/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GridCalculatorFactory;
@class PlayViewModel;

@interface PlayViewController : UIViewController
@property (nonatomic, strong) PlayViewModel *viewModel; //inject
@property (nonatomic, strong) id<GridCalculatorFactory> factory; //inject
@property (nonatomic, weak) IBOutlet UIView *boardView;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UIButton *nextWaveButton;
@property (nonatomic, weak) IBOutlet UIButton *playAgainButton;
- (IBAction)tappedNextWave:(id)sender;
- (IBAction)tappedPlayAgain:(id)sender;
@end
