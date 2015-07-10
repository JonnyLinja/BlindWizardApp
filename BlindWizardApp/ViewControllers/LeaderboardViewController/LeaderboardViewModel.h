//
//  LeaderboardViewModel.h
//  BlindWizardApp
//
//  Created by N A on 7/10/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TopScores;

@interface LeaderboardViewModel : NSObject
@property (nonatomic, strong) TopScores *topScores; //inject
@property (nonatomic, strong, readonly) NSString *listOfTopScores;
@end
