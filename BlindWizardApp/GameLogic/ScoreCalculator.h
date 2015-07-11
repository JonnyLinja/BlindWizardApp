//
//  ScoreCalculator.h
//  BlindWizardApp
//
//  Created by N A on 7/9/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreCalculator : NSObject
- (NSInteger) calculateScorePerEnemyAfterDestroying:(NSInteger)count;
- (NSInteger) calculateTotalScoreFromNumberOfEnemiesDestroyed:(NSInteger)count;
@end
