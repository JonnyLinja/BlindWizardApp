//
//  ObjectPosition.h
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    CGFloat min;
    CGFloat max;
} ObjectPosition;

static inline ObjectPosition ObjectPositionMake(int row, int column) {
    ObjectPosition p;
    p.row = row;
    p.column = column;
    return p;
}
