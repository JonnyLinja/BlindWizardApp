//
//  GameBoard.h
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameBoard : NSObject
@property (nonatomic, assign, readonly) NSInteger score;
@property (nonatomic, assign, readonly) BOOL isActive;
@end
