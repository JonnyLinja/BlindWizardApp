//
//  Game.h
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject
@property (nonatomic, assign, readonly) NSInteger score;
- (void) callNextWave;
@end
