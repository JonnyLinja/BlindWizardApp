//
//  GridStorage.h
//  BlindWizardApp
//
//  Created by N A on 6/29/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridStorage : NSObject
- (void) promiseSetObject:modelMock forRow:(NSInteger)row column:(NSInteger)column;
- (id) objectForRow:(NSInteger)row column:(NSInteger)column;
- (void) promiseRemoveObjectForRow:(NSInteger)row column:(NSInteger)column;
@end
