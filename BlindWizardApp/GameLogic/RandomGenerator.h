//
//  RandomGenerator.h
//  BlindWizardApp
//
//  Created by N A on 7/1/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomGenerator : NSObject
@property (nonatomic, assign) NSInteger minimum;
@property (nonatomic, assign) NSInteger maximum;
- (NSInteger) generate;
@end