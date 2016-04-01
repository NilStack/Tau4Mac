//
//  NSNumber+Tau.m
//  Tau4Mac
//
//  Created by Tong G. on 3/31/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "NSNumber+Tau.h"

// NSNumber + Tau
@implementation NSNumber ( Tau )

#pragma mark - Creating an NSNumber Object

+ ( instancetype ) numberWithNegateBool: ( BOOL )_Flag
    {
    return [ self numberWithBool: !_Flag ];
    }

@end // NSNumber + Tau