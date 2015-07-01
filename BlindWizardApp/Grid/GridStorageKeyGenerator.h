//
//  GridStorageKeyGenerator.h
//  BlindWizardApp
//
//  Created by N A on 6/30/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridStorageKeyGenerator : NSObject
- (NSString *) stringKeyForRow:(NSInteger)row column:(NSInteger)column;
@end
