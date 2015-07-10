//
//  EnemyView.h
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EnemyViewModel;

@interface EnemyView : UILabel
- (id) initWithViewModel:(EnemyViewModel *)viewModel;
@end
