//
//  GameObjectFactory.h
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EnemyViewModel;
@class GridCalculator;

@interface GameObjectFactory : NSObject
@property (nonatomic, strong) GridCalculator *gridCalculator; //inject
@property (nonatomic, weak) UIView *view; //inject
- (EnemyViewModel *) createEnemyWithType:(NSInteger)type atRow:(NSInteger)row column:(NSInteger)column;
@end
