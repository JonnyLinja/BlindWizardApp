//
//  ObjectPosition.h
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectPosition : NSObject <NSCopying>
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;
- (id) initWithRow:(NSInteger)row andColumn:(NSInteger) column;
@end
