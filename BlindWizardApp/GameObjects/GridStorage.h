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
@property (nonatomic, strong) GridStorageKeyGenerator *keyGenerator; //inject
@property (nonatomic, strong, readonly) NSMutableDictionary *objects; //testing only
@property (nonatomic, strong, readonly) NSMutableDictionary *objectsToAdd; //testing only
@property (nonatomic, strong, readonly) NSMutableArray *keysToRemove; //testing only
- (void) promiseSetObject:(id)obj forRow:(NSInteger)row column:(NSInteger)column;
- (id) objectForRow:(NSInteger)row column:(NSInteger)column;
- (void) promiseRemoveObjectForRow:(NSInteger)row column:(NSInteger)column;
- (void) fulfillPromises;
@end
