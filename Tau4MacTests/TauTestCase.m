//
//  TauTestCase.m
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauTestCase.h"
#import "TauTTYLogFormatter.h"
#import "NSColor+TauDrawing.h"

// TauTestCase class
@implementation TauTestCase

#pragma mark - Initializations

- ( void ) setUp
    {
    [ super setUp ];

    DDTTYLogger* sharedTTYLogger = [ DDTTYLogger sharedInstance ];

    // Light Red
    NSColor* fatalErrOutputColor = [ NSColor colorWithHTMLColor: @"cc0066" ];
    NSColor* recoverableErrOutputColor = [ NSColor colorWithHTMLColor: @"FE6262" ];

    // Light Blue
    NSColor* infoOutputColor = [ NSColor colorWithHTMLColor: @"D5FBFF" ];

    // Light Orange
    NSColor* warningOutputColor = [ NSColor colorWithHTMLColor: @"FEFEA4" ];
    NSColor* verboseOutputColor = [ NSColor colorWithHTMLColor: @"CACBCE" ];

    [ sharedTTYLogger setColorsEnabled: YES ];
    [ sharedTTYLogger setForegroundColor: fatalErrOutputColor backgroundColor: [ NSColor whiteColor ] forFlag: DDLogFlagFatal ];
    [ sharedTTYLogger setForegroundColor: recoverableErrOutputColor backgroundColor: nil forFlag: DDLogFlagRecoverable ];

    [ sharedTTYLogger setForegroundColor: infoOutputColor backgroundColor: nil forFlag: DDLogFlagInfo ];
    [ sharedTTYLogger setForegroundColor: infoOutputColor backgroundColor: nil forFlag: DDLogFlagDebug ];

    [ sharedTTYLogger setForegroundColor: warningOutputColor backgroundColor: nil forFlag: DDLogFlagWarning ];
    [ sharedTTYLogger setForegroundColor: warningOutputColor backgroundColor: nil forFlag: DDLogFlagNotice ];
    [ sharedTTYLogger setForegroundColor: warningOutputColor backgroundColor: nil forFlag: DDLogFlagUnexpected ];

    [ sharedTTYLogger setForegroundColor: verboseOutputColor backgroundColor: nil forFlag: DDLogFlagVerbose ];

    [ sharedTTYLogger setLogFormatter: [ [ TauTTYLogFormatter alloc ] init ] ];
    [ DDLog addLogger: sharedTTYLogger ];
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