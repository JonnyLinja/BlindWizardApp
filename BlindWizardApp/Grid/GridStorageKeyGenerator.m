//
//  GridStorageKeyGenerator.m
//  BlindWizardApp
//
//  Created by N A on 6/30/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GridStorageKeyGenerator.h"

@implementation GridStorageKeyGenerator

- (NSString *) stringKeyForRow:(NSInteger)row column:(NSInteger)column {
    return [NSString stringWithFormat:@"%zd:%zd", row, column];
}

@end
