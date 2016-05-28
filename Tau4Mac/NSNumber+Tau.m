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

@dynamic youtubeCategoryName;
- ( NSString* ) youtubeCategoryName
    {
    NSUInteger integer = self.unsignedIntegerValue;
    NSString* categoryName = NSLocalizedString( @"Unknown", nil );

    switch ( integer )
        {
        case 1: categoryName = NSLocalizedString( @"Film & Animation", nil ); break;
        case 2: categoryName = NSLocalizedString( @"Autos & Vehicles", nil ); break;
        case 10: categoryName = NSLocalizedString( @"Music", nil ); break;
        case 15: categoryName = NSLocalizedString( @"Pets & Animals", nil ); break;
        case 17: categoryName = NSLocalizedString( @"Sports", nil ); break;
        case 19: categoryName = NSLocalizedString( @"Travel & Events", nil ); break;
        case 20: categoryName = NSLocalizedString( @"Gaming", nil ); break;
        case 22: categoryName = NSLocalizedString( @"People & Blogs", nil ); break;
        case 23: categoryName = NSLocalizedString( @"Comedy", nil ); break;
        case 24: categoryName = NSLocalizedString( @"Entertainment", nil ); break;
        case 25: categoryName = NSLocalizedString( @"News & Politics", nil ); break;
        case 26: categoryName = NSLocalizedString( @"Howto & Style", nil ); break;
        case 27: categoryName = NSLocalizedString( @"Education", nil ); break;
        case 28: categoryName = NSLocalizedString( @"Science & Technology", nil ); break;
        case 29: categoryName = NSLocalizedString( @"Nonprofits & Activism", nil ); break;
        }

    return categoryName;
    }

@end // NSNumber + Tau