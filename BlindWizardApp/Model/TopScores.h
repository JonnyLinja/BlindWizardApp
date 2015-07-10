//
//  TopScores.h
//  BlindWizardApp
//
//  Created by N A on 7/10/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopScores : NSObject
@property (nonatomic, strong, readonly) NSArray *scores;
- (void) addScore:(NSInteger)score;
@end
