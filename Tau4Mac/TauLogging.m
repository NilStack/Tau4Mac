//
//  TauLogging.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauLogging.h"
#import "TauTTYLogFormatter.h"
#import "NSColor+TauDrawing.h"

__attribute__( ( constructor ) )
void TAU_PRIVATE sConfigureLogging()
    {
    dispatch_once_t static onceToken;

    dispatch_once( &onceToken, ( dispatch_block_t )^{
        DDTTYLogger* sharedTTYLogger = [ DDTTYLogger sharedInstance ];

        NSColor* fatalColor =          [ NSColor colorWithHTMLColor: @"CC0066" ];
        NSColor* recoverableErrColor = [ NSColor colorWithHTMLColor: @"FE6262" ];
        NSColor* warningColor =        [ NSColor colorWithHTMLColor: @"FEFEA4" ];
        NSColor* expectingColor =      [ NSColor colorWithHTMLColor: @"8CF191" ];
        NSColor* infoColor =           [ NSColor colorWithHTMLColor: @"D5FBFF" ];
        NSColor* verboseColor =        [ NSColor colorWithHTMLColor: @"CACBCE" ];

        [ sharedTTYLogger setColorsEnabled: YES ];
        [ sharedTTYLogger setForegroundColor: fatalColor backgroundColor: [ NSColor whiteColor ] forFlag: DDLogFlagFatal ];

        [ sharedTTYLogger setForegroundColor: recoverableErrColor backgroundColor: nil forFlag: DDLogFlagRecoverable ];
        [ sharedTTYLogger setForegroundColor: recoverableErrColor backgroundColor: nil forFlag: DDLogFlagLocalError ];
        [ sharedTTYLogger setForegroundColor: recoverableErrColor backgroundColor: nil forFlag: DDLogFlagNetworkError ];
        [ sharedTTYLogger setForegroundColor: recoverableErrColor backgroundColor: nil forFlag: DDLogFlagUserError ];

        [ sharedTTYLogger setForegroundColor: warningColor backgroundColor: nil forFlag: DDLogFlagWarning ];
        [ sharedTTYLogger setForegroundColor: warningColor backgroundColor: nil forFlag: DDLogFlagNotice ];
        [ sharedTTYLogger setForegroundColor: warningColor backgroundColor: nil forFlag: DDLogFlagUnexpected ];

        [ sharedTTYLogger setForegroundColor: infoColor backgroundColor: nil forFlag: DDLogFlagInfo ];
        [ sharedTTYLogger setForegroundColor: infoColor backgroundColor: nil forFlag: DDLogFlagDebug ];
        [ sharedTTYLogger setForegroundColor: expectingColor backgroundColor: nil forFlag: DDLogFlagExpecting ];
        [ sharedTTYLogger setForegroundColor: verboseColor backgroundColor: nil forFlag: DDLogFlagVerbose ];

        NSColor* tmsInitialTrialColor = [ NSColor colorWithHTMLColor: @"FC85C8" ];
        NSColor* tmsCreateFetchingUnitColor = [ NSColor colorWithHTMLColor: @"BF7A3E" ];
        NSColor* tmsFetchingUnitsCountColor = [ NSColor colorWithHTMLColor: @"07DFE2" ];
        NSColor* tmsEnqueueColor = [ NSColor colorWithHTMLColor: @"FFAE29" ];
        NSColor* tmsDiscardableColor = [ NSColor colorWithHTMLColor: @"941751" ];

        [ sharedTTYLogger setForegroundColor: tmsInitialTrialColor backgroundColor: nil forFlag: TMSLogFlagInitialTrial ];
        [ sharedTTYLogger setForegroundColor: tmsCreateFetchingUnitColor backgroundColor: nil forFlag: TMSLogFlagCreateFetchingUnit ];
        [ sharedTTYLogger setForegroundColor: tmsFetchingUnitsCountColor backgroundColor: nil forFlag: TMSLogFlagFetchingUnitsCount ];
        [ sharedTTYLogger setForegroundColor: tmsEnqueueColor backgroundColor: nil forFlag: TMSLogFlagEnqueueFetchingUnit ];
        [ sharedTTYLogger setForegroundColor: tmsDiscardableColor backgroundColor: nil forFlag: TMSLogFlagFetchingUnitDiscardable ];

        [ sharedTTYLogger setLogFormatter: [ [ TauTTYLogFormatter alloc ] init ] ];
        [ DDLog addLogger: sharedTTYLogger ];
        } );
    }