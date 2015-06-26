//
//  BoardViewController.h
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoardViewModel;

@interface BoardViewController : UIViewController
@property (nonatomic, strong) BoardViewModel *viewModel; //inject
@property (nonatomic, weak) IBOutlet UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, weak) IBOutlet UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
- (IBAction)swipedLeft:(UISwipeGestureRecognizer *)sender;
- (IBAction)swipedRight:(UISwipeGestureRecognizer *)sender;
@end
