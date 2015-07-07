//
//  GridStorage.m
//  BlindWizardApp
//
//  Created by N A on 6/29/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GridStorage.h"
#import "GridStorageKeyGenerator.h"

@interface GridStorage ()
@property (nonatomic, strong) GridStorageKeyGenerator *keyGenerator; //inject
@property (nonatomic, strong) NSMutableDictionary *objects;
@property (nonatomic, strong) NSMutableDictionary *objectsToAdd;
@property (nonatomic, strong) NSMutableArray *keysToRemove;
@end

@implementation GridStorage

- (id) initWithKeyGenerator:(GridStorageKeyGenerator *)keyGenerator {
    self = [super init];
    if(!self) return nil;
    
    self.keyGenerator = keyGenerator;
    self.objects = [NSMutableDictionary new];
    self.objectsToAdd = [NSMutableDictionary new];
    self.keysToRemove = [NSMutableArray new];
    
    return self;
}

- (id) objectForRow:(NSInteger)row column:(NSInteger)column {
    NSString *key = [self.keyGenerator stringKeyForRow:row column:column];
    return [self.objects objectForKey:key];
}

- (void) promiseSetObject:(id)obj forRow:(NSInteger)row column:(NSInteger)column {
    NSString *key = [self.keyGenerator stringKeyForRow:row column:column];
    [self.objectsToAdd setObject:obj forKey:key];
    [self.keysToRemove addObject:key];
}

- (void) promiseRemoveObjectForRow:(NSInteger)row column:(NSInteger)column {
    NSString *key = [self.keyGenerator stringKeyForRow:row column:column];
    [self.keysToRemove addObject:key];
}

- (void) fulfillPromises {
    //remove
    for(NSString *key in self.keysToRemove) {
        [self.objects removeObjectForKey:key];
    }
    [self.keysToRemove removeAllObjects];
    
    //add
    NSArray *keys = self.objectsToAdd.allKeys;
    for(NSString *key in keys) {
        id obj = [self.objectsToAdd objectForKey:key];
        [self.objects setObject:obj forKey:key];
    }
    [self.objectsToAdd removeAllObjects];
}

- (void) removeAllObjects {
    [self.objects removeAllObjects];
    [self.objectsToAdd removeAllObjects];
    [self.keysToRemove removeAllObjects];
}

@end
