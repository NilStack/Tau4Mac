//
//  TauTestCase.m
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauTestCase.h"

// TauTestCase class
@implementation TauTestCase

#pragma mark - Initializations

- ( void ) setUp
    {
    [ super setUp ];
    }

#pragma mark - Testing

#define POS_TEST_METHOD_MARKER @"_pos"
#define NEG_TEST_METHOD_MARKER @"_neg"

+ ( BOOL ) isTestMethodPositive: ( SEL )_TestMethodSel
    {
    NSString* selString = NSStringFromSelector( _TestMethodSel );
    return [ [ selString substringWithRange: NSMakeRange( selString.length - POS_TEST_METHOD_MARKER.length - 1, POS_TEST_METHOD_MARKER.length ) ] isEqualToString: POS_TEST_METHOD_MARKER ];
    }

+ ( BOOL ) isTestMethodNegative: ( SEL )_TestMethodSel
    {
    NSString* selString = NSStringFromSelector( _TestMethodSel );
    return [ [ selString substringWithRange: NSMakeRange( selString.length - NEG_TEST_METHOD_MARKER.length - 1, NEG_TEST_METHOD_MARKER.length ) ] isEqualToString: NEG_TEST_METHOD_MARKER ];
    }

@end // TauTestCase class