//
//  Queue.h
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject
@property (nonatomic, assign, readonly) BOOL hasObject;
- (id) pop;
- (void) push:(id)object;
- (void) add:(id)object;
@end
