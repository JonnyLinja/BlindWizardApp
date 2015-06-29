//
//  GameFactory.h
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EnemyViewModel;
@class ObjectPosition;

@interface GameFactory : NSObject
- (EnemyViewModel *) createEnemyAtRow:(NSInteger)row column:(NSInteger)column;
@end
