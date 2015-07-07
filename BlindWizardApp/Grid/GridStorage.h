//
//  GridStorage.h
//  BlindWizardApp
//
//  Created by N A on 6/29/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GridStorageKeyGenerator;

@interface GridStorage : NSObject
- (id) initWithKeyGenerator:(GridStorageKeyGenerator *)keyGenerator;
- (id) objectForRow:(NSInteger)row column:(NSInteger)column;
- (void) promiseSetObject:(id)obj forRow:(NSInteger)row column:(NSInteger)column;
- (void) promiseRemoveObjectForRow:(NSInteger)row column:(NSInteger)column;
- (void) fulfillPromises;
- (void) removeAllObjects;
@end
